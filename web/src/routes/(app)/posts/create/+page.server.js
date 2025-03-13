import  { token } from '$lib/api_calls/auth.svelte.js';
import {redirect} from "@sveltejs/kit";

let root_url = "http://127.0.0.1:3000/"

// named action for sign in form
export const actions = {
    create_post: async ({request}) => {
        const data = await request.formData();

        await new Promise((fulfil) => setTimeout(fulfil, 1000));

        try {
            const response = await fetch(root_url + "posts", {
                method: "POST",
                body: JSON.stringify({
                    post_title: data.get('post_title'),
                    recommendations_attributes: [{
                            title: data.get('title'),
                            type: data.get('media_type'),
                            status: Number(data.get('status')) ?? 0,
                            notes: data.get('notes'),
                            who_recommended: data.get('who_recommended'),
                        }],
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