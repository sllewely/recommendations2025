import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

export async function GET({ url, cookies }) {
	const jwt = cookies.get("jwt");

	const web_registrations_response = await api.get("web_push_registrations", jwt);

	return json(web_registrations_response["res"]);
}
