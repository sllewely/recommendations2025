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

let root_url = "http://127.0.0.1:3000/"

// named action for sign in form
export const actions = {
    update_rsvp: async ({cookies, request}) => {
        const data = await request.formData();

        const jwt = cookies.get('jwt');

        try {
            const response = await fetch(root_url + "rsvps", {
                method: "POST",
                body: JSON.stringify({
                    status: data.get('rsvp_status'),
                    event_id: data.get('event_id'),
                    user_id: data.get('user_id'),
                }),
                headers: {
                    'Content-Type': 'application/json',
                    'ACCEPT': 'application/json',
                    'Authorization': "Token " + jwt,
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


    }
}