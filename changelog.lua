unusedkey = "0", "T", "N", "J", "H", "K", "L", "O", "R", "X"

*v1 (August ??, 2022)
"Energy regen on sleep or idle"
"Bloom regen"
"Added new task, changing skin everytime season changed and when character get high moistures level or wet"

*v2 (August ??, 2022)
"Spawn Soul Orb on Kill"
"Added a new skill extinguish wildfire"
"Lit a firecamp from a distance"

*v3 (August ??, 2022)
"Clicable widget treasure and bloom"
"Clicable widget magic and quantum"
"[BUG FIXED] When shield is on then use teleport or slide, invicible health stop working"
"[BUG FIXED] Level up does not update the shield"

*v4 (September ??, 2022)
"Quantum dodelta when character get attackd"
"Extinguish cost energy"
"Limit spawning the dawn light fx max 3 within 10 radius"
"[BUG FIXED] Health absorption does not work after relogin even shield has '9/10' charges (only when not maxed '10/10' charges)"
"Bloom regen cant regen when attacking"

*v5 (September ??, 2022)
"Added new badge explevel"
"Moving all the components (treasure, bloom, explevel, ect) into one component"
"Added more FX, just to reduce the fx usage from the game"

*v6 (September ??, 2022)
"Added a new widget button, beta testing quantum skill"
"Exp level widget removed, too many widget, use key button to check level info"
"Added random talk for start day, dusk, night"
"[BUG FIXED] dodge slide and leap not allowed when shield is active"
"Added option setting to enable or disable dodge slide skill"
"Energy badge and shield renewed"

*v7 (September ??, 2022)
"Components switcher deleted moved to puppeter"
"Added a new component, chronometer originally taken from the game component timer"
"Hide custom widgets on death, disable keyhandler on death"

*v8 (September ??, 2022)
"Added a new keyhandler to bedroll, resting state. Only to regenerate energy."
"Resting state now can auto wakeup and can't rest when danger nearby within 10 radius"
"Extinguish cost hunger instead of energy"
"Added a new widget button to activate sneak attack or backstab"

*v9 (September 17, 2022)
"Resting button removed, changed to widget button. Added cd to 4 seconds to wait anim done"
"Beta testing quantum skill button changed to transform button"
"Removed random talk when get attacked"
"Added playerprox and colourtweener components on treasure_trunk and spawning treasure_trunk no longer provide shovel"
"[FIXED] treasure_trunk icon"

*v10 (September 18, 2022)
"Added new fx called damageboost to deal extra damage"
"Character no longer deal critical damage"
"[FIXED] Not allowed to take a rest when character using sneak attack"
"Character can deal extra damage every 5 hit, damage based on current hunger/2"
"Added new component explevel"

*v11 (September 19, 2022)
"Added damage in backstab skill based on level. Damage deal based on max health plus current health"
"Added timer in backstab, not allowed to stay in shadow for long time"

*v12 (September 21, 2022)
"Added base damage on backstab skill, freeze and ignite"
"For backstab skill, character can deal extra damage in secondform"
"Backstab skill cost sanity, recover bit sanity if skill cancelled and can't recover energy"
"Added sanity recover when hitting target with backstab skill"

*v13 (September 23, 2022)
"Adjustment in sanity custom_rate_fn"
"Remove deprecated code"
"Add sanity and health regen when rest"
"Shield no longer regen when sleeping using bedroll, tent or siestahut. Use custon sleep (rest) to regen"

*v14 (September 24, 2022)
"Removed damageboost fx"
"No longer spawning fx, changed to hitcount with badge as meter"
"Hit count no longer reset to 0 unless changing hit type and relogin"

*v15 (September 25, 2022)
"Added damage on hit other based on hit type"
"2 types hit type still waiting to be added. Total 7 types. Normal, Fire Ice, Heal, Shadow"

*v16 (September 26, 2022)
"When character uses sneak attack skill, add wickerbottom tag insomniac (Character not allowed to sleep with skill on)"
"[BUG FIX] when terror break appear while character rest wake anim not finished, health and sanity regen tasks are still running"
"Damage boost damage reduced by hunger current / 3 (not with 2 anymore)"
"Switching spell or hit type cost energy"
"[BUG FIX] when character rest, temperature just stay still"
"Remove sg hit when controlling target, It is just too unfair. Added slow locomotor instead"
"Reduce cost controlling target from 3 to 2 hunger per second"
"Hiding in shadow/sneak attack/backstab reduced from 30 to 20 seconds"
"Added cooldown when pressing key skill, avoid spam when key is hold press"
"[BUG FOUND] Hit count meter sometimes hidden"

*v17 (September, 27 2022)
"[BUG FIX] Probably, hit count meter will be hidden for unknown cause"
"Cooldown pressing key skill reduced from 2 to 0.5 second"

