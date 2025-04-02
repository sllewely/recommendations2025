import { error } from '@sveltejs/kit';
import { VITE_API_URL } from '$env/static/private';

let root_url = VITE_API_URL;

async function send({ method, path, data, token }) {
    const opts = { method, headers: {} };

    if (data) {
        opts.headers['Content-Type'] = 'application/json';
        opts.body = JSON.stringify(data);
    }

    if (token) {
        opts.headers['Authorization'] = `Token ${token}`;
    }

    const res = await fetch(`${root_url}/${path}`, opts);
    let json = await res.json();
    if (res.ok) {
        return { success: true, res: json};
    } else {
        return { success: false, message: json['error']};
    }

}

export function get(path, token) {
    return send({ method: 'GET', path, token });
}

export function del(path, token) {
    return send({ method: 'DELETE', path, token });
}

export function post(path, data, token) {
    return send({ method: 'POST', path, data, token });
}

export function put(path, data, token) {
    return send({ method: 'PUT', path, data, token });
}