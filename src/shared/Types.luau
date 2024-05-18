export type component = {
	load: () -> (),
	unload: () -> (),
}

export type playerData = {

	coins: number,

	currentKnife: {
		name: string,
	},
	currentGun: {
		name: string,
	},

	roles: { string },
	joinData: number,
}

return nil
