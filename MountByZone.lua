--[[-------------------------------------------------------------------------
-- 	Mount By Zone 0.0.02 (September 20, 2020)
--
--  Copyright (c) 2019-2020, Jonathan Stregger
--  All rights reserved.
-------------------------------------------------------------------------]]--

--[[-------------------------------------------------------------------------
-- Set defualts
-------------------------------------------------------------------------]]--

--Global Mounts
local Ground = {"Kor'kron War Wolf", "Beastlord's Warwolf", "Ironside Warwolf", "Lionthien Prowler", "Scrapforged Mechaspider", "X-995 Mechanocat", "Warlord's Deathwheel", "Raven Lord", "Great Northern Elderhorn", "Highmountain Thunderhoof", "Spirit of Eche'ro", "Kor'kron Annihilator", "Core Hound"}
local Flying = {"Spawn of Galakras", "Dread Raven", "Grand Armored Wyvern", "Obsidian Worldbreaker"}
local Swimming = {"Brinedeep Bottom-Feeder", "Crimson Tidestallion", "Sea Turtle", "Darkwater Skate"}
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
local BrokenFly = {"Leywoven Flying Carpet", "Vibrant Mana Ray", "Scintillating Mana Ray", "Felglow Mana Ray"}
local GroundArgus = {"Amethyst Ruinstrider", "Beryl Ruinstrider", "Bleakhoof Ruinstrider", "Cerulean Ruinstrider", "Russet Ruinstrider", "Sable Ruinstrider", "Umber Ruinstrider"}
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
local GroundPanda = {"Blonde Riding Yak", "Grey Riding Yak", "Great Black Dragon Turtle", "Great Blue Dragon Turtle", "Great Brown Dragon Turtle", "Great Green Dragon Turtle", "Great Purple Dragon Turtle", "Great Red Dragon Turtle", "Golden Riding Crane", "Azure Riding Crane", "Regal Riding Crane"}
local FlyPanda = {"Crimson Cloud Serpent", "Heavenly Azure Cloud Serpent", "Heavenly Golden Cloud Serpent", "Thundering Jade Cloud Serpent", "Thundering Onyx Cloud Serpent", "Thundering August Cloud Serpent", "Yu'lei, Daughter of Jade", "Pandaren Kite"}
local Pandaria = {name = "Pandaria", gnd = GroundPanda, fly = FlyPanda, swim = nil,  zones = nil}

--Anh'Qiraj
local AhnQiraj = {"Blue Qiraji Battle Tank", "Green Qiraji Battle Tank", "Red Qiraji Battle Tank", "Yellow Qiraji Battle Tank"}

--Nazjatar
local Nazjatar = {"Brinedeep Bottom-Feeder"}

--Continents
local Continents = {Zandalar, KulTiras, BrokenIsles, Pandaria, Draenor, Northrend, Kalimdor, EasternKingdoms}

--Zones with mapType > 3 that are actually flyable
local liarZones = {"Dazar'alor", "Dalaran"}

--[[-------------------------------------------------------------------------
--  Get the current continent
-------------------------------------------------------------------------]]--
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

--Detects a zone where the mapType > 3, but is flyable
function IsLiarZone(zone)
    for index, value in ipairs(liarZones) do
        if value == zone then
            return true
        end
    end
    return false
end


--Add class mounts
local class_name = UnitClass("player")
if class_name == "Druid" then
elseif class_name == "Hunter" then
    local hunter_mounts = {"Huntmaster's Fierce Wolfhawk", "Huntmaster's Dire Wolfhawk", "Huntmaster's Loyal Wolfhawk"}
    for i, continent in ipairs(Continents) do
        if continent.fly then
            for j, mount in ipairs(hunter_mounts) do
                table.insert(Continents[i].fly, mount)
            end
        end
    end
elseif class_name == "Mage" then
    for i, continent in ipairs(Continents) do
        if continent.fly then table.insert(Continents[i].fly, "Archmage's Prismatic Disc") end
    end
elseif class_name == "Death Knight" then
    for i, continent in ipairs(Continents) do
        Continents[i].gnd = {"Acherus deathcharger"}
        Continents[i].fly = {"Bloodbathed Frostbrood Vanquisher"}
    end
elseif class_name == "Rogue" then
    for i, continent in ipairs(Continents) do
        if continent.fly then table.insert(Continents[i].fly, "Shadowblade's Murderous Omen") end
    end
elseif class_name == "Warlock" then
    for i, continent in ipairs(Continents) do
        Continents[i].gnd = {"Netherlord's Chaotic Wrathsteed"}
        Continents[i].fly = {"Netherlord's Chaotic Wrathsteed"}
    end
elseif class_name == "Demon Hunter" then
    for i, continent in ipairs(Continents) do
        Continents[i].gnd = {"Felsaber"}
        Continents[i].fly = {"Slayer's Felbroken Shrieker"}
    end
elseif class_name == "Monk" then
    for i, continent in ipairs(Continents) do
        if continent.gnd then table.insert(Continents[i].gnd, "Ban-Lu, Grandmaster's Companion") end
        if continent.fly then table.insert(Continents[i].fly, "Ban-Lu, Grandmaster's Companion") end
    end
elseif class_name == "Warrior" then
    for i, continent in ipairs(Continents) do
        if continent.fly then table.insert(Continents[i].fly, "Battlelord's Bloodthirsty War Wyrm") end
    end
elseif class_name == "Shaman" then
    for i, continent in ipairs(Continents) do
        if continent.fly then table.insert(Continents[i].fly, "Farseer's Raging Tempest") end
    end
elseif class_name == "Paladin" then
    for i, continent in ipairs(Continents) do
        Continents[i].gnd = {"Highlord's Golden Charger"}
        Continents[i].fly = {"Highlord's Golden Charger"}
    end
elseif class_name == "Priest" then
    for i, continent in ipairs(Continents) do
        Continents[i].fly = {"High Priest's Lightsworm Seeker"}
    end
end


--Gets the name of an appropriate mount
function GetMount()
    local CurrentZone = GetZoneText()
    local CurrentCont = GetContinent()
    local MType = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("PLAYER")).mapType
    
    if MType > 3 and not IsLiarZone(CurrentZone) then
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

SLASH_MOUNTBYZONE1 = '/mbz'
function SlashCmdList.MOUNTBYZONE(msg, editBox)
    if class_name == "Druid" then
        CastSpellByName("Travel Form")
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

SLASH_QUEST1 = '/q'
function SlashCmdList.QUEST(msg, editBox)
    if type(msg) ~= "nil" then
        if IsQuestFlaggedCompleted(msg) then
            print("Quest " .. msg .. " has been completed")
        else
            print("Quest " .. msg .. " has NOT been completed")
        end
    end
end

SLASH_ZONE1 = '/zone'
function SlashCmdList.ZONE(msg, editBox)
    local map = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("PLAYER"))
    while map ~= nil and map.mapID ~= 0 do
        print('ID:' .. map.mapID .. " Name: " .. map.name .. " Type: " .. map.mapType .. " Parent ID:" .. map.parentMapID)
        map = C_Map.GetMapInfo(map.parentMapID)
    end
end