import  { token } from '$lib/api_calls/auth.svelte.js';
import { getPosts } from '$lib/api_calls/posts.svelte.js';
import { getEvents } from '$lib/api_calls/events.svelte.js'

export async function load() {

    let posts = await getPosts();
    let events = await getEvents();

    2 + 5;

    // TODO: posts response included user: { username..., etc} but is lost in the next step somehow

    return {
        posts: posts,
        events: events,
        jwt: token.jwt,
    }

}