-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_Weather", "enUS", true)
if not L then return end

L["L_WELCOME"] = "Welcome to GnomTEC_Weather"

L["L_OPTIONS_TITLE"] = "Addon to display actual weather for roleplaying.\n\n"

L["L_OPTIONS_WEATHER"] = "Weather configuration"
L["L_OPTIONS_WEATHER_PICTOGRAM"] ="Weather pictogram"
L["L_OPTIONS_WEATHER_DESCRIPTION"] = "Weather description"

L["L_MORNING"] = "Morning"
L["L_MIDDAY"] = "Midday"
L["L_EVENING"] = "Evening"
L["L_NIGHT"] = "Night"