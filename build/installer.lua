local base="https://raw.githubusercontent.com/iGameCreep/cc-t-scripts/master/"
local folder="build/"
local files={
"script.lua",
}do local _DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c, _DALBIT_REMOVE_GENERALIZED_ITERATION_invarfa2977eb7154da9c, _DALBIT_REMOVE_GENERALIZED_ITERATION_controlfa2977eb7154da9c=

ipairs(files)if type(_DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c)=='table'then local m=__DALBIT_getmetatable_iter(_DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c)if type(m)=='table'and type(m.__iter)=='function'then _DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c, _DALBIT_REMOVE_GENERALIZED_ITERATION_invarfa2977eb7154da9c, _DALBIT_REMOVE_GENERALIZED_ITERATION_controlfa2977eb7154da9c=m.__iter(_DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c)else _DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c, _DALBIT_REMOVE_GENERALIZED_ITERATION_invarfa2977eb7154da9c, _DALBIT_REMOVE_GENERALIZED_ITERATION_controlfa2977eb7154da9c=next, _DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c end end for _,file in _DALBIT_REMOVE_GENERALIZED_ITERATION_iterfa2977eb7154da9c,_DALBIT_REMOVE_GENERALIZED_ITERATION_invarfa2977eb7154da9c,_DALBIT_REMOVE_GENERALIZED_ITERATION_controlfa2977eb7154da9c do
local url=base..folder..file
print("Downloading "..file.."...")
local ok=http.get(url)
if ok then
local handle=fs.open(file,"w")
if not handle then
print"no handle!"
return
end
handle.write(ok.readAll()or"did not read :(")
handle.close()
ok.close()
print" -> Done"
else
print(" -> Failed: "..url)
end
end end

print"All done!"