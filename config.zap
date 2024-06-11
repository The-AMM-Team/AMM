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
	data: boolean,
}

event Role = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: string,
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
