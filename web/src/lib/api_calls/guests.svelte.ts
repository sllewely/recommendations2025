import * as api from "./api.svelte";
import type { ApiResponse, Guest, GuestRsvp, GuestRsvpStatus, ProposedTime } from "./types";

// the guest's own record, including the token that identifies their browser
export type GuestWithToken = Guest & { token: string };

const guestHeaders = (guest_token?: string): Record<string, string> =>
	guest_token ? { "X-Guest-Token": guest_token } : {};

/**
 * RSVPs to an event as a guest, without an account
 * @param event_id - Event ID
 * @param data - RSVP status, plus name (required for a new guest) and optional email
 * @param guest_token - token for a returning guest
 * @returns Promise with the guest and their rsvp, or error. Returns 422 if the name or email is invalid
 */
export async function guestRsvp(
	event_id: string,
	data: { status: GuestRsvpStatus; name?: string; email?: string },
	guest_token?: string,
): Promise<ApiResponse<{ guest: GuestWithToken; rsvp: GuestRsvp }>> {
	return api.post(`public/events/${event_id}/rsvp`, data, undefined, guestHeaders(guest_token));
}

/**
 * Votes for a proposed event time as a guest
 * @param id - Proposed time ID
 * @param data - name (required for a new guest) and optional email
 * @param guest_token - token for a returning guest
 * @returns Promise with the guest and the updated proposed time, or error
 */
export async function guestVote(
	id: string,
	data: { name?: string; email?: string },
	guest_token?: string,
): Promise<ApiResponse<{ guest: GuestWithToken; proposed_time: ProposedTime }>> {
	return api.post(`public/proposed_times/${id}/vote`, data, undefined, guestHeaders(guest_token));
}

/**
 * Removes a guest's vote for a proposed event time
 * @param id - Proposed time ID
 * @param guest_token - the guest's token
 * @returns Promise with success status or error
 */
export async function guestUnvote(id: string, guest_token?: string): Promise<ApiResponse<void>> {
	return api.del(`public/proposed_times/${id}/vote`, undefined, guestHeaders(guest_token));
}
