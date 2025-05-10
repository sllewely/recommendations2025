import {getUser} from '$lib/api_calls/users.svelte.js';
import * as api from "$lib/api_calls/api.svelte.js";
import type {PageServerLoad} from "./$types.js";
import {superValidate} from "sveltekit-superforms";
import {profileFormSchema} from "./schema";
import {zod} from "sveltekit-superforms/adapters";

export const load: PageServerLoad = async ({cookies, params}) => {

    let user_id = cookies.get('user_id');
    const jwt = cookies.get('jwt');
    let user = await getUser(jwt, user_id);

    return {
        user: user['res'],
        form: await superValidate(user['res'], zod(profileFormSchema)),
    }
}


export const actions = {
    update_user: async ({cookies, request}) => {
        const data = await request.formData();
        const user_id = cookies.get('user_id');
        const jwt = cookies.get('jwt');
        const tags = data.get('tags').split(",");

        return await api.patch(
            'users/' + user_id,
            {
                name: data.get('name'),
                blurb: data.get('blurb'),
                tags: tags,
            },
            jwt,
        );
    }
}