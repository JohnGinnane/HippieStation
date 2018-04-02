/obj/item/bodypart/r_arm/robot/rocket
	name = "rocket powered right arm"
	desc = "A cyborg right arm that detaches at the wrist."
	actions_types = list(/datum/action/item_action/fire_fist)
	var/obj/item/weldingtool/rocket_fist/fist
	var/projectile_type = /obj/item/projectile/remotecontrolled/fist

/obj/item/bodypart/r_arm/robot/rocket/Initialize()
	. = ..()
	fist = new(loc)
	fist.attached = src
	fist.forceMove(src)

/obj/item/bodypart/r_arm/robot/rocket/item_action_slot_check(slot, mob/user)
	if (owner && fist)
		return TRUE

/obj/item/bodypart/r_arm/robot/rocket/ui_action_click()
	fire_fist()

/datum/action/item_action/fire_fist
	name = "Fire Fist"
	button_icon = 'icons/obj/robot_parts.dmi'
	button_icon_state = "borg_r_arm"

/obj/item/bodypart/r_arm/robot/rocket/verb/fire_fist()
	set name = "Fire Fist"
	set category = "Object"

	if (owner && fist)
		var/mob/living/carbon/C = owner
		var/obj/item/projectile/remotecontrolled/fist/P = new projectile_type(get_turf(C))
		P.firer = C ? C : src
		P.range = fist.get_fuel()
		P.fist = fist
		fist.forceMove(P)
		fist = null
		P.fire(dir2angle(C.dir))
		remove_verbs()
		if (held_index)
			C.dropItemToGround(owner.get_item_for_held_index(held_index), 1)
			C.hand_bodyparts[held_index] = null
			var/obj/screen/inventory/hand/R = C.hud_used.hand_slots["[held_index]"]
			if(R)
				R.update_icon()
		C.update_body()

/obj/item/bodypart/r_arm/robot/rocket/proc/add_verbs()
	for(var/X in actions)
		var/datum/action/A = X
		A.Grant(owner)

/obj/item/bodypart/r_arm/robot/rocket/proc/remove_verbs()
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(owner)

/obj/item/bodypart/r_arm/robot/rocket/attach_limb(mob/living/carbon/C, special)
	. = ..()
	add_verbs()

/obj/item/bodypart/r_arm/robot/rocket/drop_limb(special)
	remove_verbs()
	. = ..()

/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/weldingtool/rocket_fist))
		var/obj/item/bodypart/r_arm/robot/rocket/r_arm = get_bodypart("r_arm")

		if (!r_arm)
			return

		if (r_arm.fist)
			return

		if (do_after(user, 10, target = src))
			if (user.transferItemToLoc(I, r_arm))
				visible_message("<span class='notice'>[src] attaches the rocket fist into the socket on \his arm.</span>",
					            "<span class='notice'>You attach the rocket fist into the socket on your arm.</span>")
				playsound(loc, 'sound/machines/click.ogg', 50, TRUE, -1)
				r_arm.fist = I
				r_arm.fist.attached = r_arm
				r_arm.add_verbs()
				hand_bodyparts[r_arm.held_index] = r_arm
				var/obj/screen/inventory/hand/R = hud_used.hand_slots["[r_arm.held_index]"]
				if(R)
					R.update_icon()
				return TRUE
		else
			return

	..()

/obj/item/weldingtool/rocket_fist
	name = "rocket powered fist"
	desc = "Looks like it uses welding fuel for rocket-powered flight."
	max_fuel = 50 // Used to set projectile "range"
	var/attached // If this is attached to something, dropping will return to it's origin