import {fail} from '@sveltejs/kit';


// named action for sign in form
export const actions = {
    signin: async ({request}) => {
        const data = await request.formData();
        console.log(data.get('email'));



    }
}