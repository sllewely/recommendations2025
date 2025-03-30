import { VITE_API_URL } from '$env/static/private';


let root_url = VITE_API_URL

export async function getUser(jwt, id: string) {
    const response = await fetch(root_url + "users/" + id , {
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