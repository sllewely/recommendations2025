import {token} from "$lib/api_calls/auth.svelte";

let root_url = "http://127.0.0.1:3000/"

export async function getRecommendations() {
    const response = await fetch(root_url + "recommendations", {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + token.jwt,
        },
    });
    const json = await response.json();

    return json;
}

export async function getRecommendationsForUser(user_id, opt = {}) {
    let request = root_url + "recommendations?";
    request = request + "user_id=" + user_id;
    if (opt['status']) {
        request = request + "&status=" + opt['status'];
    }
    const response = await fetch(request, {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + token.jwt,
        },
    });
    const json = await response.json();

    return json;
}
