/obj/item/projectile/remotecontrolled
	name = "remote controlled missile"
	icon_state = "atrocket"
	speed = 2
	damage = 15
	knockdown = 10
	var/mob/camera/aiEye/remote/controller/eyeobj

/obj/item/projectile/remotecontrolled/Initialize()
	create_eye()

/obj/item/projectile/remotecontrolled/Destroy()
	if (eyeobj)
		remove_eye_control()
		qdel(eyeobj)
	..()

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

	if (eyeobj.eye_user.client)
		eyeobj.eye_user.reset_perspective(null)
		eyeobj.RemoveImages()

	eyeobj.eye_user.remote_control = null
	eyeobj.eye_user = null

/mob/camera/aiEye/remote/controller
	name = "Inactive Controller Camera Eye"

/mob/camera/aiEye/remote/controller/relaymove(mob/user, direct)
	if (istype(origin, /obj/item/projectile/remotecontrolled/))
		var/obj/item/projectile/remotecontrolled/P = origin
		P.setAngle(dir2angle(direct))

/obj/item/projectile/remotecontrolled/fist
	name = "remote controlled fist"
	damage = 10
	knockdown = 60
	stamina = 50
	var/obj/item/bodypart/r_arm/robot/rocket/rocket_arm

/obj/item/projectile/remotecontrolled/fist/on_hit(atom/target, blocked = FALSE)
	. = ..()
	drop_arm()

/obj/item/projectile/remotecontrolled/fist/on_range()
	. = ..()
	drop_arm()

/obj/item/projectile/remotecontrolled/fist/proc/drop_arm()
	rocket_arm.fired = FALSE
	rocket_arm.forceMove(loc)
	rocket_arm.icon_state = "borg_r_arm"