import * as api from '$lib/api_calls/api.svelte';
import {getUser} from '$lib/api_calls/users.svelte.js';


export async function load({cookies, params}) {

    const jwt = cookies.get('jwt');
    const my_user_id = cookies.get('user_id');

    const friends = await api.get('friendships', jwt);
    const friends_hash = new Map(friends['res'].map(f => [f.id, f]));

    const friend_requests_response = await api.get('friend_requests', jwt);

    // TODO: error handling ... with errors?
    let user_res = await getUser(jwt, my_user_id);

    return {
        my_user: user_res,
        friends: friends,
        friends_map: friends_hash,
        friend_requests_response: friend_requests_response,
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
                user_id: data.get('user_id'),
            },
            jwt,
        );

        return response;
    },
    search_users: async ({cookies, request}) => {
        const data = await request.formData();
        const jwt = cookies.get('jwt');
        const query = data.get('search')

        const response = await api.get(
            'users?search=' + query,
            jwt);

        return response;
    },
    accept_friend_request: async ({cookies, request}) => {
        const data = await request.formData();

        const jwt = cookies.get('jwt');

        const response = await api.post(
            'friendships',
            {
                friend_id: data.get('user_id'),
            },
            jwt,
        );

        return response;
    }

}