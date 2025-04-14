import * as api from "$lib/api_calls/api.svelte";


export async function getUser(jwt: string, id: string) {
    const response = await api.get(
        `users/${id}`,
        jwt,
    );

    return response;
}

export async function getUsers(jwt: string) {
    const response = await api.get(
        'users',
        jwt,
    );

    return response;
}
