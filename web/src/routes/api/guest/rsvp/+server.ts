import { json } from "@sveltejs/kit";
import { guestRsvp } from "$lib/api_calls/guests.svelte.js";
import { getGuestToken, setGuestCookies } from "$lib/server/guest_cookies";

// RSVP to an event as a guest; remembers the guest in this browser
export async function POST({ request, cookies }) {
	const { event_id, status, name, email } = await request.json();

	const response = await guestRsvp(event_id, { status, name, email }, getGuestToken(cookies));
	if (!response.success) {
		return json(response);
	}

	const { token, ...guest } = response.res.guest;
	setGuestCookies(cookies, { ...guest, token });
	// the token stays in the httpOnly cookie
	return json({ success: true, res: { guest, rsvp: response.res.rsvp } });
}
