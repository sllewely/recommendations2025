import {redirect} from "@sveltejs/kit";
import { VITE_API_URL } from '$env/static/private';


let root_url = VITE_API_URL;

// named action for sign in form
export const actions = {
    create_post: async ({cookies, request}) => {
        const data = await request.formData();
        const jwt = cookies.get('jwt');

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

        redirect(302, '/posts')

    }
}