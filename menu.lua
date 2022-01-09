_G.NiggerVision = _G.NiggerVision or {}
NiggerVision._path = ModPath
NiggerVision._data_path = ModPath .. "data.json"
NiggerVision._data = {}

NiggerVision.oldMasks = {}

for i, v in pairs(tweak_data.blackmarket.masks) do
	NiggerVision.oldMasks[i] = v.night_vision
end

function NiggerVision:Save()
	local file = io.open(self._data_path, "w+")
	if file then
		file:write(json.encode(self._data))
		file:close()
	end
end

function NiggerVision:Load()
	local file = io.open(self._data_path, "r")
	if file then
		self._data = json.decode(file:read("*all"))
		file:close()
	end
	NiggerVision.apply(self._data.color)
end

function NiggerVision.apply(value)
	for i, v in pairs(tweak_data.blackmarket.masks) do
		if value == 1 then
			v.night_vision = NiggerVision.oldMasks[i]
		else
			v.night_vision = {
				effect = "color_night_vision" .. (value == 3 and "_blue" or ""),
				light = not _G.IS_VR and 0.3 or 0.1
			}
		end
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_JsonMenuExample", function(loc)
	loc:load_localization_file(NiggerVision._path .. "en.json")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_NiggerVision", function()
	function MenuCallbackHandler.callback_niggerColor(self, item)
		NiggerVision._data.color = item:value()
		NiggerVision:Save()
		NiggerVision.apply(item:value())
	end
	NiggerVision:Load()
	MenuHelper:LoadFromJsonFile(NiggerVision._path .. "menu.json", NiggerVision, NiggerVision._data)
end)