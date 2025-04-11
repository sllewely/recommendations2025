import { VITE_API_URL } from '$env/static/private';
import * as api from "$lib/api_calls/api.svelte";


let root_url = VITE_API_URL

export async function getPosts(jwt) {
    const response = await fetch(root_url + "posts", {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + jwt,
        },
    });
    const json = await response.json();

    return json;
}

export async function getPost(jwt:string, id:string) {
    const response = await api.get(
        `posts/${id}`,
        jwt,
    );

    return response;
}

export async function getPostsForUser(jwt, user_id: string) {
    const response = await fetch(root_url + "posts?user_id=" + user_id, {
        method: "GET",
        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + jwt,
        },
    });
    const json = await response.json();

    return json;

}