import { notifs } from "$lib/state/notifications.svelte.js";

// TODO: switch to SSE instead of polling
export let fetch_notifs = async () => {
	const response = await fetch("/api/fetch_notifications", {
		method: "GET",
		headers: {
			"Content-Type": "application/json",
		},
	});
	const res = await response.json();
	if (res["res"]) {
		let notif_map = res["res"].map((notif_json) => ({
			id: notif_json.id,
			notif_type: notif_json.notif_type,
			message: notif_json.message,
			extras: notif_json.extras,
			created_at: notif_json.created_at,
		}));
		notifs.notifs = notif_map;
	} else {
		console.log("error getting notifications " + res["error"]);
	}
};
