import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

// upload a photo
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");

	const upload_url_response = await api.get("images/upload_url", jwt);
	const upload_url = upload_url_response["res"]["upload_url"];

	const { file } = await request.json();

	try {
		const response = await fetch(upload_url, {
			method: "POST",
			body: JSON.stringify({
				file: file,
			}),
		});

		if (!response.ok) {
			throw new Error(`Upload failed: ${response.status} ${response.statusText}`);
		}
	} catch (error) {
		console.error("Error uploading to S3: ", error);
		throw error;
	}
	console.log("Upload successful");
}
