export type component = {
	load: () -> (),
	unload: () -> (),
}

export type settings = {
	music: boolean,
	sound: boolean,
}

export type playerData = {

	coins: number,

	settings: settings,

	currentKnife: {
		name: string,
	},
	currentGun: {
		name: string,
	},

	roles: { string },
	joinDate: number,
}

return nil
