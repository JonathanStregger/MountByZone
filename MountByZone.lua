----------------------------------------------------------------------
-- 	Mount By Zone 0.0.01 (July 9, 2019)
----------------------------------------------------------------------

--local addonName, addon = ...
--local L = addon.L    
function GetContinent()
    local mapID = C_Map.GetBestMapForUnit("player")
    local thisMapCont = { id=5, cont=""}
    while thisMapCont.id > 2 and thisMapCont.id ~= 2 do
        local mapDetails = C_Map.GetMapInfo(mapID)
        thisMapCont.id = mapDetails.mapType
        thisMapCont.cont = mapDetails.name
        mapID = mapDetails.parentMapID
    end
    if thisMapCont.id == 2 then
        return thisMapCont.cont
    else
        return nil
    end
end

--Global Mounts
local Ground = {"Kor'kron War Wolf", "Beastlord's Warwolf", "Ironside Warwolf", "Lionthien Prowler",
    "Scrapforged Mechaspider", "X-995 Mechanocat", "Warlord's Deathwheel", "Raven Lord", "Great Northern Elderhorn",
    "Highmountain Thunderhoof", "Spirit of Eche'ro", "Kor'kron Annihilator", "Core Hound"}
local Flying = {"Huntmaster's Fierce Wolfhawk", "Huntmaster's Dire Wolfhawk", "Huntmaster's Loyal Wolfhawk",
    "Infinite Timereaver", "Spawn of Galakras", "Dread Raven", "Grand Armored Wyvern"}
local Swimming = {"Brinedeep Bottom-Feeder", "Crimson Tidestallion", "Sea Turtle"}
local GlobalMounts = {gnd = Ground,  fly = Flying, swim = Swimming}

--BFA
local GroundBFA = {"Gilded Ravasaur", "Slate Primordial Direhorn", "Zandalari Direhorn", "Crimson Primal Direhorn"}
local FlyBFA = {"Voldunai Dunescraper", "Cobalt Pterrordax"}

--Zandalar
local FlyNazmir = {"Expedition Bloodswarmer"}
local Nazmir = {name = "Nazmir", gnd = nil, fly = FlyNazmir, swim = nil}
local GroundVoldun = {"Alabaster Hyena"}
local Voldun = {name = "Vol'dun", gnd = GroundVoldun, fly = nil, swim = nil}
local Zandalar = {name = "Zandalar", gnd = GroundBFA, fly = FlyBFA, swim = nil, zones = {Nazmir, Voldun}}

--Kul Tiras
local MechaFly = {"Wonderwing 2.0", "Turbo-Charged Flying Machine", "Depleted-Kyparium Rocket"}
local MechaGnd = {"Scrapforged Mechaspider", "Mechanized Lumber Extractor", "Sky Golem", "Mechano-Hog"}
local Mechagon = {name = "Mechagon", gnd = MechaGnd, fly = MechaFly, swim = nil}
local KulTiras = {name = "Kul Tiras", gnd = GroundBFA, fly = FlyBFA, swim = nil, zones = {Mechagon}}

--Legion
local BrokenGnd = {"Lionthien Prowler", "Great Northern Elderhorn","Highmountain Thunderhoof", "Spirit of Eche'ro",
    "Nightbourne Manasaber"}
local BrokenFly = {"Huntmaster's Fierce Wolfhawk", "Huntmaster's Dire Wolfhawk", "Huntmaster's Loyal Wolfhawk", 
    "Leywoven Flying Carpet", "Vibrant Mana Ray", "Scintillating Mana Ray", "Felglow Mana Ray"}
local GroundArgus = {"Amethyst Ruinstrider", "Beryl Ruinstrider", "Bleakhoof Ruinstrider", "Cerulean Ruinstrider", 
    "Russet Ruinstrider", "Sable Ruinstrider", "Umber Ruinstrider"}
local Argus = {name = "Argus", gnd = GroundArgus, fly = nil, swim = nil}
local BrokenIsles = {name = "Broken Isles", gnd = nil, fly = nil, swim = nil, zones = {Argus}}

--Draenor
local Draenor = {name = "Draenor", gnd = nil, fly = nil, swim = nil, zones = nil}

--Northrend
local Northrend = {name = "Northrend", gnd = nil, fly = nil, swim = nil, zones = nil}

--Kalimdor
local Kalimdor = {name = "Kalimdor", gnd = nil, fly = nil, swim = nil, zones = nil}

--Eastern Kingdoms
local EasternKingdoms = {name = "Eastern Kingdoms", gnd = nil, fly = nil, swim = nil, zones = nil}

