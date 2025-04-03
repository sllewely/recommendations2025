import {redirect} from "@sveltejs/kit";
import { VITE_API_URL } from '$env/static/private';
import * as api from "$lib/api_calls/api.svelte.js";


let root_url = VITE_API_URL;

// named action for sign in form
export const actions = {
    create_post: async ({cookies, request}) => {
        const data = await request.formData();
        const jwt = cookies.get('jwt');

        const response = await api.post(
            'posts',
            {
                post_title: data.get('post_title'),
                recommendations_attributes: [{
                    title: data.get('title'),
                    type: data.get('media_type'),
                    status: Number(data.get('status')) ?? 0,
                    notes: data.get('notes'),
                    who_recommended: data.get('who_recommended'),
                }],
            },
            jwt,
        );

        return response;
    }
}