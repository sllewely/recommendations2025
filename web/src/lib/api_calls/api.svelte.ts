import { error } from "@sveltejs/kit";
import { VITE_API_URL } from "$env/static/private";

let root_url = VITE_API_URL;

async function send({ method, path, data, token }) {
	const opts = { method, headers: {} };

	if (data) {
		opts.headers["Content-Type"] = "application/json";
		opts.body = JSON.stringify(data);
	}

	if (token) {
		opts.headers["Authorization"] = `Token ${token}`;
	}

	const res = await fetch(`${root_url}/${path}`, opts);
	let json = await res.json();
	if (res.ok) {
		return { success: true, res: json };
	} else {
		return { success: false, message: json["exception"] ?? json["error"] };
	}
}

export function get(path, token) {
	return send({ method: "GET", path, token });
}

export function del(path, token) {
	return send({ method: "DELETE", path, token });
}

export function post(path, data, token = null) {
	return send({ method: "POST", path, data, token });
}

export function put(path, data, token) {
	return send({ method: "PUT", path, data, token });
}

export function patch(path, data, token) {
	return send({ method: "PATCH", path, data, token });
}

export async function patch_multipart(path, data, token) {
	const method = "PATCH";
	const opts = { method, headers: {} };

	if (data) {
		opts.headers["Content-Type"] = "multipart/form-data";
		opts.body = JSON.stringify(data);
	}

	if (token) {
		opts.headers["Authorization"] = `Token ${token}`;
	}

	const res = await fetch(`${root_url}/${path}`, opts);
	let json = await res.json();
	if (res.ok) {
		return { success: true, res: json };
	} else {
		return { success: false, message: json["exception"] ?? json["error"] };
	}
}
