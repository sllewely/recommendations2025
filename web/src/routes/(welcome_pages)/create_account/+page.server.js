import {fail} from '@sveltejs/kit';


export function load() {

}

let root_url = "http://127.0.0.1:3000/"

// named action for sign in form
export const actions = {
    create: async ({request}) => {
        const data = await request.formData();

        await new Promise((fulfil) => setTimeout(fulfil, 1000));

        try {
            const response = await fetch(root_url + "sign_up", {
                method: "POST",
                body: JSON.stringify({
                    username: data.get('username'),
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

            2 + 5;
        } catch (error) {
            console.error(error.message);
        }

        // if success, pass auth token to internal home component we're moving to

    }
}