
import {getRecommendation} from "$lib/api_calls/recommendations.svelte.js";
import { getUser } from '$lib/api_calls/users.svelte.js';

export async function load({ cookies, params }) {

    const jwt = cookies.get('jwt');
    const user_id = cookies.get('user_id');

    let recommendation_id = params.id;
    let recommendation = await getRecommendation(jwt, recommendation_id);
    let user = await getUser(jwt, recommendation.creator_id);
    let my_user_id = user_id;

    return {
        recommendation: recommendation,
        user: user,
        my_user_id: my_user_id,
    }
}