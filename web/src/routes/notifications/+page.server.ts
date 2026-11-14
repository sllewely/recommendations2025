import * as api from "$lib/api_calls/api.svelte.js";
import type { ApiResponse, NotificationResponse } from "$lib/api_calls/types";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt }: LoadAuthContext) => {
	const notifications: ApiResponse<NotificationResponse> = await api.get("notifications", jwt);
	const friend_requests_response = await api.get("friend_requests", jwt);

	if (notifications.unauthorized || friend_requests_response.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		notifications: notifications["res"]?.["notifications"] ?? [],
		pagy: notifications["res"]?.["pagy"],
		friend_requests: friend_requests_response["res"]?.["incoming_friend_requests"] ?? [],
	};
});

export const actions = {
	accept_friend_request: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();

		const response = await api.post(
			"friendships",
			{
				friend_id: data.get("user_id"),
			},
			jwt,
		);

		return response;
	}),
};