--Pandaria
local GroundPanda = {"Blonde Riding Yak", "Grey Riding Yak", "Great Black Dragon Turtle", "Great Blue Dragon Turtle", 
"Great Brown Dragon Turtle", "Great Green Dragon Turtle", "Great Purple Dragon Turtle", "Great Red Dragon Turtle", 
"Golden Riding Crane", "Azure Riding Crane", "Regal Riding Crane"}
local FlyPanda = {"Crimson Cloud Serpent", "Heavenly Azure Cloud Serpent", "Heavenly Golden Cloud Serpent",
"Thundering Jade Cloud Serpent", "Thundering Onyx Cloud Serpent", "Thundering August Cloud Serpent",
"Yu'lei, Daughter of Jade", "Pandaren Kite"}
local Pandaria = {name = "Pandaria", gnd = GroundPanda, fly = FlyPanda, swim = nil,  zones = nil}

--Anh'Qiraj
local AhnQiraj = {"Blue Qiraji Battle Tank", "Green Qiraji Battle Tank", "Red Qiraji Battle Tank", "Yellow Qiraji Battle Tank"}

--Nazjatar
local Nazjatar = {"Brinedeep Bottom-Feeder"}

--Continents
local Continents = {Zandalar, KulTiras, BrokenIsles, Pandaria, Draenor, Northrend, Kalimdor, EasternKingdoms}

local prevWeapons

function GetMount()
    local CurrentZone = GetZoneText()
    local CurrentCont = GetContinent()
    --Check for instances first
    if C_Map.GetMapInfo(C_Map.GetBestMapForUnit("PLAYER")).mapType > 3 then
        mount = GlobalMounts.gnd[math.random(table.getn(GlobalMounts.gnd))]
    else
        if CurrentZone == "Nazjatar" or (IsSwimming() and not IsModifierKeyDown()) then
            return Nazjatar[math.random(table.getn(Nazjatar))]
        elseif CurrentZone == "Ahn'Qiraj" then
            return AhnQiraj[math.random(table.getn(AhnQiraj))]
        else
            if IsSwimming() and not IsModifierKeyDown() then
                if GetItemCount("Underlight Angler") == 1 then
                    EquipItemByName("Underlight Angler")
                else
                    mount = GlobalMounts.swim[math.random(table.getn(GlobalMounts.swim))]
                end
            elseif IsFlyableArea() and not IsModifierKeyDown() or IsFlyableArea() and IsSwimming() then
                mount = GlobalMounts.fly[math.random(table.getn(GlobalMounts.fly))]
            else
                mount = GlobalMounts.gnd[math.random(table.getn(GlobalMounts.gnd))]
            end
            if CurrentCont then
                for i, continent in ipairs(Continents) do
                    if CurrentCont == continent.name then
                        if IsSwimming() and not IsModifierKeyDown() then
                            if continent.swim then mount = continent.swim[math.random(table.getn(continent.swim))] end
                        elseif IsFlyableArea() and not IsModifierKeyDown() or IsFlyableArea() and IsSwimming() then
                            if continent.fly then mount = continent.fly[math.random(table.getn(continent.fly))] end
                        elseif continent.gnd then
                            mount = continent.gnd[math.random(table.getn(continent.gnd))]
                        end
                        if continent.zones then
                            for j, zone in ipairs(continent.zones) do
                                if zone.name == CurrentZone then
                                    if IsSwimming() and not IsModifierKeyDown() then
                                        if zone.swim then mount = zone.swim[math.random(table.getn(zone.swim))] end
                                    elseif IsFlyableArea() and not IsModifierKeyDown() or IsFlyableArea() and IsSwimming() then
                                        if zone.fly then mount = zone.fly[math.random(table.getn(zone.fly))] end
                                    elseif zone.gnd then
                                        mount = zone.gnd[math.random(table.getn(zone.gnd))]
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return mount
end

SLASH_MOUNTBYZONE1 = "/mbz";
SlashCmdList["MOUNTBYZONE"] = function(msg)
    if msg == "info" then
        local map = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("PLAYER"))
        while map.mapID ~= 0 do
            print(map.mapID .. " " .. map.name .. " " .. map.mapType .. " " .. map.parentMapID)
            map = C_Map.GetMapInfo(map.parentMapID)
        end
    elseif not IsFlying() or (IsFlying() and IsModifierKeyDown()) then
        local mount = GetMount()
        if mount then
            CastSpellByName(mount)
        elseif IsFlyableArea() then
            CastSpellByName("Grand Armored Wyvern")
        else
            CastSpellByName("Ironside Warwolf")
        end
    end
end
