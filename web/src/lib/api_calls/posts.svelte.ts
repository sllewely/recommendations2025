import {token} from "$lib/api_calls/auth.svelte";

let root_url = "http://127.0.0.1:3000/"

export async function getPosts() {
    const response = await fetch(root_url + "posts", {
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

export async function getPostsForUser(user_id: string) {
    const response = await fetch(root_url + "posts?user_id=" + user_id, {
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