import type { CalendarUrl } from "$lib/api_calls/types";

let calendarUrl: CalendarUrl | null = $state(null);

// TODO: on sign in, trigger globals
// on sign out, wipe

export const global = {
	get calendarUrl() {
		return calendarUrl;
	},
	set calendarUrl(value) {
		calendarUrl = value;
	},
};
