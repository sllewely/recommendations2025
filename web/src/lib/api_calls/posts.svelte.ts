import * as api from "./api.svelte";
import type { ApiResponse, Post, PostsResponse } from "./types";

const ENDPOINT = "posts";

/**
 * Fetches all posts
 * @param token - JWT token for authentication
 * @returns Promise with posts data or error
 */
export async function getPosts(token: string): Promise<ApiResponse<PostsResponse>> {
	return api.get<PostsResponse>(ENDPOINT, token);
}

/**
 * Fetches a single post by ID
 * @param id - Post ID
 * @param token - JWT token for authentication
 * @returns Promise with post data or error
 */
export async function getPost(id: string, token: string): Promise<ApiResponse<Post>> {
	return api.get<Post>(`${ENDPOINT}/${id}`, token);
}

/**
 * Fetches a single post by ID, for not logged in users
 * @param id - Post ID
 * @returns Promise with post data or error
 */
export async function getPostPublic(id: string): Promise<ApiResponse<Post>> {
	return api.get<Post>(`public/${ENDPOINT}/${id}`);
}

/**
 * Fetches posts for a specific user
 * @param userId - User ID to fetch posts for
 * @param token - JWT token for authentication
 * @returns Promise with posts data or error
 */
export async function getPostsForUser(userId: number, token: string): Promise<ApiResponse<Post[]>> {
	return api.get<Post[]>(`${ENDPOINT}?user_id=${userId}`, token);
}

/**
 * Creates a new post
 * @param data - Post data
 * @param token - JWT token for authentication
 * @returns Promise with created post data or error
 */
export async function createPost(
	data: { title: string; body: string },
	token: string,
): Promise<ApiResponse<Post>> {
	return api.post<Post>(ENDPOINT, data, token);
}

/**
 * Updates an existing post
 * @param id - Post ID
 * @param data - Updated post data
 * @param token - JWT token for authentication
 * @returns Promise with updated post data or error
 */
export async function updatePost(
	id: number,
	data: Partial<Post>,
	token: string,
): Promise<ApiResponse<Post>> {
	return api.patch<Post>(`${ENDPOINT}/${id}`, data, token);
}

/**
 * Deletes a post
 * @param id - Post ID
 * @param token - JWT token for authentication
 * @returns Promise with success status or error
 */
export async function deletePost(id: number, token: string): Promise<ApiResponse<void>> {
	return api.del(`${ENDPOINT}/${id}`, token);
}
