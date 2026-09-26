import * as api from "./api.svelte";
import type { ApiResponse, Circle } from "./types";

const ENDPOINT = "circles";

/**
 * Fetches the current user's circles
 * @param token - JWT token for authentication
 * @returns Promise with an array of circles or error
 */
export async function getCircles(token: string): Promise<ApiResponse<Circle[]>> {
	return api.get<Circle[]>(ENDPOINT, token);
}

/**
 * Fetches a single circle by ID
 * @param id - Circle ID
 * @param token - JWT token for authentication
 * @returns Promise with circle data or error
 */
export async function getCircle(id: string, token: string): Promise<ApiResponse<Circle>> {
	return api.get<Circle>(`${ENDPOINT}/${id}`, token);
}

/**
 * Creates a new circle
 * @param data - Circle name and member ids
 * @param token - JWT token for authentication
 * @returns Promise with created circle data or error
 */
export async function createCircle(
	data: { name: string; member_ids: string[] },
	token: string,
): Promise<ApiResponse<Circle>> {
	return api.post<Circle>(ENDPOINT, data, token);
}

/**
 * Adds a user to a circle
 * @param id - Circle ID
 * @param user_id - User ID to add
 * @param token - JWT token for authentication
 * @returns Promise with the updated circle or error
 */
export async function addMember(
	id: string,
	user_id: string,
	token: string,
): Promise<ApiResponse<Circle>> {
	return api.post<Circle>(`${ENDPOINT}/${id}/add`, { user_id }, token);
}

/**
 * Removes a user from a circle
 * @param id - Circle ID
 * @param user_id - User ID to remove
 * @param token - JWT token for authentication
 * @returns Promise with the updated circle or error
 */
export async function removeMember(
	id: string,
	user_id: string,
	token: string,
): Promise<ApiResponse<Circle>> {
	return api.post<Circle>(`${ENDPOINT}/${id}/remove`, { user_id }, token);
}

/**
 * Deletes a circle
 * @param id - Circle ID
 * @param token - JWT token for authentication
 * @returns Promise with success status or error
 */
export async function deleteCircle(id: string, token: string): Promise<ApiResponse<void>> {
	return api.del(`${ENDPOINT}/${id}`, token);
}
