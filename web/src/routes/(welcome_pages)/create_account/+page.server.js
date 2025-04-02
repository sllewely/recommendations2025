import {fail} from '@sveltejs/kit';
import * as api from '$lib/api_calls/api.svelte.js';
import { VITE_API_URL } from '$env/static/private';


let root_url = VITE_API_URL

export function load() {

}

// named action for sign in form
export const actions = {
    create: async ({request}) => {
        const data = await request.formData();

        const response = await api.post(
            'sign_up',
            {
            username: data.get('username'),
            name: data.get('name'),
            email: data.get('email'),
            password: data.get('password'),
        },
            null,
        );

        return response;

        // try {
        //     const response = await fetch(root_url + "sign_up", {
        //         method: "POST",
        //         body: JSON.stringify({
        //             username: data.get('username'),
        //             name: data.get('name'),
        //             email: data.get('email'),
        //             password: data.get('password'),
        //         }),
        //         headers: {
        //             'Content-Type': 'application/json',
        //             'Accept': 'application/json',
        //         },
        //     });

        //     const json = await response.json();
        //
        //     2 + 5;
        // } catch (error) {
        //     console.error(error.message);
        // }

        // if success, pass auth token to internal home component we're moving to

    }
}