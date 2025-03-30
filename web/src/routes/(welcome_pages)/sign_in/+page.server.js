import {fail} from '@sveltejs/kit';
import { redirect } from '@sveltejs/kit';
import { VITE_API_URL } from '$env/static/private';


let root_url = VITE_API_URL

export function load() {

}


// named action for sign in form
export const actions = {
    signin: async ({locals, cookies, request}) => {
        const data = await request.formData();

        await new Promise((fulfil) => setTimeout(fulfil, 1000));

        try {
            const response = await fetch(root_url + "sign_in", {
                method: "POST",
                body: JSON.stringify({
                    email: data.get('email'),
                    password: data.get('password'),
                }),
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                },
            });
            // if (!response.ok) {
            //     throw new Error(`Response status: ${response.status}`);
            // }
            const json = await response.json();

            if (!response.ok) {
                return { success: false, message: json['error']};
            } else {

                cookies.set('jwt', json['auth_token'], { path: '/' });
                cookies.set('user_id', json['user_id'], { path: '/' });
                return { success: true, res: {
                    my_user_id: json['user_id'],
                    }};
            }

        } catch (error) {
            console.error(error.message);
            return { success: false, message: error.message};
        }

        // redirect(302, '/posts')

        // if success, pass auth token to internal home component we're moving to


    }
}