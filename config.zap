opt server_output = "src/shared/Remotes/ServerRemotes.luau"
opt client_output = "src/shared/Remotes/ClientRemotes.luau"

event Sound = {
	from: Server,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		id: string,
		group: string,
		volume: u8,
		playAt: Vector3?,
	},
}

event Attack = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		characterCFrame: CFrame,
		mousePosition: Vector3,
	},
}

event CoinSpawn = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		position: i32[0..3],
		uuid: string,
	},
}

event CoinDestroy = {
	from: Server,
	type: Reliable,
	call: ManyAsync,
	data: string
}

event Input = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event LoadSettings = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: map {[string]: boolean}
}

event SetSetting = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		name: string,
		data: boolean
	}
}

event Equip = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event Unequip = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
}

event Round = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		started: boolean,
		role: string,
	},
}

event Coins = {
	from: Server,
	type: Unreliable,
	call: SingleAsync,
	data: u32,
}

event OpenCrate = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: string,
}

event CrateResult = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: string,
}
