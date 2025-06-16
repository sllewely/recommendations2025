import * as api from "./api.svelte";
import type { ApiResponse, Recommendation, CreateRecommendationData } from "./types";

const ENDPOINT = "recommendations";

/**
 * Fetches all recommendations
 * @param token - JWT token for authentication
 * @returns Promise with recommendations data or error
 */
export async function getRecommendations(token: string): Promise<ApiResponse<Recommendation[]>> {
	return api.get<Recommendation[]>(ENDPOINT, token);
}

/**
 * Fetches a single recommendation by ID
 * @param id - Recommendation ID
 * @param token - JWT token for authentication
 * @returns Promise with recommendation data or error
 */
export async function getRecommendation(
	id: number,
	token: string,
): Promise<ApiResponse<Recommendation>> {
	return api.get<Recommendation>(`${ENDPOINT}/${id}`, token);
}

/**
 * Creates a new recommendation
 * @param data - Recommendation data
 * @param token - JWT token for authentication
 * @returns Promise with created recommendation data or error
 */
export async function createRecommendation(
	data: CreateRecommendationData,
	token: string,
): Promise<ApiResponse<Recommendation>> {
	return api.post<Recommendation>(ENDPOINT, data, token);
}

/**
 * Updates an existing recommendation
 * @param id - Recommendation ID
 * @param data - Updated recommendation data
 * @param token - JWT token for authentication
 * @returns Promise with updated recommendation data or error
 */
export async function updateRecommendation(
	id: number,
	data: Partial<Recommendation>,
	token: string,
): Promise<ApiResponse<Recommendation>> {
	return api.patch<Recommendation>(`${ENDPOINT}/${id}`, data, token);
}

/**
 * Deletes a recommendation
 * @param id - Recommendation ID
 * @param token - JWT token for authentication
 * @returns Promise with success status or error
 */
export async function deleteRecommendation(id: number, token: string): Promise<ApiResponse<void>> {
	return api.del(`${ENDPOINT}/${id}`, token);
}

/**
 * Updates a recommendation's status
 * @param id - Recommendation ID
 * @param status - New status
 * @param token - JWT token for authentication
 * @returns Promise with updated recommendation data or error
 */
export async function updateRecommendationStatus(
	id: number,
	status: string,
	token: string,
): Promise<ApiResponse<Recommendation>> {
	return api.patch<Recommendation>(`${ENDPOINT}/${id}`, { status }, token);
}
