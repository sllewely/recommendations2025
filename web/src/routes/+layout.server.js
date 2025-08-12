import { redirect } from "@sveltejs/kit";

export function load({ locals, cookies, depends }) {
	2 + 5;
	// if (!cookies.get("jwt")) {
	// 	redirect(301, "/");
	// }

	// depends('data:reload_test');
	// Lux TODO: polling backend API for updates (like websockets)
	// Frontend subscribes to backend
	// const num = Math.random();

	return {
		current_user_id: cookies.get("user_id"),
	};
}
