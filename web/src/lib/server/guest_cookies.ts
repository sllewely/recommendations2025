import type { Cookies } from "@sveltejs/kit";
import type { Guest } from "$lib/api_calls/types";
import type { GuestWithToken } from "$lib/api_calls/guests.svelte";

// a guest is remembered in this browser for a year
const OPTIONS = { path: "/", maxAge: 60 * 60 * 24 * 365 };

export function getGuestToken(cookies: Cookies): string | undefined {
	return cookies.get("guest_token");
}

export function getGuest(cookies: Cookies): Guest | null {
	const id = cookies.get("guest_id");
	const name = cookies.get("guest_name");
	if (!id || !name) return null;
	return { id, name, email: cookies.get("guest_email") ?? null };
}

export function setGuestCookies(cookies: Cookies, guest: GuestWithToken) {
	cookies.set("guest_token", guest.token, OPTIONS);
	cookies.set("guest_id", guest.id, OPTIONS);
	cookies.set("guest_name", guest.name, OPTIONS);
	if (guest.email) {
		cookies.set("guest_email", guest.email, OPTIONS);
	} else {
		cookies.delete("guest_email", { path: "/" });
	}
}

export function clearGuestCookies(cookies: Cookies) {
	for (const name of ["guest_token", "guest_id", "guest_name", "guest_email"]) {
		cookies.delete(name, { path: "/" });
	}
}
