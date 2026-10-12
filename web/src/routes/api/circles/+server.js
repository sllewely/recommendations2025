import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

// Fetch the current user's circles
export async function GET({ cookies }) {
	const jwt = cookies.get("jwt");

	const response = await api.get("circles", jwt);

	return json(response["res"] ?? []);
}
