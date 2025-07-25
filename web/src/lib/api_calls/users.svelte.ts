import * as api from "./api.svelte";
import type { ApiResponse, User, UserUpdatePayload } from "./types";

const ENDPOINT = "users";

/**
 * Fetches the current user's profile
 * @param token - JWT token for authentication
 * @returns Promise with user data or error
 */
export async function getCurrentUser(token: string): Promise<ApiResponse<User>> {
	return api.get<User>(`${ENDPOINT}/me`, token);
}

/**
 * Fetches a user by ID
 * @param id - User ID
 * @param token - JWT token for authentication
 * @returns Promise with user data or error
 */
export async function getUser(id: string, token: string): Promise<ApiResponse<User>> {
	return api.get<User>(`${ENDPOINT}/${id}`, token);
}

/**
 * Fetches all users
 * @param token - JWT token for authentication
 * @returns Promise with an array of users or error
 */
export async function getUsers(token: string): Promise<ApiResponse<User[]>> {
	return api.get<User[]>(ENDPOINT, token);
}

/**
 * Updates the current user's profile
 * @param user_id - User ID
 * @param data - Updated user data
 * @param token - JWT token for authentication
 * @returns Promise with updated user data or error
 */
export async function updateUser(
	user_id: string,
	data: Partial<UserUpdatePayload>,
	token: string,
): Promise<ApiResponse<User>> {
	return api.patch<User>(`${ENDPOINT}/${user_id}`, data, token);
}
