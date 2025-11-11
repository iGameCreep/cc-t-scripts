local monitors = { peripheral.find("monitor") } :: { MonitorAPI }
for _, monitor in pairs(monitors) do
	monitor.write("Hello")
end
