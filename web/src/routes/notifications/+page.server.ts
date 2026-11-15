import * as api from "$lib/api_calls/api.svelte.js";
import type { ApiResponse, NotificationResponse } from "$lib/api_calls/types";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt }: LoadAuthContext) => {
	const notifications: ApiResponse<NotificationResponse> = await api.get("notifications", jwt);

	if (notifications.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		notifications: notifications["res"]?.["notifications"] ?? [],
		pagy: notifications["res"]?.["pagy"],
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
	ignore_friend_request: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		return api.post(`friend_requests/${data.get("id")}/ignore`, {}, jwt);
	}),
};
