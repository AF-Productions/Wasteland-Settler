/obj/item/ammo_casing/caseless
	desc = "A caseless bullet casing."
	firing_effect_type = null
	heavy_metal = FALSE
	custom_materials = list(
		/datum/material/iron = MATS_PISTOL_MEDIUM_CASING + MATS_PISTOL_MEDIUM_BULLET,
		/datum/material/blackpowder = MATS_PISTOL_MEDIUM_POWDER)

/obj/item/ammo_casing/caseless/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, damage_multiplier, penetration_multiplier, projectile_speed_multiplier, atom/fired_from)
	if (..()) //successfully firing
		moveToNullspace()
		if(istype(fired_from, /obj/item/gun))
			var/obj/item/gun/gonne = fired_from
			if(gonne.chambered == src)
				gonne.chambered = null // harddels suffer
				gonne.update_icon()
		qdel(src)
		return TRUE
	else
		return FALSE

/obj/item/ammo_casing/caseless/update_icon_state()
	icon_state = "[initial(icon_state)]"

/obj/item/ammo_casing/caseless/needle
	name = "A needler round."
	desc = "A dart for use in needler pistols."
	icon_state = "needler-casing"
	caliber = CALIBER_NEEDLE
	projectile_type = /obj/item/projectile/bullet/needle
	var/reagent_amount = 15

/obj/item/ammo_casing/caseless/musketball
	name = "Musketball"
	desc = "This is a lead ball for a musket."
	caliber = CALIBER_MUSKET_BALL
	projectile_type = /obj/item/projectile/bullet/F13/musketball

/obj/item/ammo_casing/caseless/lasermusket
	name = "Battery"
	desc = "A single use battery for the lasmusket."
	caliber = CALIBER_MUSKET_LASER
	icon_state = "lasmusketbat"
	projectile_type = /obj/item/projectile/beam/laser/musket
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy

/obj/item/ammo_casing/caseless/plasmacart
	name = "Plasma cartidge"
	desc = "A single use can of plasma for the plasma musket."
	caliber = CALIBER_PLASMA_CARTRIDGE
	icon_state = "plasmacan"
	projectile_type = /obj/item/projectile/plasmacarbine
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy
