import { getPosts } from '$lib/api_calls/posts.svelte.js';
import { getEvents } from '$lib/api_calls/events.svelte.js';
import { readable_backend_date } from '$lib/utils/dates.svelte';

export async function load() {

    let posts = await getPosts();
    let events = await getEvents();

    let events_with_dates_headers = process_dates(events);

    return {
        posts: posts,
        events: events_with_dates_headers,
    }

}

function process_dates(events) {
    // TODO: I should have done all of this on the backend lol

    let events_and_dates = [];
    let today = new Date();
    let dd = String(today.getDate()).padStart(2, '0');
    let mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    let yyyy = today.getFullYear();
    let current_date_string = mm + '/' + dd + '/' + yyyy;
    events_and_dates.push({date_header: current_date_string});

    for (const event of events) {
        let {date_string, time_string} = readable_backend_date(event['start_date_time']);
        event['time_string'] = time_string;
        if (date_string === current_date_string) {
            events_and_dates.push(event);
        } else {
            current_date_string = date_string;
            events_and_dates.push({date_header: current_date_string});
            events_and_dates.push(event);
        }

    }

    return events_and_dates;
}