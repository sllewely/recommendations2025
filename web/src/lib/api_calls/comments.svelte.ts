import * as api from "./api.svelte";
import type { ApiResponse, Comment } from "./types";

const ENDPOINT = "comments";

export type CommentPayload = {
	body: string;
	commentable_type: string;
	commentable_id: number;
};

/**
 * Creates a new comment
 * Note: Backend only allows commenting within friends' content
 * @param data - Comment data including body and commentable information
 * @param token - JWT token for authentication
 * @returns Promise with created comment data or error. Returns 422 if validation fails
 */
export async function createComment(
	data: CommentPayload,
	token: string,
): Promise<ApiResponse<Comment>> {
	return api.post<Comment>(ENDPOINT, data, token);
}

/**
 * Updates an existing comment
 * Note: Only the comment owner can update their comments
 * @param id - Comment ID
 * @param data - Updated comment data (only body can be updated)
 * @param token - JWT token for authentication
 * @returns Promise with updated comment data or error. Returns 404 if comment not found
 */
export async function updateComment(
	id: number,
	data: { body: string },
	token: string,
): Promise<ApiResponse<Comment>> {
	return api.patch<Comment>(`${ENDPOINT}/${id}`, data, token);
}
