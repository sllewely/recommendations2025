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

export async function createRecommendation(data) {
    const response = await fetch(root_url + "recommendations", {
        method: "POST",
        body: JSON.stringify({
            title: data.get('title'),
            type: data.get('media_type'),
            status: Number(data.get('status')) ?? 0,
            notes: data.get('notes'),
            who_recommended: data.get('who_recommended'),
        }),
        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + token.jwt,
        },
    });
    // if (!response.ok) {
    //     throw new Error(`Response status: ${response.status}`);
    // }
    const json = await response.json();
    return json;
}
