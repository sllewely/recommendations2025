import * as api from "$lib/api_calls/api.svelte.js";
import type { ApiError, ApiResponse, NotificationResponse } from "$lib/api_calls/types";

export async function load({ cookies }) {
	const jwt = cookies.get("jwt");

	const notifications: ApiResponse<NotificationResponse> = await api.get("notifications", jwt);

	const friend_requests_response = await api.get("friend_requests", jwt);

	return {
		notifications: notifications["res"]["notifications"],
		pagy: notifications["res"]["pagy"],
		friend_requests: friend_requests_response["res"]["incoming_friend_requests"],
	};
}

export const actions = {
	accept_friend_request: async ({ cookies, request }) => {
		const data = await request.formData();

		const jwt = cookies.get("jwt");

		const response = await api.post(
			"friendships",
			{
				friend_id: data.get("user_id"),
			},
			jwt,
		);

		return response;
	},
};
