-- **********************************************************************
-- GnomTEC Weather
-- Version: 5.4.2.2
-- Author: GnomTEC
-- Copyright 2014 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_Weather")

-- ----------------------------------------------------------------------
-- Addon global Constants (local)
-- ----------------------------------------------------------------------

-- default data for database
local defaultsDb = {
	realm = {
		["Weather"] = {
			["Stormwind"] = {
				["20140125"] = { 
					["MORNING"] = {
						["TIME"] = 0646,
						["PICTOGRAM"] = "DAY_PARTLY_DRY",
						["DESCRIPTION"] = "Kalt, frostig... jedoch nur leicht bewölkt. Zieht eure Handschuhe an.",
					},
					["MIDDAY"] = {
						["TIME"] = 1143,
						["PICTOGRAM"] = "DAY_CLEAR",
						["DESCRIPTION"] = "Die Sonne bricht durch dich sich auflösende Wolkenschicht. Es ist frisch und kalt, aber was erwartet man auch anderes vom WInter? Der Schnee an den Straßenrändern färbt sich langsam gräulich.|nHolzfäller sowie Pelzhändler machen gewiss gute Geschäfte.",
					},
					["EVENING"] = {
						["TIME"] = 1613,
						["PICTOGRAM"] = "DAY_CLEAR",
						["DESCRIPTION"] = "Kalt, einfach nur verflucht kalt. Beim Sprechen bilden sich kleine Wölkchen und man ist versucht sich noch ein zweites paar Handschuhe drüber zu ziehen. Die Sonne geht um 17.13Uhr unter. Vermutlich nutzt der ein oder Andere die frühe Dunkelheit um in den Wald zu gehen und unerlaubt sich etwas abzuholzen. ",
					},
					["NIGHT"] = {
						["TIME"] = 2019,
						["PICTOGRAM"] = "NIGHT_CLEAR",
						["DESCRIPTION"] = "Sternenklar und beide Monde sorgen für etwas Licht am Himmel. Was für den einen Kalt- romatisch ist ist für den Anderen sich den Allerwertesten abfrieren. Kennen die Götter den keine Gnade? Perfektes Wetter um keine Raubzüge zu machen oder sich heimlich im Wald etwas Holz zu stibitzen, irgendwie muss man ja über die Runden kommen.",
					}
				}
			}
		}
	}
}

local weatherTexturesDayList = {
	["NONE"] = "NONE", 
	["DAY_CLEAR"] = "DAY_CLEAR",
	["DAY_PARTLY_DRY"] = "DAY_PARTLY_DRY",
	["DAY_PARTLY_FOG"] = "DAY_PARTLY_FOG",
	["DAY_PARTLY_RAIN"] = "DAY_PARTLY_RAIN",
	["DAY_PARTLY_SNOW"] = "DAY_PARTLY_SNOW",
	["DAY_CLOUDY_DRY"] = "DAY_CLOUDY_DRY",
	["DAY_CLOUDY_FOG"] = "DAY_CLOUDY_FOG",
	["DAY_CLOUDY_RAIN"] = "DAY_CLOUDY_RAIN",
	["DAY_CLOUDY_SNOW"] = "DAY_CLOUDY_SNOW",
}

