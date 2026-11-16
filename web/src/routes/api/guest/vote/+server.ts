import { json } from "@sveltejs/kit";
import { guestUnvote, guestVote } from "$lib/api_calls/guests.svelte.js";
import { getGuestToken, setGuestCookies } from "$lib/server/guest_cookies";

// Vote for, or remove a vote for, a proposed event time as a guest
export async function POST({ request, cookies }) {
	const { id, vote, name, email } = await request.json();
	const guest_token = getGuestToken(cookies);

	if (!vote) {
		return json(await guestUnvote(id, guest_token));
	}

	const response = await guestVote(id, { name, email }, guest_token);
	if (!response.success) {
		return json(response);
	}

	const { token, ...guest } = response.res.guest;
	setGuestCookies(cookies, { ...guest, token });
	// the token stays in the httpOnly cookie
	return json({ success: true, res: { guest, proposed_time: response.res.proposed_time } });
}
