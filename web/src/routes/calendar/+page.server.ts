import { redirect } from "@sveltejs/kit";
import { withAuth, type LoadAuthContext } from "$lib/auth";
import { getEvents } from "$lib/api_calls/events.svelte";

export const load = withAuth(async ({ jwt }: LoadAuthContext) => {
	const events = await getEvents(jwt);
	if (events.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	// upcoming events, already sorted by start_date_time
	return {
		events: events.success ? events.res : [],
	};
});
