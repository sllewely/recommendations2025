import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";
import { RecommendationStatus } from "$lib/enums.js";

export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");
	const { title, media_type, url, who_recommended } = await request.json();

	const response = await api.post(
		"recommendations",
		{ title, media_type, url, who_recommended, status: RecommendationStatus.Interested },
		jwt,
	);

	return json(response, { status: response.success ? 200 : (response.status ?? 500) });
}
