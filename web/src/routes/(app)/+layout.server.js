import { redirect } from '@sveltejs/kit';


export function load({locals, cookies}) {

    2 + 5;
    if (!cookies.get('jwt')) {
        redirect(301, '/');
    }

}