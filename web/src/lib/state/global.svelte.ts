import type { Group } from "$lib/api_calls/types";

let groups: Group[] = $state([]);

// TODO: on sign in, trigger globals
// on sign out, wipe

export const global = {
	get groups() {
		return groups;
	},
	set groups(value) {
		groups = value;
	},
};
