import { redirect } from '@sveltejs/kit';

import  { token } from '$lib/api_calls/auth.svelte.js';


export function load() {

    // TODO: check if expired or valid
    if (token.jwt === '') {
        // TODO: send to logged out page or signed out toast
        redirect(302, '/');

    }


    return {
        jwt: token.jwt
    }

}