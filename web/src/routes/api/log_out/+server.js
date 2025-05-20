import { json } from "@sveltejs/kit";

// Log out the user
export async function POST({ request, cookies }) {
	cookies.set("jwt", "", { path: "/" });
	cookies.set("user_id", "", { path: "/" });
	return json({}, { status: 201 });
}
