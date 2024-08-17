local options = {
    rednet_identifier = '',
    energy_type = 'FE',
    update_frequency = 1,
    text_scale = 1,
    debug = true,
}

local INSTALLER_ID = 'LMdUZY4Z'
local energy_suffixes = { 'k', 'M', 'G', 'T', 'P' }
local time_periods = {
    { 'weeks', 604800 },
    { 'days', 86400 },
    { 'hours', 3600 },
    { 'minutes', 60 },
    { 'seconds', 1 },
}

local induction_matrix = nil
local monitor = nil
local modem = nil
local rednet_prefix = 'WL_Mek_Matrix'

function file_read (file)
    local handle = fs.open(file, 'r')
    local data = handle.readAll()
    handle.close()
    return data
end

function file_write (file, data)
    local handle = fs.open(file, 'w')
    handle.write(data)
    handle.close()
end

local machine_term = term.current()
local print_buffer = {}

function print_r (text)
    table.insert(print_buffer, text)
end

function print_f (format, ...)
    print_r(string.format(format, ...))
end

function print_flush ()
    if monitor then
        if monitor then
            term.redirect(monitor)
        end

        term.clear()
        term.setCursorPos(1, 1)

        print(table.concat(print_buffer or {}, '\n'))

        if monitor then
            term.redirect(machine_term)
        end
    end

    print_buffer = {}
end

function debug (...)
    if options.debug then
        print(...)
    end
end

function round_decimal (number, decimals)
    local multiplier = math.pow(10, decimals or 0)
    return math.floor(number * multiplier) / multiplier
end

function round_percentage (number, decimals)
    return ('%s%%'):format(round_decimal(100 * number, decimals or 1))
end

local energy_type = 'J'

local energy_convert = function (energy) return energy end
if mekanismEnergyHelper and mekanismEnergyHelper[('joulesTo%s'):format(options.energy_type)] then
    energy_type = options.energy_type
    energy_convert = mekanismEnergyHelper[('joulesTo%s'):format(options.energy_type)]
end

local energy_string = function (energy, decimals)
    local prefix = ''
    local suffix = ''

    if energy < 0 then
        prefix = '-'
    end

    local amount = energy_convert(math.abs(energy))

    for _, multiplier in pairs(energy_suffixes) do
        if amount < 1000 then
            break
        end

        amount = amount / 1000
        suffix = multiplier
    end

    return ('%s%s%s%s'):format(prefix, round_decimal(amount, decimals or 1), suffix, energy_type)
end

function eta_string (seconds)
    seconds = math.floor(seconds)

    local time = {}
    for _, period in pairs(time_periods) do
        local count = math.floor(seconds / period[2])
        time[period[1]] = count
        seconds = seconds - (count * period[2])
    end

    if time.weeks > 0 then
        return ('%dwk %dd %dh'):format(time.weeks, time.days, time.hours)
    elseif time.days >= 3 then
        return ('%dd %dh'):format(time.days, time.hours)
    end

    return ('%d:%02d:%02d'):format(time.hours, time.minutes, time.seconds)
end

function print_matrix_info (matrix_info)
    print_r('Ind.Matrix Monitor')
    print_r('------------------')
    print_r('')
    print_f('Power : %s', energy_string(matrix_info.energy_stored))
    print_f('Limit : %s', energy_string(matrix_info.energy_capacity))
    print_f('Charge: %s', round_percentage(matrix_info.energy_percentage))
    print_r('')
    print_f('Input : %s/t', energy_string(matrix_info.io_input))
    print_f('Output: %s/t', energy_string(matrix_info.io_output))
    print_f('Max IO: %s/t', energy_string(matrix_info.io_capacity))
    print_r('')

    if matrix_info.change_amount < 0 then
        print_f('Change:%s/s', energy_string(matrix_info.change_amount_per_second))
    else
        print_f('Change: %s/s', energy_string(matrix_info.change_amount_per_second))
    end

    print_r('Status:')
    if matrix_info.is_charging then
        print_f('Charg. %s', eta_string((matrix_info.energy_capacity - matrix_info.energy_stored) / matrix_info.change_amount_per_second))
    elseif matrix_info.is_discharging then
        print_f('Disch. %s', eta_string(matrix_info.energy_stored / math.abs(matrix_info.change_amount_per_second)))
    else
        print_r('Idle')
    end
end

args = {...}

if fs.exists('config') then
    debug('Loading settings from "config" file...')

    local custom_options = textutils.unserialize(file_read('config'))

    for k, v in pairs(custom_options) do
        options[k] = v
    end
end

print('Updating config file...')
file_write('config', textutils.serialize(options))

if 'install' == args[1] then
    print('Installing Matrix Monitor...')

    local has_existing_install = fs.exists('startup.lua')

    if fs.exists('startup.lua') then
        fs.delete('startup.lua')
    end

    shell.run('pastebin', 'get', INSTALLER_ID, 'startup.lua')

    if not has_existing_install then
        print('Opening config file for editing...')
        sleep(2.5)
        shell.run('edit', 'config')
    end

    print('Install complete! Restarting computer...')
    sleep(2.5)
    os.reboot()
end

monitor = peripheral.find('monitor')
modem = peripheral.find('modem')

local rednet_channel = nil

if monitor then
    debug('Monitor detected, enabling output!')
    monitor.setTextScale(options.text_scale)
else
    debug('No monitor detected, entering headless mode!')

    if not modem then
        error('No monitor or modem detected, cannot enter headless mode!')
    end
end

if peripheral.find('modem') then
    if not options.rednet_identifier or options.rednet_identifier == '' then
        debug('Modem has been found, but no wireless identifier found on configs, will not connect!')
    else
        peripheral.find('modem', rednet.open)
        debug('Connected to rednet!')
        rednet_channel = ('%s#%s'):format(rednet_prefix, options.rednet_identifier)
    end
end

debug('Entering main loop...')

local energy_stored_previous = nil

while true do
    local status, err = pcall(function () 
        if not induction_matrix then
            induction_matrix = peripheral.find('inductionPort')

            if not induction_matrix then
                error('Induction Port not connected!')
            end
        end

        local matrix_info = {
            energy_stored = induction_matrix.getEnergy(),
            energy_capacity = induction_matrix.getMaxEnergy(),
            energy_percentage = induction_matrix.getEnergyFilledPercentage(),
            io_input = induction_matrix.getLastInput(),
            io_output = induction_matrix.getLastOutput(),
            io_capacity = induction_matrix.getTransferCap(),
        }

        if not energy_stored_previous then
            energy_stored_previous = matrix_info.energy_stored
        end

        matrix_info.change_interval = options.update_frequency
        matrix_info.change_amount = matrix_info.energy_stored - energy_stored_previous
        matrix_info.change_amount_per_second = matrix_info.change_amount / options.update_frequency

        matrix_info.is_charging = matrix_info.change_amount > 0
        matrix_info.is_discharging = matrix_info.change_amount < 0

        energy_stored_previous = matrix_info.energy_stored

        if rednet.isOpen() and rednet_channel then
            rednet.broadcast(textutils.serialize(matrix_info), rednet_channel)
        end

        print_matrix_info(matrix_info)
    end)

    if not status then
        print_buffer = {}

        print_r('Error reading data')
        print_r('Check connections.')
        print_r('------------------')
        print_r(err)
    end

    print_flush()

    os.sleep(options.update_frequency)
end
