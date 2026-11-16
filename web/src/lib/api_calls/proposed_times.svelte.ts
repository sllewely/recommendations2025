import * as api from "./api.svelte";
import type { ApiResponse, Event, ProposedTime } from "./types";

const ENDPOINT = "proposed_times";

/**
 * Votes for a proposed event time
 * @param id - Proposed time ID
 * @param token - JWT token for authentication
 * @returns Promise with the updated proposed time or error
 */
export async function voteForProposedTime(
	id: string,
	token: string,
): Promise<ApiResponse<ProposedTime>> {
	return api.post<ProposedTime>(`${ENDPOINT}/${id}/vote`, {}, token);
}

/**
 * Removes the current user's vote for a proposed event time
 * @param id - Proposed time ID
 * @param token - JWT token for authentication
 * @returns Promise with success status or error
 */
export async function removeVoteForProposedTime(
	id: string,
	token: string,
): Promise<ApiResponse<void>> {
	return api.del(`${ENDPOINT}/${id}/vote`, token);
}

/**
 * Host chooses the winning proposed time, which becomes the event's start time
 * @param id - Proposed time ID
 * @param token - JWT token for authentication
 * @returns Promise with the updated event or error. Returns 403 if not the host
 */
export async function chooseProposedTime(id: string, token: string): Promise<ApiResponse<Event>> {
	return api.post<Event>(`${ENDPOINT}/${id}/choose`, {}, token);
}

/**
 * Host unconfirms the chosen proposed time; the event goes back to pending
 * @param id - Proposed time ID
 * @param token - JWT token for authentication
 * @returns Promise with the updated event or error. Returns 403 if not the host
 */
export async function unchooseProposedTime(id: string, token: string): Promise<ApiResponse<Event>> {
	return api.del<Event>(`${ENDPOINT}/${id}/choose`, token);
}
