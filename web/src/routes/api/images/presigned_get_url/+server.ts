import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

export async function GET({ url, cookies }) {
	const jwt = cookies.get("jwt");
	const search = url.searchParams.get("filename") ?? "";

	const response = await api.get("images/signed_get_url", jwt);

	return json(response["res"]);
}
