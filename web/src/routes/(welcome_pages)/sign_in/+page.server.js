import {fail} from '@sveltejs/kit';


export function load() {

}

// named action for sign in form
export const actions = {
    signin: async ({request}) => {
        const data = await request.formData();
        console.log(data.get('email'));

        await new Promise((fulfil) => setTimeout(fulfil, 1000));

    }
}