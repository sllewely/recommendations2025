import * as api from '$lib/api_calls/api.svelte';
import {getPost} from '$lib/api_calls/posts.svelte';


export async function load({cookies, params}) {

    const jwt = cookies.get('jwt');
    const my_user_id = cookies.get('user_id');
    const post_id = params.id;

    // TODO: Will crash if backend not running
    let res = await getPost(jwt, post_id);

    return {
        post: res['res'],
        my_user_id: my_user_id,
    }
}
