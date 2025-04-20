import {getPosts} from '$lib/api_calls/posts.svelte.js';
import {getEvents} from '$lib/api_calls/events.svelte.js';
import {readable_backend_date} from '$lib/utils/dates.svelte';
import * as api from "$lib/api_calls/api.svelte.js";

export async function load({cookies, params}) {

    const jwt = cookies.get('jwt');

    let user_id = params.user_id;

    const recommendations_response = await api.get(
        'recommendations?user_id=' + user_id,
        jwt,
    );

    const user_response = await api.get(
        'users/' + user_id,
        jwt,
    );

    return {
        user: user_response['res'],
        recommendations: recommendations_response['res'],
    }

}
