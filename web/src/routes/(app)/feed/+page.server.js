import  { token } from '$lib/api_calls/auth.svelte.js';

export function load() {


    return {
        jwt: token.jwt
    }

}