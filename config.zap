opt server_output = "src/server/serverNet.luau"
opt client_output = "src/client/clientNet.luau"

event Attack = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		characterCFrame: CFrame,
		mousePosition: Vector3,
	},
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
	type: Reliable,
	call: SingleAsync,
	data: i32,
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
