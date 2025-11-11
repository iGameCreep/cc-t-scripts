--!strict
-- types/computercraft.d.luau
-- Type definitions for ComputerCraft:Tweaked APIs
-- https://tweaked.cc/

-- ## OS API
export type OSAPI = {
    getComputerID: () -> number,
    getComputerLabel: () -> string?,
    setComputerLabel: (label: string?) -> (),
    clock: () -> number,
    time: (tz: string?) -> number,
    day: (tz: string?) -> number,
    epoch: (tz: string?) -> number,
    queueEvent: (name: string, ...any) -> (),
    pullEvent: (filter: string?) -> (string, ...any),
    sleep: (time: number) -> (),
    startTimer: (timeout: number) -> number,
    cancelTimer: (id: number) -> (),
    shutdown: () -> (),
    reboot: () -> (),
}

-- ## FS API
export type FileHandle = {
    readAll: () -> string?,
    readLine: (withTrailing: boolean | nil) -> string?,
    read: (count: number) -> string?,
    write: (text: string) -> (),
    writeLine: (text: string) -> (),
    flush: () -> (),
    close: () -> (),
}

export type FSAPI = {
    open: (path: string, mode: string) -> FileHandle?,
    exists: (path: string) -> boolean,
    isDir: (path: string) -> boolean,
    makeDir: (path: string) -> (),
    list: (path: string) -> { string },
    getName: (path: string) -> string,
    getSize: (path: string) -> number,
    delete: (path: string) -> (),
    move: (from: string, to: string) -> (),
    copy: (from: string, to: string) -> (),
    combine: (a: string, b: string) -> string,
}

-- ## TERM API
export type TermAPI = {
    write: (text: string) -> (),
    clear: () -> (),
    clearLine: () -> (),
    getCursorPos: () -> (number, number),
    setCursorPos: (x: number, y: number) -> (),
    setTextColor: (color: number) -> (),
    setBackgroundColor: (color: number) -> (),
    isColor: () -> boolean,
    scroll: (n: number) -> (),
    blit: (text: string, textColors: string, bgColors: string) -> (),
}

-- ## PERIPHERAL API
export type PeripheralAPI = {
    getNames: () -> { string },
    isPresent: (side: string) -> boolean,
    getType: (side: string) -> string,
    wrap: (side: string) -> any?,
    call: (side: string, method: string, ...any) -> ...any,
    find: (ty: string, filter: ((name: string, wrapped: any) -> boolean) | nil) -> {}
}

-- ## REDSTONE API
export type RedstoneAPI = {
    getSides: () -> { string },
    getInput: (side: string) -> boolean,
    setOutput: (side: string, on: boolean) -> (),
    getOutput: (side: string) -> boolean,
    getAnalogInput: (side: string) -> number,
    setAnalogOutput: (side: string, value: number) -> (),
    getAnalogOutput: (side: string) -> number,
}

-- ## HTTP API
export type HTTPResponse = {
    readAll: () -> string?,
    close: () -> (),
    getResponseCode: () -> number,
}

export type HTTPAPI = {
    get: (url: string, headers: { [string]: string } | nil) -> HTTPResponse?,
    post: (url: string, body: string, headers: { [string]: string } | nil) -> HTTPResponse?,
    request: (url: string, body: string | nil, headers: { [string]: string } | nil, binary: boolean | nil) -> (),
    checkURL: (url: string) -> boolean,
}

-- ## TURTLE API (if applicable)
export type TurtleAPI = {
    forward: () -> boolean,
    back: () -> boolean,
    up: () -> boolean,
    down: () -> boolean,
    turnLeft: () -> boolean,
    turnRight: () -> boolean,
    dig: (side: string | nil) -> boolean,
    place: (side: string | nil) -> boolean,
    select: (slot: number) -> boolean,
    getItemCount: (slot: number | nil) -> number,
    getFuelLevel: () -> number | "unlimited",
    refuel: (count: number | nil) -> boolean,
}

-- ## PERIPHERALS
export type MonitorAPI = {
    -- Cursor & text scale
    setTextScale: (scale: number) -> (),
    getTextScale: () -> number,
    getCursorPos: () -> (number, number),
    setCursorPos: (x: number, y: number) -> (),
    getCursorBlink: () -> boolean,
    setCursorBlink: (blink: boolean) -> (),

    -- Writing & scrolling
    write: (text: string) -> (),
    scroll: (y: number) -> (),
    blit: (text: string, textColour: string, backgroundColour: string) -> (),

    -- Size & clearing
    getSize: () -> (number, number),
    clear: () -> (),
    clearLine: () -> (),

    -- Text colours
    getTextColour: () -> number,
    getTextColor: () -> number,
    setTextColour: (colour: number) -> (),
    setTextColor: (colour: number) -> (),

    -- Background colours
    getBackgroundColour: () -> number,
    getBackgroundColor: () -> number,
    setBackgroundColour: (colour: number) -> (),
    setBackgroundColor: (colour: number) -> (),

    -- Colour support
    isColour: () -> boolean,
    isColor: () -> boolean,

    -- Palette
    setPaletteColour: (...any) -> (),  -- Accepts variable arguments depending on usage
    setPaletteColor: (...any) -> (),
    getPaletteColour: (colour: number) -> number,
    getPaletteColor: (colour: number) -> number,
}

-- ## GLOBALS
declare os: OSAPI
declare fs: FSAPI
declare term: TermAPI
declare peripheral: PeripheralAPI
declare redstone: RedstoneAPI
declare http: HTTPAPI
declare turtle: TurtleAPI

-- ## Other globals
declare sleep: (seconds: number) -> ()
declare print: (...any) -> ()
declare write: (text: string) -> ()
declare read: (replaceChar: string | nil) -> string
