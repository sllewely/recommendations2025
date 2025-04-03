import { VITE_API_URL } from '$env/static/private';
import * as api from "$lib/api_calls/api.svelte.js";
import {readable_backend_date} from "$lib/utils/dates.svelte";


let root_url = VITE_API_URL

export async function getEvents(jwt: string) {
    const response = await fetch(root_url + "events", {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + jwt,
        },
    });
    const json = await response.json();

    // TODO: catch error and display in UI

    return json;
}

export async function getCommunityEvents(jwt: string) {

    const response = await api.get(
        'community_events',
        jwt,
    );

    return response;
}

export async function getEvent(jwt) {
    let res = await api.get(`events/${params.slug}`, jwt)

    const response = await fetch(root_url + "events", {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + jwt,
        },
    });
    const json = await response.json();

    // TODO: catch error and display in UI

    return json;
}

// Inserts Date Headers into events
export function process_dates(events) {
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