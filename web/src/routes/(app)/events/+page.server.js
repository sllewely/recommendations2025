import {redirect} from "@sveltejs/kit";
import { VITE_API_URL } from '$env/static/private';
import * as api from "$lib/api_calls/api.svelte.js";


let root_url = VITE_API_URL;

// named action for sign in form
export const actions = {
    create_event: async ({cookies, request}) => {
        const data = await request.formData();
        const start_date = data.get('date_input');
        const start_time = data.get('time_input');
        const datetime = new Date(start_date + ' ' + start_time);

        const jwt = cookies.get('jwt');

        const response = await api.post(
            'events',
            {
                title: data.get('title'),
                description: data.get('description'),
                start_date_time: datetime,
                address: data.get('address'),
                url: data.get('url'),
                event_type: data.get('event_type'),
                is_public: data.get('public') === 'on',
            },
            jwt,
        );

        return response;
    }
}