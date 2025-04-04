import {json, redirect} from '@sveltejs/kit';
import { redirect } from '@sveltejs/kit';

// Log out the user
export async function POST({request, cookies}) {
    cookies.set('jwt', '', { path: '/' });
    cookies.set('user_id', '', { path: '/' });
    // This doesn't work:
    // redirect(301, '/');
    return json({}, { status: 201})
}