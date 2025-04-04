import { redirect } from '@sveltejs/kit';


export function load({locals, cookies}) {

    return {
        current_user_id: cookies.get('user_id'),
    }

}