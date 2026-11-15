import type { CalendarUrl, Group } from "$lib/api_calls/types";

let calendarUrl: CalendarUrl | null = $state(null);
let groups: Group[] = $state([]);

// TODO: on sign in, trigger globals
// on sign out, wipe

export const global = {
	get calendarUrl() {
		return calendarUrl;
	},
	set calendarUrl(value) {
		calendarUrl = value;
	},
	get groups() {
		return groups;
	},
	set groups(value) {
		groups = value;
	},
};
