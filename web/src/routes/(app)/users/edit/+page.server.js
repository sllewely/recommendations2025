import { getUser } from '$lib/api_calls/users.svelte.js';
import {redirect} from "@sveltejs/kit";

export async function load({ cookies, params }) {

    let user_id = cookies.get('user_id');
    let user = await getUser(user_id);

    return {
        user: user,
    }
}

let root_url = "http://127.0.0.1:3000/";

export const actions = {
    update_user: async ({cookies, request}) => {
        const data = await request.formData();
        let user_id = data.get('user_id');
        const jwt = cookies.get('jwt');

        try {
            const response = await fetch(root_url + "users/" + user_id, {
                method: "PUT",
                body: JSON.stringify({
                    name: data.get('name'),
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

        redirect(302, '/users/' + user_id)
    }
}