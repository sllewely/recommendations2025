import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";

// Update profile url
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");

	const response = await api.post("images/update_profile_url", {}, jwt);

	return json(response["res"]);
}
