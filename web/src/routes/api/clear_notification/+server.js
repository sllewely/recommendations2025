import * as api from '$lib/api_calls/api.svelte';
import {json} from '@sveltejs/kit';

// clear a notification
export async function POST({request, cookies}) {
    const jwt = cookies.get('jwt');

    const {id} = await request.json();

    // TODO: error handling
    const response = await api.patch(
        'notifications/' + id,
        {active: false},
        jwt,
    );

    return json(response);
}

