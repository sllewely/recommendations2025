import { json } from "@sveltejs/kit";
import { clearGuestCookies } from "$lib/server/guest_cookies";

// "Not you?" -- stop acting as the remembered guest in this browser
export async function POST({ cookies }) {
	clearGuestCookies(cookies);
	return json({ success: true });
}
