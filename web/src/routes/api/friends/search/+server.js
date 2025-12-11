import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

export async function GET({ url, cookies }) {
	const jwt = cookies.get("jwt");
	const search = url.searchParams.get("search") ?? "";

	const response = await api.get("friendships?search=" + search.toString(), jwt);

	return json(response["res"]);
}
