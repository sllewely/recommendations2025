// import * as api from '$lib/api_calls/api.svelte';


let root_url = "http://127.0.0.1:3000/"

export async function getEvents(jwt) {
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