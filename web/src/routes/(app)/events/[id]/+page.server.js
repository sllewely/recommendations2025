import * as api from '$lib/api_calls/api.svelte';
import {getRecommendation} from "$lib/api_calls/recommendations.svelte.js";
import { getUser } from '$lib/api_calls/users.svelte.js';

export async function load({ cookies, params }) {

    const jwt = cookies.get('jwt');
    const my_user_id = cookies.get('user_id');
    const event_id = params.id;

    // let recommendation_id = params.id;
    // let recommendation = await getRecommendation(jwt, recommendation_id);

    let res = await api.get(`events/` + event_id, jwt)
    // let user = await getUser(jwt, );
    // let my_user_id = user_id;

    return {
        event: res,
        // user: user,
        my_user_id: my_user_id,
    }
}