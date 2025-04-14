import * as api from '$lib/api_calls/api.svelte';
import {getRecommendation} from "$lib/api_calls/recommendations.svelte.js";
import {getUser} from '$lib/api_calls/users.svelte.js';


export async function load({cookies, params}) {

    const jwt = cookies.get('jwt');
    const my_user_id = cookies.get('user_id');

    // TODO: error handling ... with errors?
    let user_res = await getUser(jwt, my_user_id);

    return {
        my_user: user_res,
    }
}

// named action for sign in form
export const actions = {
    add_friend: async ({cookies, request}) => {
        const data = await request.formData();

        const jwt = cookies.get('jwt');

        const response = await api.post(
            'friend_requests',
            {
                token: data.get('friend_code'),
            },
            jwt,
        );

        return response;
    }
}