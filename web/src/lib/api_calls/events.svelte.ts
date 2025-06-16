import { readable_backend_date } from "$lib/utils/dates.svelte";
import * as api from "./api.svelte";
import type { ApiResponse, Event, EventWithDateHeader } from "./types";

const ENDPOINT = "events";

/**
 * Fetches all events
 * @param token - JWT token for authentication
 * @returns Promise with events data or error
 */
export async function getEvents(token: string): Promise<ApiResponse<Event[]>> {
	return api.get<Event[]>(ENDPOINT, token);
}

/**
 * Fetches all community events
 * @param token - JWT token for authentication
 * @returns Promise with events data or error
 */
export async function getCommunityEvents(token: string): Promise<ApiResponse<Event[]>> {
	return api.get<Event[]>(`community_events`, token);
}

/**
 * Fetches a single event by ID
 * @param id - Event ID
 * @param token - JWT token for authentication
 * @returns Promise with event data or error
 */
export async function getEvent(id: number, token: string): Promise<ApiResponse<Event>> {
	return api.get<Event>(`${ENDPOINT}/${id}`, token);
}

/**
 * Creates a new event
 * @param data - Event data
 * @param token - JWT token for authentication
 * @returns Promise with created event data or error
 */
export async function createEvent(
	data: Pick<Event, "title" | "description" | "start_date_time" | "address" | "url" | "is_public">,
	token: string,
): Promise<ApiResponse<Event>> {
	return api.post<Event>(ENDPOINT, data, token);
}

/**
 * Updates an existing event
 * @param id - Event ID
 * @param data - Updated event data
 * @param token - JWT token for authentication
 * @returns Promise with updated event data or error
 */
export async function updateEvent(
	id: number,
	data: Partial<Event>,
	token: string,
): Promise<ApiResponse<Event>> {
	return api.patch<Event>(`${ENDPOINT}/${id}`, data, token);
}

/**
 * Deletes an event
 * @param id - Event ID
 * @param token - JWT token for authentication
 * @returns Promise with success status or error
 */
export async function deleteEvent(id: number, token: string): Promise<ApiResponse<void>> {
	return api.del(`${ENDPOINT}/${id}`, token);
}

/**
 * Processes event dates for display by adding date headers
 * @param response - API response containing events
 * @returns Array of events with date headers inserted, or empty array if error
 */
export function process_dates(response: ApiResponse<Event[]>): EventWithDateHeader[] {
	if (!response.success || !response.res) {
		console.error("Failed to process events:", response.message);
		return [];
	}

	const events = response.res;
	if (!events.length) return [];

	const processed: EventWithDateHeader[] = [];
	let current_date = "";

	for (const event of events) {
		const { date_string } = readable_backend_date(event.start_date_time);

		if (date_string !== current_date) {
			current_date = date_string;
			processed.push({ date_header: current_date });
		}

		processed.push({
			...event,
			start_date_time: event.start_date_time,
			time_string: new Date(event.start_date_time).toLocaleTimeString(),
		});
	}

	return processed;
}
