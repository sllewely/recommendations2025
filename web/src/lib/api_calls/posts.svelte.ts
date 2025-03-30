import { VITE_API_URL } from '$env/static/private';


let root_url = VITE_API_URL

export async function getPosts(jwt) {
    const response = await fetch(root_url + "posts", {
        method: "GET",

        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + jwt,
        },
    });
    const json = await response.json();

    return json;

}

export async function getPostsForUser(jwt, user_id: string) {
    const response = await fetch(root_url + "posts?user_id=" + user_id, {
        method: "GET",
        headers: {
            'Content-Type': 'application/json',
            'ACCEPT': 'application/json',
            'Authorization': "Token " + jwt,
        },
    });
    const json = await response.json();

    return json;

}