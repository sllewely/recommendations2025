import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

const FORWARDED = ["user_id", "type"];

export async function GET({ url, cookies }) {
	const jwt = cookies.get("jwt");

	const params = new URLSearchParams({ page: url.searchParams.get("page") ?? "1" });
	for (const key of FORWARDED) {
		const value = url.searchParams.get(key);
		if (value) params.set(key, value);
	}

	const more_posts_response = await api.get("posts?" + params, jwt);

	return json(more_posts_response["res"]);
}
