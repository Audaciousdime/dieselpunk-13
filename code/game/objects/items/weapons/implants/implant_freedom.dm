//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

#define INSTALL_HANDS 0
#define INSTALL_FOOTS 1

/obj/item/weapon/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	implant_color = "r"
	var/activation_emote = "chuckle"
	var/uses = 1.0
	var/install_organ = INSTALL_HANDS
	legal = FALSE
	origin_tech = list(TECH_COMBAT=5, TECH_MAGNET=3, TECH_BIO=4, TECH_ILLEGAL=2)
	allowed_organs = list(BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT)

/obj/item/weapon/implant/freedom/New()
	src.activation_emote = pick("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	src.uses = rand(1, 5)
	..()
	return

/obj/item/weapon/implant/freedom/trigger(emote, mob/living/carbon/source as mob)
	if (src.uses < 1)	return 0
	if (emote == src.activation_emote)
		src.uses--
		source << "You feel a faint click."
		if (source.handcuffed && install_organ == INSTALL_HANDS)
			var/obj/item/weapon/W = source.handcuffed
			source.handcuffed = null
			if(source.buckled && source.buckled.buckle_require_restraints)
				source.buckled.unbuckle_mob()
			source.update_inv_handcuffed()
			if (source.client)
				source.client.screen -= W
			if (W)
				W.loc = source.loc
				dropped(source)
				if (W)
					W.layer = initial(W.layer)
		if (source.legcuffed && install_organ == INSTALL_FOOTS)
			var/obj/item/weapon/W = source.legcuffed
			source.legcuffed = null
			source.update_inv_legcuffed()
			if (source.client)
				source.client.screen -= W
			if (W)
				W.loc = source.loc
				dropped(source)
				if (W)
					W.layer = initial(W.layer)
	return

/obj/item/weapon/implant/freedom/install(mob/living/carbon/human/H, affected_organ)
	..()
	if(affected_organ in list(BP_L_FOOT, BP_R_FOOT))
		install_organ = INSTALL_FOOTS
	H.mind.store_memory("Freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	H << "The implanted freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate."

/obj/item/weapon/implant/freedom/get_data()
	var/data = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> Freedom Beacon<BR>
		<b>Life:</b> optimum 5 uses<BR>
		<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
		<HR>
		<b>Implant Details:</b> <BR>
		<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking
		mechanisms<BR>
		<b>Special Features:</b><BR>
		<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
		<b>Integrity:</b> The battery is extremely weak and commonly after injection its
		life can drive down to only 1 use.<HR>
		No Implant Specifics"}
	return data


/obj/item/weapon/implantcase/freedom
	name = "glass case - 'freedom'"
	desc = "A case containing a freedom implant."
	icon_state = "implantcase-r"
	implant_type = /obj/item/weapon/implant/freedom