import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

// Save a registration for a web push subscription
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");

	const subscription: PushSubscription = await request.json();

	console.log(subscription);

	const response = await api.post("web_push_registrations/", subscription, jwt);

	return json(response);
}
