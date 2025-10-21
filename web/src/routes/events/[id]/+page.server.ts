import * as api from "$lib/api_calls/api.svelte.ts";
import { getPost, getPostPublic } from "$lib/api_calls/posts.svelte";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	const my_user_id = cookies.get("user_id");
	const event_id = params.id;

	let eventApiCall =
		typeof jwt === "string"
			? api.get(`events/` + event_id, jwt)
			: api.get(`public/events/` + event_id);

	let res = await eventApiCall;

	return {
		event: res["res"],
		// user: user,
		my_user_id: my_user_id,
	};
}

// named action for sign in form
export const actions = {
	update_rsvp: async ({ cookies, request }) => {
		const data = await request.formData();

		const jwt = cookies.get("jwt");

		const response = await api.post(
			"rsvps",
			{
				status: data.get("rsvp_status"),
				event_id: data.get("event_id"),
				user_id: data.get("user_id"),
			},
			jwt,
		);

		return response;
	},
	submit_comment: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

		return await api.post(
			"comments",
			{
				body: data.get("body"),
				commentable_id: data.get("commentable_id"),
				commentable_type: data.get("commentable_type"),
			},
			jwt,
		);
	},
};
