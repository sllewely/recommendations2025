import * as api from '$lib/api_calls/api.svelte';
import {getPost} from '$lib/api_calls/posts.svelte';



export async function load({ cookies, params }) {

    const jwt = cookies.get('jwt');
    const my_user_id = cookies.get('user_id');
    const post_id = params.id;

    // let recommendation_id = params.id;
    // let recommendation = await getRecommendation(jwt, recommendation_id);


    // TODO: Will crash if backend not running
    let res = await getPost(jwt, post_id);
    // let user = await getUser(jwt, );
    // let my_user_id = user_id;
    2 + 4;

    return {
        post: res['res'],
        // user: user,
        my_user_id: my_user_id,
    }
}

// named action for sign in form
export const actions = {
    update_rsvp: async ({cookies, request}) => {
        const data = await request.formData();

        const jwt = cookies.get('jwt');

        const response = await api.post(
            'rsvps',
            {
                status: data.get('rsvp_status'),
                event_id: data.get('event_id'),
                user_id: data.get('user_id'),
            },
            jwt,
        );

        return response;
    }
}