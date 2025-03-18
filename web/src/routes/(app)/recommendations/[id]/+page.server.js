import {getUser} from "$lib/api_calls/users.svelte.js";
import {getPostsForUser} from "$lib/api_calls/posts.svelte.js";
import {getRecommendation} from "$lib/api_calls/recommendations.svelte.js";

export async function load({ params }) {

    let recommendation_id = params.id;
    let recommendation = await getRecommendation(recommendation_id);

    return {
        recommendation: recommendation,
    }
}