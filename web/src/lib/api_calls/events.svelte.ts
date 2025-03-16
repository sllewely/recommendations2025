import {token} from "$lib/api_calls/auth.svelte";

let root_url = "http://127.0.0.1:3000/"

export async function getEvents() {
    const response = await fetch(root_url + "events", {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + token.jwt,
        },
    });
    const json = await response.json();

    // TODO: catch error and display in UI

    return json;

}