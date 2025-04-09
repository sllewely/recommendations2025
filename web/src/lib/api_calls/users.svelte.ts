import { VITE_API_URL } from '$env/static/private';
import * as api from "$lib/api_calls/api.svelte";


let root_url = VITE_API_URL

export async function getUser(jwt: string, id: string) {
    const response = await fetch(root_url + "users/" + id , {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + jwt,
        },
    });
    return await response.json();
}

export async function getUsers(jwt: string) {
    const response = await api.get(
        'users',
        jwt,
    );

    return response;
}
