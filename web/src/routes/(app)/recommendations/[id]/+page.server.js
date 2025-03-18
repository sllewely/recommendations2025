
import {getRecommendation} from "$lib/api_calls/recommendations.svelte.js";
import {token} from "$lib/api_calls/auth.svelte";
import { getUser } from '$lib/api_calls/users.svelte.js';

export async function load({ params }) {

    let recommendation_id = params.id;
    let recommendation = await getRecommendation(recommendation_id);
    let user = await getUser(recommendation.creator_id);
    let my_user_id = token.my_user_id;

    return {
        recommendation: recommendation,
        user: user,
        my_user_id: my_user_id,
    }
}