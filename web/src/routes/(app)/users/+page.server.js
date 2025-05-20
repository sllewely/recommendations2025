import { getUsers } from "$lib/api_calls/users.svelte.js";

export async function load({ cookies }) {
	const jwt = cookies.get("jwt");
	const users = await getUsers(jwt);
	return { users: users.res };
}
