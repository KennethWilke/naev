-- Generic equipping routines, helper functions and outfit definitions.
include("dat/factions/equip/generic.lua")

--[[
-- @brief Does zalek pilot equipping
--
--    @param p Pilot to equip
--]]
function equip( p )
   -- Get ship info
   local shiptype, shipsize = equip_getShipBroad( p:ship():class() )

   -- Split by type
   if shiptype == "military" then
      equip_empireMilitary( p, shipsize )
   else
      equip_generic( p )
   end
end


-- CANNONS
function equip_forwardZlkLow ()
   return { "Orion Lance", "Laser Cannon MK3" }
end
function equip_forwardZlkMed ()
   return { "Laser Cannon MK3", "Orion Lance", "Grave Lance", "Heavy Ripper Cannon" }
end
-- TURRETS
function equip_turretZlkLow ()
   return { "Laser Turret MK2" }
end
function equip_turretZlkMed ()
   return { "Pulse Beam", "Laser Turret MK3" }
end
function equip_turretZlkHig ()
   return { "Grave Beam", "Ragnarok Beam" }
end
-- RANGED
function equip_rangedZlk ()
   return { "Unicorp Mace Launcher" }
end
function equip_secondaryZlk ()
   return { "Shattershield Lance", "Unicorp Headhunter Launcher" }
end
-- NON-COMBAT
--[[
-- Utility slots
--]]
function equip_mediumZlkLow ()
   return { "Reactor Class I", "Unicorp Scrambler", "Small Shield Booster" }
end
function equip_mediumZlkMed ()
   return { "Reactor Class II", "Milspec Scrambler", "Medium Shield Booster" }
end
function equip_mediumZlkHig ()
   return { "Reactor Class III", "Milspec Scrambler", "Large Shield Booster" }
end

--[[
-- Structure slots
--]]
function equip_lowZlkLow ()
   return { "Battery", "Shield Capacitor", "Engine Reroute" }
end
function equip_lowZlkMed ()
   return { "Shield Capacitor II", "Shield Capacitor III", "Engine Reroute", "Battery II" }
end
function equip_lowZlkHig ()
   return { "Shield Capacitor III", "Shield Capacitor IV", "Battery III" }
end



--[[
-- @brief Equips a zalek military type ship.
--]]
function equip_empireMilitary( p, shipsize )
   local medium, low
   local use_primary, use_secondary, use_medium, use_low
   local use_forward, use_turrets, use_medturrets
   local nhigh, nmedium, nlow = p:ship():slots()
   local scramble

   -- Defaults
   medium      = { "Unicorp Scrambler" }
   weapons     = {}
   scramble    = false

   -- Equip by size and type
   if shipsize == "small" then
      local class = p:ship():class()

      -- Scout
      if class == "Scout" then
         equip_cores(p, "Tricon Naga Mk9 Engine", "Milspec Orion 3701 Core System", "Schafer & Kane Light Stealth Plating")
         use_primary    = rnd.rnd(1,#nhigh)
         addWeapons( equip_forwardLow(), use_primary )
         medium         = { "Generic Afterburner", "Milspec Scrambler" }
         use_medium     = 2
         low            = { "Solar Panel" }

      -- Fighter
      elseif class == "Fighter" then
         equip_cores(p, "Tricon Naga Mk9 Engine", "Milspec Orion 3701 Core System", "Schafer & Kane Light Stealth Plating")
         use_primary    = nhigh-1
         use_secondary  = 1
         addWeapons( equip_forwardZlkMed(), use_primary )
         addWeapons( equip_secondaryZlk(), use_secondary )
         medium         = equip_mediumZlkLow()
         low            = equip_lowZlkLow()


      -- Bomber
      elseif class == "Bomber" then
         equip_cores(p, "Tricon Naga Mk9 Engine", "Milspec Orion 3701 Core System", "Schafer & Kane Light Combat Plating")
         use_primary    = rnd.rnd(1,2)
         use_secondary  = nhigh - use_primary
         addWeapons( equip_forwardZlkLow(), use_primary )
         addWeapons( equip_rangedZlk(), use_secondary )
         medium         = equip_mediumZlkLow()
         low            = equip_lowZlkLow()

      end

   elseif shipsize == "medium" then
      local class = p:ship():class()
      
      -- Corvette
      if class == "Corvette" then
         equip_cores(p, "Tricon Centaur Mk7 Engine", "Milspec Orion 5501 Core System", "Schafer & Kane Medium Solar Plating")
         use_secondary  = rnd.rnd(1,2)
         use_primary    = nhigh - use_secondary
         addWeapons( equip_forwardZlkMed(), use_primary )
         addWeapons( equip_secondaryZlk(), use_secondary )
         medium         = equip_mediumZlkMed()
         low            = equip_lowZlkMed()

      end

      -- Destroyer
      if class == "Destroyer" then
         equip_cores(p, "Tricon Centaur Mk7 Engine", "Milspec Orion 5501 Core System", "Schafer & Kane Medium Combat Plating Gamma")
         use_secondary  = rnd.rnd(1,2)
         use_turrets    = nhigh - use_secondary - rnd.rnd(1,2)
         use_forward    = nhigh - use_secondary - use_turrets
         addWeapons( equip_secondaryZlk(), use_secondary )
         addWeapons( equip_turretZlkMed(), use_turrets )
         addWeapons( equip_forwardZlkMed(), use_forward )
         medium         = equip_mediumZlkMed()
         low            = equip_lowZlkMed()

      end

   else -- "large"
      -- TODO: Divide into carrier and cruiser classes.
      equip_cores(p, "Tricon Harpy Mk11 Engine", "Milspec Orion 9901 Core System", "Schafer & Kane Heavy Combat Plating Gamma")
      use_secondary  = 2
      if rnd.rnd() > 0.4 then -- Anti-fighter variant.
         use_turrets    = nhigh - use_secondary - rnd.rnd(2,3)
         use_medturrets = nhigh - use_secondary - use_turrets
         addWeapons( equip_turretZlkMed(), use_medturrets )
      else -- Anti-capital variant.
         use_turrets    = nhigh - use_secondary
      end
      addWeapons( equip_turretZlkHig(), use_turrets )
      addWeapons( equip_secondaryZlk(), use_secondary )
      medium         = equip_mediumZlkHig()
      low            = equip_lowZlkHig()

   end

   equip_ship( p, scramble, weapons, medium, low,
               use_medium, use_low )
end
