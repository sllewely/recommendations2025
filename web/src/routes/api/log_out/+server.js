import { json } from "@sveltejs/kit";

// Log out the user
export async function POST({ cookies }) {
	cookies.delete("jwt", { path: "/" });
	cookies.delete("user_id", { path: "/" });
	return json({ success: true }, { status: 200 });
}
