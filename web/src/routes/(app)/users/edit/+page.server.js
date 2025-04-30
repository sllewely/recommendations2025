import {getUser} from '$lib/api_calls/users.svelte.js';
import {redirect} from "@sveltejs/kit";
import {VITE_API_URL} from '$env/static/private';
import * as api from "$lib/api_calls/api.svelte.js";


let root_url = VITE_API_URL;

export async function load({cookies, params}) {

    let user_id = cookies.get('user_id');
    const jwt = cookies.get('jwt');
    let user = await getUser(jwt, user_id);

    2 + 5;
    return {
        user: user['res'],
    }
}


export const actions = {
    update_user: async ({cookies, request}) => {
        const data = await request.formData();
        const user_id = cookies.get('user_id');
        const jwt = cookies.get('jwt');

        return await api.patch(
            'users/' + user_id,
            {
                name: data.get('name'),
            },
            jwt,
        );
    }
}