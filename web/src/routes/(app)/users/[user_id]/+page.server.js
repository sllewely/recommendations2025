import { getUser } from '$lib/api_calls/users.svelte.js';

export async function load({ params }) {

    let user_id = params.user_id;
    let user = await getUser(user_id);

    return {
        user: user,
    }
}
