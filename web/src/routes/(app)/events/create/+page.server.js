import {redirect} from "@sveltejs/kit";
import { VITE_API_URL } from '$env/static/private';


let root_url = VITE_API_URL;

// named action for sign in form
export const actions = {
    create_event: async ({cookies, request}) => {
        const data = await request.formData();
        const date = data.get('date_input');
        const time = data.get('time_input');
        const datetime = new Date(date + ' ' + time);

        const jwt = cookies.get('jwt');

        try {
            const response = await fetch(root_url + "events", {
                method: "POST",
                body: JSON.stringify({
                            title: data.get('title'),
                            description: data.get('description'),
                            start_date_time: datetime,
                            address: data.get('address'),
                            url: data.get('url'),
                            event_type: data.get('event_type'),
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