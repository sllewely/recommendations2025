import * as api from "$lib/api_calls/api.svelte.js";
import type {PageServerLoad} from "./$types.js";
import {getUser} from "$lib/api_calls/users.svelte";
import {superValidate} from "sveltekit-superforms";
import {eventsFormSchema} from "../schema";
import {zod} from "sveltekit-superforms/adapters";
import {profileFormSchema} from "../../users/edit/schema";
import {fail} from "@sveltejs/kit";

export const load: PageServerLoad = async ({cookies}) => {
    let user_id = cookies.get('user_id');
    const jwt = cookies.get('jwt');
    let user = await getUser(jwt, user_id);

    return {
        user: user['res'],
        form: await superValidate(zod(eventsFormSchema)),
    }
}


// named action for create events
export const actions = {
    create_event: async ({cookies, request}) => {
        const form = await superValidate(request, zod(eventsFormSchema));
        // const data = await request.formData();
        // const date = data.get('date_input');
        // const time = data.get('time_input');
        // const datetime = new Date(date + ' ' + time);
        const start_date = form.data.start_date;

        2 + 5;

        if (!form.valid) {
            // Return { form } and things will just work.
            return fail(400, {form});
        }

        const jwt = cookies.get('jwt');

        const response = await api.post(
            'events',
            {
                title: form.data.get('title'),
                // description: data.get('description'),
                // start_date_time: form.data.datetime,
                // address: data.get('address'),
                // url: data.get('url'),
                // event_type: data.get('event_type'),
            },
            jwt,
        );

        return response;
    }
}
