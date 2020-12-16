/obj/item/device/last_shelter
	name = "Domus Finale"
	desc = "A curious Hospitaller device capable of retrieving cruciforms of those lost to the ages."
	icon = 'icons/obj/device.dmi'
	icon_state = "last_shelter"
	item_state = "last_shelter"
	price_tag = 20000
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 9, TECH_BIO = 3)
	var/cooldown = 15 MINUTES
	var/last_teleport = -15 MINUTES
	var/scan = FALSE

/obj/item/device/last_shelter/attack_self(mob/user)
	if(world.time >= (last_teleport + cooldown))
		to_chat(user, SPAN_NOTICE("The [src] scans deep space for core implants, it will take a while..."))
		last_teleport = world.time
		scan = TRUE
		var/obj/item/weapon/implant/core_implant/soulcrypt/soulcrypt = get_cruciform()
		if(soulcrypt)
			scan = FALSE
			if(istype(src.loc, /mob/living/carbon/human))
				user.put_in_hands(soulcrypt)
				to_chat(user, SPAN_NOTICE("The [src] has found a stranded core implant! The fate of this Child is now in your hands."))
			else
				visible_message(SPAN_NOTICE("[src] drops [soulcrypt]."))
				soulcrypt.forceMove(get_turf(src))
		else
			to_chat(user, SPAN_WARNING("The [src] couldn't find anything."))
			scan = FALSE

	else if(scan)
		to_chat(user, SPAN_WARNING("The [src] is still woking! Wait a minute!"))

	else
		to_chat(user, SPAN_WARNING("The [src] needs time to recharge!"))


/obj/item/device/last_shelter/proc/get_cruciform()
	var/datum/mind/MN = request_player()
	if(!MN)
		return FALSE
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)
	for(var/stat in ALL_STATS)
		H.stats.changeStat(stat, rand(STAT_LEVEL_ADEPT, STAT_LEVEL_PROF))
	var/datum/perk/perk_random = pick(subtypesof(/datum/perk/oddity))
	H.stats.addPerk(perk_random)
	H.stats.addPerk(perk_random)
	H.stats.addPerk(perk_random)
	var/obj/item/weapon/implant/core_implant/cruciform/cruciform = new /obj/item/weapon/implant/core_implant/cruciform(src)
	cruciform.add_module(new CRUCIFORM_CLONING)
	cruciform.activated = TRUE
	MN.name = H.real_name
	MN.assigned_role = "Revenant"
	MN.original = H
	for(var/datum/core_module/cruciform/cloning/M in cruciform.modules)
		M.write_wearer(H)
		M.ckey = MN.key
		M.mind = MN
	qdel(H)
	return cruciform

/obj/item/device/last_shelter/proc/request_player()
	var/agree_time_out = FALSE
	var/request_timeout = 60 SECONDS
	var/datum/mind/MN

	for(var/mob/observer/ghost/O in GLOB.player_list)
		if(O.client)
			O << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever when he's chosen to decide.
			if(alert(O, "Do you want to be reborn as a Revenant? Hurry up, you have 60 seconds to make choice!","Player Request","OH YES","I am not worthy") == "OH YES")
				if(!agree_time_out)
					if(MN)
						to_chat(O, SPAN_WARNING("Somebody already took this place."))
						return

					O.mind = new /datum/mind(O.ckey)
					MN = O.mind
				else
					to_chat(O, SPAN_WARNING("You are too slow. Try to be faster next time."))
					return

	sleep(request_timeout)
	agree_time_out = TRUE
	return MN
