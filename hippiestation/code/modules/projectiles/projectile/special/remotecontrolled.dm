/obj/item/projectile/remotecontrolled
	name = "remote controlled missile"
	icon_state = "atrocket"
	speed = 2
	damage = 15
	knockdown = 10
	var/mob/camera/aiEye/remote/controller/eyeobj

/obj/item/projectile/remotecontrolled/Initialize()
	create_eye()
	. = ..()

/obj/item/projectile/remotecontrolled/Destroy()
	addtimer(CALLBACK(firer, /mob/living/.proc/remove_remote_control), 5)
	remove_eye_control()
	. = ..()

/obj/item/projectile/remotecontrolled/fire(angle, atom/direct_target)
	. = ..()
	setAngle(dir2angle(firer.dir))
	give_eye_control(firer)

/obj/item/projectile/remotecontrolled/process()
	. = ..()
	if (eyeobj)
		if (eyeobj.eye_user)
			eyeobj.setLoc(loc)

/obj/item/projectile/remotecontrolled/proc/create_eye()
	eyeobj = new()
	eyeobj.origin = src
	eyeobj.eye_initialized = TRUE

/obj/item/projectile/remotecontrolled/proc/give_eye_control(mob/user)
	if (!eyeobj)
		create_eye()

	eyeobj.eye_user = user
	eyeobj.name = "Camera Eye ([user.name])"
	user.remote_control = eyeobj
	user.reset_perspective(eyeobj)
	eyeobj.setLoc(loc)

/obj/item/projectile/remotecontrolled/proc/remove_eye_control()
	if (!eyeobj)
		return
	if (!eyeobj.eye_user)
		return

	eyeobj.RemoveImages()
	eyeobj.eye_user.reset_perspective(null)
	eyeobj.eye_user.remote_control = null
	eyeobj.eye_user = null
	qdel(eyeobj)

/mob/living/proc/remove_remote_control()
	reset_perspective(null)
	remote_control = null

/mob/camera/aiEye/remote/controller
	name = "Inactive Controller Camera Eye"

/mob/camera/aiEye/remote/controller/relaymove(mob/user, direct)
	if (istype(origin, /obj/item/projectile/remotecontrolled/))
		var/obj/item/projectile/remotecontrolled/P = origin
		P.setAngle(dir2angle(direct))

/*
	Rocket-Powered Remote-Controlled Fist
*/
/obj/item/projectile/remotecontrolled/fist
	name = "remote controlled fist"
	damage = 5
	knockdown = 60
	stamina = 50
	var/obj/item/weldingtool/rocket_fist/fist

/obj/item/projectile/remotecontrolled/fist/on_hit(atom/target, blocked = FALSE)
	drop_arm()
	. = ..()

/obj/item/projectile/remotecontrolled/fist/on_range()
	to_chat(firer, "just ran outta fuel at [loc] ([x], [y])")
	drop_arm()
	. = ..()

/obj/item/projectile/remotecontrolled/fist/proc/drop_arm()
	fist.reagents.remove_reagent("welding_fuel", fist.max_fuel - range)
	fist.forceMove(get_turf(src))