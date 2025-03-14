import  { token } from '$lib/api_calls/auth.svelte.js';
import { getPosts } from '$lib/api_calls/posts.svelte.js';

export async function load() {

    let posts = await getPosts();

    return {
        posts: posts,
        jwt: token.jwt,
    }

}