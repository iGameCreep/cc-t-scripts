local monitors = { peripheral.find("monitor") } :: { MonitorAPI }
for _, monitor in pairs(monitors) do
	monitor.setBackgroundColor(colors.blue)
	monitor.write("Hello")
end
