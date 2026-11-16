import * as api from "./api.svelte";
import type { ApiResponse, PlusOne } from "./types";

const ENDPOINT = "plus_ones";

/**
 * Adds a +1 to an event
 * @param event_id - Event ID
 * @param name - the +1's name
 * @param token - JWT token for authentication
 * @returns Promise with the created +1 or error. Returns 422 if the name is missing or too many +1s
 */
export async function addPlusOne(
	event_id: string,
	name: string,
	token: string,
): Promise<ApiResponse<PlusOne>> {
	return api.post<PlusOne>(ENDPOINT, { event_id, name }, token);
}

/**
 * Removes a +1; only the person who added them, or the host
 * @param id - +1 ID
 * @param token - JWT token for authentication
 * @returns Promise with success status or error
 */
export async function removePlusOne(id: string, token: string): Promise<ApiResponse<void>> {
	return api.del(`${ENDPOINT}/${id}`, token);
}
