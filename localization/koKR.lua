if GetLocale() ~= "koKR" then return end
local FFC = select(2, ...)
local L = {}



FFC.L = setmetatable(L, {__index = FFC.L})
