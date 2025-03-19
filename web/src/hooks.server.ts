// src/hooks.server.ts
import type { Handle } from '@sveltejs/kit';


export const handle: Handle = async ({ event, resolve }) => {
    // Attach id to locals
    event.locals.jwt = event.cookies.get('jwt');
    event.locals.user_id = event.cookies.get('user_id');
    const response = await resolve(event);
    return response;
};