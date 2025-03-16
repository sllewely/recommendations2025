import { getUser } from '$lib/api_calls/users.svelte.js';
import {token} from "$lib/api_calls/auth.svelte";

export async function load({ params }) {

    let user_id = token.my_user_id;
    let user = await getUser(user_id);

    // TODO: posts response included user: { username..., etc} but is lost in the next step somehow

    return {
        user: user,
    }

}
