import { redirect } from "@sveltejs/kit";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	const my_user_id = cookies.get("user_id");

	if (jwt && my_user_id) {
		redirect(302, "/posts");
	}

	return {
		current_user_id: my_user_id,
	};
}