local weatherTexturesDay = {
	["NONE"] = "Interface\\AddOns\\GnomTEC_Weather\\Textures\\thermometer",
	["DAY_CLEAR"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\sun",
	["DAY_PARTLY_DRY"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\sun_and_cloud",
	["DAY_PARTLY_FOG"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\sun_and_fog",
	["DAY_PARTLY_RAIN"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\sun_rain_and_cloud",
	["DAY_PARTLY_SNOW"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\sun_snow_and_cloud",
	["DAY_CLOUDY_DRY"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud",
	["DAY_CLOUDY_FOG"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud_fog",
	["DAY_CLOUDY_RAIN"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud_rain",
	["DAY_CLOUDY_SNOW"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud_snow",
}

local weatherTexturesNightList = {
	["NONE"] = "NONE", 
	["NIGHT_CLEAR"] = "NIGHT_CLEAR",
	["NIGHT_PARTLY_DRY"] = "NIGHT_PARTLY_DRY",
	["NIGHT_PARTLY_FOG"] = "NIGHT_PARTLY_FOG",
	["NIGHT_PARTLY_RAIN"] = "NIGHT_PARTLY_RAIN",
	["NIGHT_PARTLY_SNOW"] = "NIGHT_PARTLY_SNOW",
	["NIGHT_CLOUDY_DRY"] = "NIGHT_CLOUDY_DRY",
	["NIGHT_CLOUDY_FOG"] = "NIGHT_CLOUDY_FOG",
	["NIGHT_CLOUDY_RAIN"] = "NIGHT_CLOUDY_RAIN",
	["NIGHT_CLOUDY_SNOW"] = "NIGHT_CLOUDY_SNOW",
}

local weatherTexturesNight = {
	["NONE"] = "Interface\\AddOns\\GnomTEC_Weather\\Textures\\thermometer",
	["NIGHT_CLEAR"] = "Interface\\AddOns\\GnomTEC_Weather\\Textures\\moon",
	["NIGHT_PARTLY_DRY"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\moon_cloud",
	["NIGHT_PARTLY_FOG"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\moon_and_fog",
	["NIGHT_PARTLY_RAIN"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\moon_rain_and_cloud",
	["NIGHT_PARTLY_SNOW"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\moon_snow_and_cloud",
	["NIGHT_CLOUDY_DRY"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud",
	["NIGHT_CLOUDY_FOG"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud_fog",
	["NIGHT_CLOUDY_RAIN"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud_rain",
	["NIGHT_CLOUDY_SNOW"] 	= "Interface\\AddOns\\GnomTEC_Weather\\Textures\\cloud_snow",
}
	
-- ----------------------------------------------------------------------
-- Addon global variables (local)
-- ----------------------------------------------------------------------
local panelConfiguration = nil

-- Main options menue with general addon information
local optionsMain = {
	name = "GnomTEC Weather",
	type = "group",
	args = {
		descriptionTitle = {
			order = 1,
			type = "description",
			name = L["L_OPTIONS_TITLE"],
		},
		descriptionAbout = {
			name = "About",
			type = "group",
			guiInline = true,
			order = 4,
			args = {
				descriptionVersion = {
				order = 1,
				type = "description",			
				name = "|cffffd700".."Version"..": ".._G["GREEN_FONT_COLOR_CODE"]..GetAddOnMetadata("GnomTEC_Weather", "Version"),
				},
				descriptionAuthor = {
					order = 2,
					type = "description",
					name = "|cffffd700".."Autor"..": ".."|cffff8c00".."GnomTEC",
				},
				descriptionEmail = {
					order = 3,
					type = "description",
					name = "|cffffd700".."Email"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."info@gnomtec.de",
				},
				descriptionWebsite = {
					order = 4,
					type = "description",
					name = "|cffffd700".."Website"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."http://www.gnomtec.de/",
				},
				descriptionLicense = {
					order = 5,
					type = "description",
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."(c)2014 by GnomTEC",
				},
			}
		},
		descriptionLogo = {
			order = 5,
			type = "description",
			name = "",
			image = "Interface\\AddOns\\GnomTEC_Weather\\Textures\\GnomTEC-Logo",
			imageCoords = {0.0,1.0,0.0,1.0},
			imageWidth = 512,
			imageHeight = 128,
		},
	}
}

local optionsWeather = {
	name = L["L_OPTIONS_WEATHER"],
	type = 'group',
	args = {
		optionsWeatherMorning = {
			name = L["L_MORNING"].." (06:46 - 11:42)",
			type = 'group',
			inline = true,
			order = 1,
			args = {
				WeatherOptionMorningPictogramTexture = {
					type = "description",
					name = "",
					image = function(info) return weatherTexturesDay[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MORNING"]["PICTOGRAM"]] end,
					imageCoords = {0.0,1.0,0.0,1.0},
					imageWidth = 32,
					imageHeight = 32,
					width = "half",
					order = 1,
				},
				WeatherOptionMorningPictogram = {
					type = "select",
					style = "dropdown",
					name = L["L_OPTIONS_WEATHER_PICTOGRAM"],
					values =  weatherTexturesDayList,
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MORNING"]["PICTOGRAM"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MORNING"]["PICTOGRAM"] end,
					order = 1
				},
				WeatherOptionMorningWeather = {
					type = "input",
					name = L["L_OPTIONS_WEATHER_DESCRIPTION"],
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MORNING"]["DESCRIPTION"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MORNING"]["DESCRIPTION"] end,
					multiline = 5,
					width = 'full',
					order = 2
				},
			},
		},
		optionsWeatherMidday = {
			name = L["L_MIDDAY"].." (11:43 - 16:12)",
			type = 'group',
			inline = true,
			order = 2,
			args = {
				WeatherOptionMiddayPictogramTexture = {
					type = "description",
					name = "",
					image = function(info) return weatherTexturesDay[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MIDDAY"]["PICTOGRAM"]] end,
					imageCoords = {0.0,1.0,0.0,1.0},
					imageWidth = 32,
					imageHeight = 32,
					width = "half",
					order = 1,
				},
				WeatherOptionMiddayPictogram = {
					type = "select",
					style = "dropdown",
					name = L["L_OPTIONS_WEATHER_PICTOGRAM"],
					values =  weatherTexturesDayList,
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MIDDAY"]["PICTOGRAM"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MIDDAY"]["PICTOGRAM"] end,
					order = 1
				},
				WeatherOptionMiddayWeather = {
					type = "input",
					name = L["L_OPTIONS_WEATHER_DESCRIPTION"],
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MIDDAY"]["DESCRIPTION"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["MIDDAY"]["DESCRIPTION"] end,
					multiline = 5,
					width = 'full',
					order = 2
				},
			},
		},
		optionsWeatherEvening= {
			name = L["L_EVENING"].." (16:13 - 20:18)",
			type = 'group',
			inline = true,
			order = 3,
			args = {
				WeatherOptionEveningPictogramTexture = {
					type = "description",
					name = "",
					image = function(info) return weatherTexturesDay[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["EVENING"]["PICTOGRAM"]] end,
					imageCoords = {0.0,1.0,0.0,1.0},
					imageWidth = 32,
					imageHeight = 32,
					width = "half",
					order = 1,
				},
				WeatherOptionEveningPictogram = {
					type = "select",
					style = "dropdown",
					name = L["L_OPTIONS_WEATHER_PICTOGRAM"],
					values =  weatherTexturesDayList,
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["EVENING"]["PICTOGRAM"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["EVENING"]["PICTOGRAM"] end,
					order = 1
				},
				WeatherOptionEveningWeather = {
					type = "input",
					name = L["L_OPTIONS_WEATHER_DESCRIPTION"],
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["EVENING"]["DESCRIPTION"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["EVENING"]["DESCRIPTION"] end,
					multiline = 2,
					width = 'full',
					order = 6
				},
			},
		},
		optionsWeatherNight = {
			name = L["L_NIGHT"].." (20:19 - 06:45)",
			type = 'group',
			inline = true,
			order = 4,
			args = {
				WeatherOptionNightPictogramTexture = {
					type = "description",
					name = "",
					image = function(info) return weatherTexturesNight[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["NIGHT"]["PICTOGRAM"]] end,
					imageCoords = {0.0,1.0,0.0,1.0},
					imageWidth = 32,
					imageHeight = 32,
					width = "half",
					order = 1,
				},
				WeatherOptionNightPictogram = {
					type = "select",
					style = "dropdown",
					name = L["L_OPTIONS_WEATHER_PICTOGRAM"],
					values =  weatherTexturesNightList,
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["NIGHT"]["PICTOGRAM"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["NIGHT"]["PICTOGRAM"] end,
					order = 1
				},
				WeatherOptionNightWeather = {
					type = "input",
					name = L["L_OPTIONS_WEATHER_DESCRIPTION"],
					desc = "",
					set = function(info,val) GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["NIGHT"]["DESCRIPTION"] = val end,
					get = function(info) return GnomTEC_Weather.db.realm["Weather"]["STORMWIND"]["20140125"]["NIGHT"]["DESCRIPTION"] end,
					multiline = 5,
					width = 'full',
					order = 2
				},
			},
		},
	},
}

	
-- ----------------------------------------------------------------------
-- Startup initialization
-- ----------------------------------------------------------------------

GnomTEC_Weather = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_Weather", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")



-- ----------------------------------------------------------------------
-- Local functions
-- ----------------------------------------------------------------------

-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------
local lastTimerEvent = 0

function GnomTEC_Weather:TimerEvent()
	local t = GetTime()

	-- Check weather every 5 seconds
	if ((t-lastTimerEvent) > 5) then
		lastTimerEvent = t
		
		local texture
		local title
		local text
		
		local hour,minute = GetGameTime();
		local actualTime = hour*100 + minute
		local	weekday, month, day, year = CalendarGetDate();

		local actualDate = string.format("%04u%02u%02u",year,month,day)
		local previousDate
		if (day > 1) then
			previousDate = string.format("%04u%02u%02u",year,month,day-1)
		elseif (month > 1) then
			previousDate = string.format("%04u%02u%02u",year,month-1,select(3,CalendarGetAbsMonth(month-1, year)))
		else
			previousDate = string.format("%04u%02u%02u",year-1,12,31)
		end
		
		--- Beta version data only for one same day (date not shown yet)
		actualDate = "20140125"
		previousDate =	"20140125"
			
		if GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate] then
			if (actualTime >= GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["NIGHT"]["TIME"]) then
				texture = weatherTexturesNight[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["NIGHT"]["PICTOGRAM"]]
				title = L["L_NIGHT"].." (20:19 - 06:45):"
				text = GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["NIGHT"]["DESCRIPTION"]
			elseif (actualTime >= GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["EVENING"]["TIME"]) then
				texture = weatherTexturesDay[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["EVENING"]["PICTOGRAM"]]
				title = L["L_EVENING"].." (16:13 - 20:18):"
				text = GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["EVENING"]["DESCRIPTION"]
			elseif (actualTime >= GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["MIDDAY"]["TIME"]) then
				texture = weatherTexturesDay[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["MIDDAY"]["PICTOGRAM"]]
				title = L["L_MIDDAY"].." (11:43 - 16:12):"
				text = GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["MIDDAY"]["DESCRIPTION"]
			elseif (actualTime >= GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["MORNING"]["TIME"]) then
				texture = weatherTexturesDay[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["MORNING"]["PICTOGRAM"]]
				title = L["L_MORNING"].." (06:46 - 11:42):"
				text = GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][actualDate]["MORNING"]["DESCRIPTION"]
			else
				if (GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][previousDate]) then
					texture = weatherTexturesNight[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][previousDate]["NIGHT"]["PICTOGRAM"]]
					title = L["L_NIGHT"].." (20:19 - 06:45):"
					text = GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][previousDate]["NIGHT"]["DESCRIPTION"]
				else
					texture = weatherTexturesDay["NONE"]
					title = L["L_NIGHT"].." (20:19 - 06:45):"
					text = "|cFFFF0000Keine Wetterdaten im Augenblick!|r|n"			
				end
			end
		elseif (GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][previousDate] and (actualTime < 0646)) then
				texture = weatherTexturesNight[GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][previousDate]["NIGHT"]["PICTOGRAM"]]
				title = L["L_NIGHT"].." (20:19 - 06:45):"
				text = GnomTEC_Weather.db.realm["Weather"]["STORMWIND"][previousDate]["NIGHT"]["DESCRIPTION"]		
		else
			texture = weatherTexturesDay["NONE"]
			title = ""
			text = "|cFFFF0000Keine Wetterdaten im Augenblick!|r|n"			
		end

		
		GNOMTEC_WEATHER_FRAME_TITLE:SetText(title)
		GNOMTEC_WEATHER_FRAME_SCROLL_DESCRIPTION:SetText(text)

		GNOMTEC_WEATHER_BUTTON_SHOWHIDE:SetNormalTexture(texture)
		GNOMTEC_WEATHER_BUTTON_SHOWHIDE:SetCheckedTexture(texture)
		GNOMTEC_WEATHER_BUTTON_SHOWHIDE:SetHighlightTexture(texture)
		
		GNOMTEC_WEATHER_FRAME_PICTOGRAM_TEXTURE:SetTexture(texture)
		
	end	
end

function GnomTEC_Weather:OpenConfiguration()
	InterfaceOptionsFrame_OpenToCategory(panelConfiguration)
	-- sometimes first call lands not on desired panel
	InterfaceOptionsFrame_OpenToCategory(panelConfiguration)
end

-- ----------------------------------------------------------------------
-- Hook functions
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Event handler
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Addon OnInitialize, OnEnable and OnDisable
-- ----------------------------------------------------------------------

function GnomTEC_Weather:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
  	self.db = LibStub("AceDB-3.0"):New("GnomTEC_WeatherDB", defaultsDb, true);

	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Weather Main", optionsMain)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Weather Weather", optionsWeather)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Weather Main", "GnomTEC Weather");
	panelConfiguration = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Weather Weather", L["L_OPTIONS_WEATHER"], "GnomTEC Weather");

  	GnomTEC_Weather:Print(L["L_WELCOME"])
end

function GnomTEC_Weather:OnEnable()
    -- Called when the addon is enabled

	GnomTEC_Weather:Print("GnomTEC_Weather Enabled")

	-- Initialize options which are propably not valid because they are new added in new versions of addon
end

function GnomTEC_Weather:OnDisable()
    -- Called when the addon is disabled
    
	GnomTEC_Weather:UnregisterAllEvents();

end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------

