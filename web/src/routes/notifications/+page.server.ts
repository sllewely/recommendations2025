import * as api from "$lib/api_calls/api.svelte.js";
import type { ApiError, ApiResponse, NotificationResponse } from "$lib/api_calls/types";

export async function load({ cookies }) {
	const jwt = cookies.get("jwt");

	const notifications: ApiResponse<NotificationResponse> = await api.get("notifications", jwt);

	return {
		notifications: notifications["res"]["notifications"],
		pagy: notifications["res"]["pagy"],
	};
}

export const actions = {
	add_friend: async ({ cookies, request }) => {
		const data = await request.formData();

		const jwt = cookies.get("jwt");

		const response = await api.post(
			"friend_requests",
			{
				user_id: data.get("user_id"),
			},
			jwt,
		);

		return response;
	},
};
