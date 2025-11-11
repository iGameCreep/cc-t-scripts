local base = "https://raw.githubusercontent.com/iGameCreep/cc-t-scripts/master/"
local folder = "build/"
local files = {
	"script.lua",
}

for _, file in ipairs(files) do
	local url = base .. folder .. file
	print("Downloading " .. file .. "...")
	local ok = http.get(url)
	if ok then
		local handle = fs.open(file, "w")
		if not handle then
			print("no handle!")
			return
		end
		handle.write(ok.readAll() or "did not read :(")
		handle.close()
		ok.close()
		print(" -> Done")
	else
		print(" -> Failed: " .. url)
	end
end

print("All done!")
