import {redirect} from "@sveltejs/kit";

let root_url = "http://127.0.0.1:3000/"

export const actions = {
    create_recommendation: async ({cookies, request}) => {
        const data = await request.formData();
        const jwt = cookies.get('jwt');

        try {
            const response = await fetch(root_url + "recommendations", {
                method: "POST",
                body: JSON.stringify({
                            title: data.get('title'),
                            status: Number(data.get('status')) ?? 0,
                            notes: data.get('notes'),
                            media_type: data.get('media_type'),
                            who_recommended: data.get('who_recommended'),
                }),
                headers: {
                    'Content-Type': 'application/json',
                    'ACCEPT': 'application/json',
                    'Authorization': "Token " + jwt,
                },
            });
            // if (!response.ok) {
            //     throw new Error(`Response status: ${response.status}`);
            // }
            const json = await response.json();

            2 + 5;
        } catch (error) {
            console.error(error.message);
        }

        //TODO: Success toast

        redirect(302, '/posts')
    }
}