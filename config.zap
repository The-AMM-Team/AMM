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

event Role = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: string,
}