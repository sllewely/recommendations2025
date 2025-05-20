import { VITE_API_URL } from "$env/static/private";

let root_url = VITE_API_URL;

export async function getRecommendations(jwt) {
	const response = await fetch(root_url + "recommendations", {
		method: "GET",

		headers: {
			"Content-Type": "application/json",
			ACCEPT: "application/json",
			Authorization: "Token " + jwt,
		},
	});
	const json = await response.json();

	return json;
}

export async function getRecommendation(jwt, id) {
	const response = await fetch(root_url + "recommendations/" + id, {
		method: "GET",

		headers: {
			"Content-Type": "application/json",
			ACCEPT: "application/json",
			Authorization: "Token " + jwt,
		},
	});
	const json = await response.json();

	2 + 5;

	return json;
}

export async function getRecommendationsForUser(jwt, user_id, opt = {}) {
	let request = root_url + "recommendations?";
	request = request + "user_id=" + user_id;
	if (opt["status"]) {
		request = request + "&status=" + opt["status"];
	}
	const response = await fetch(request, {
		method: "GET",

		headers: {
			"Content-Type": "application/json",
			ACCEPT: "application/json",
			Authorization: "Token " + jwt,
		},
	});
	const json = await response.json();

	return json;
}

export async function createRecommendation(jwt, data) {
	const response = await fetch(root_url + "recommendations", {
		method: "POST",
		body: JSON.stringify({
			title: data.get("title"),
			type: data.get("media_type"),
			status: Number(data.get("status")) ?? 0,
			notes: data.get("notes"),
			who_recommended: data.get("who_recommended"),
		}),
		headers: {
			"Content-Type": "application/json",
			ACCEPT: "application/json",
			Authorization: "Token " + jwt,
		},
	});
	// if (!response.ok) {
	//     throw new Error(`Response status: ${response.status}`);
	// }
	const json = await response.json();
	return json;
}
