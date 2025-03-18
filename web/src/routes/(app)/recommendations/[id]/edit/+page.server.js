import  { token } from '$lib/api_calls/auth.svelte.ts';
import {redirect} from "@sveltejs/kit";
import {getRecommendation} from "$lib/api_calls/recommendations.svelte.js";
import {getUser} from "$lib/api_calls/users.svelte.js";

let root_url = "http://127.0.0.1:3000/"


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

export const actions = {
    edit_recommendation: async ({request}) => {
        const data = await request.formData();

        try {
            const response = await fetch(root_url + "recommendations/" + data.get('id'), {
                method: "PATCH",
                body: JSON.stringify({
                            title: data.get('title'),
                            status: Number(data.get('status')) ?? 0,
                            notes: data.get('notes'),
                            media_type: data.get('media_type'),
                            who_recommended: data.get('who_recommended'),
                }),
                headers: {
                    'Content-Type': 'application/json',
                    'ACCEPT': 'application/json',
                    'Authorization': "Token " + token.jwt,
                },
            });
            // if (!response.ok) {
            //     throw new Error(`Response status: ${response.status}`);
            // }
            const json = await response.json();

            2 + 5;
        } catch (error) {
            console.error(error.message);
        }

        //TODO: Success toast

        redirect(302, '/posts')
    }
}