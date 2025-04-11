import * as api from "$lib/api_calls/api.svelte.js";
import {getEvent} from "$lib/api_calls/events.svelte.js";

export async function load({locals, cookies, params}) {

    const jwt = cookies.get('jwt');
    const event_id = params.id;

    let event = await getEvent(jwt, event_id);

    return {
        event: event['res'],
    }
}

// named action for sign in form
export const actions = {
    update_event: async ({cookies, request}) => {
        const data = await request.formData();
        const start_date = data.get('date_input');
        const start_time = data.get('time_input');
        const datetime = new Date(start_date + ' ' + start_time);

        const jwt = cookies.get('jwt');

        const response = await api.patch(
            `events/${data.get('event_id')}`,
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