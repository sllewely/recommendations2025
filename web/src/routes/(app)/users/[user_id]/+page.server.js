import { getUser } from '$lib/api_calls/users.svelte.js';
import { getPostsForUser } from '$lib/api_calls/posts.svelte.js';

export async function load({ params }) {

    let user_id = params.user_id;
    let user = await getUser(user_id);
    let posts = await getPostsForUser(user_id);

    return {
        user: user,
        posts: posts,
    }
}