*v18 (October, 6 2022)
"Finitiuse component on scythe item removed"
"Sanity cost for Dawn Light reduced from 40 to 20"
"Second form walk speed and run speed are increased to 1.5"
"Added new entities prefab shadows, created a file shadow brain"

*v19 (October, 7 2022)
"Added new sg shadow"
"Completing code for shadows"
"Extending shadow brain"

*v20 (November, 7 2022)
"Fix error caused by spell power"
"Dark Sield CD reduced by 0.2 instead of 0.5"
"Ingredient to make scythe reduced"
"Added finiteuses to scythe 2x from reqular spear usage"

*v21 (November, 8 2022)
"Increase puppeter power ignite a firepit by 180 instead of 120 and increase sanity cost by 5"

*v22 (November, 9 2022)
"[BUG FOUND] Bug found caused by shadow entities when player dead error triggered, so player have to kill the shadow ent (shadow follower)"
"Uncurseable character (Wonkey Curse). To avoid explevel reset from painful exp grinding, I added this"

*v23 (November, 10 2022)
"[BUG FIXED] Fix sanity and health regen on auto wake while resting"
"Adjustment shadow retarget function"
"Shadow damage increased from 20 to 50"
"Shadow will teleport when get hit by others(not by leader)"

*v24(November, 12 2022)
"valkyrie, spiderwhisperer tags removed on werebeast mode"
"werebeast component removed"
"sanity aura removed"
"Starting inventory modified, no longer with spear"
"Removed builder bonus in 2nd transform"
"Simplify the codes in character prefab file"
"Removed random talk when phase changed"

*v25(November, 13 2022)
"Decrease puppeter power ignite a firepit to 120 instead of 180"
"Added a special teleportation, a remmant teleportation. (not ready in use)"

*v26 (November, 14 2022)
"Added special movement to shadow duelist, special attack (Adopted from waxwell shadow in beta version)"
"Adjustment code in shadow ents lua, useless codes are deleted"
"Added a new file player lunge attack"

*v27 (November, 15 2022)
"Too many badges displayed. Treasure and Bloom Badge are removed"
"Adjustment badge position"

*v27 (November, 16 2022)
"Adjustment for widget position"
"Shadow on attacked animation still buggy, currently using the old method"
"Hit boost / hit count badge get removed"
"Shadow damage increased from 50 to 40"

*v28 (November, 17 2022)
"Adding some new widget buttons"
"Widget reworked underway"
"Widget button is not clickable and not able to send different command for each button clicked (I have no idea to do that)"

*v29 (November, 18 2022)
"After painful positioning the widget buttons, I manage it to solve that by learning how gesture wheel mod works. Thank you so much to the author who made gesture wheel mod"
"Widget button now can send different command (I managed it by changing the widget class to button class)"
"resting/sleeping - danger detector radius increased from 10 to 20"
"[BUG FOUND] while resting/sleeping taking damage from antlion groundpound won't restore the inventory, recipebar, health, sanity, etc gui"

*v30 (November, 19 2022)
"Setting up widget commands for shadow (spawning shadow guardian / worker)"
"Max pet reduced"
"Adjustment for unused codes"
"Nerf shadow guardian, max health reduced from 500 to 200 but increase health absorption amount to .7"
"Added new animation for spawning pet shadow and despawn animation shadow"
"Shadow no longer stay alive, I added lifetime timer to them"

----------------------------
"List of other lua that has orchidacite component in it"
1. "stategraph.lua"
2. "spellpower.lua"
3. "dendrobium.lua"

----------------------------
Inventory Images (Atlas):
1 = Size: 64*64
2 = Mipmaps: 7
3 = Format: DXT5
4 = Texture: 1D
5 = Count: 0
----------------------------

-- Reveal Map - Self
minimap = TheSim:FindFirstEntityWithTag("mini­map")
TheWorld.minimap.MiniMap:ShowArea (0,0,0,10000) 
for x=-1600,1600,35 do 
	for y=-1600,1600,35 do 
		ThePlayer.player_classified.MapExplorer:RevealArea(x,0,y)
	end 
end

-- Damage tester
c_spawn("spider").components.health:SetMaxHealth(50000)
c_select().components.combat:SetDefaultDamage(1)
c_select().components.combat:SetAttackPeriod(2)
c_select().Transform:SetScale(.5, .5, .5)
c_select().components.locomotor.walkspeed = 0
c_select().components.locomotor.runspeed = 0

-- Set season lengths
TheWorld:PushEvent("ms_setseasonlength", {season="summer", length=15})

-- Start Summer
TheWorld:PushEvent("ms_setseason", "autumn") -- winter, summer, spring