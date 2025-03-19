
let root_url = "http://127.0.0.1:3000/"

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