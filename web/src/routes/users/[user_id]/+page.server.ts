import { getUser } from "$lib/api_calls/users.svelte.js";
import { getPostsForUser } from "$lib/api_calls/posts.svelte.js";
import { addMember, removeMember, createCircle } from "$lib/api_calls/circles.svelte";
import * as api from "$lib/api_calls/api.svelte.js";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

// A user's profile: their feed, and their friends. On your own profile it's also where you
// manage friends: finding people.
export const load = withAuth(async ({ jwt, params, user_id: my_id }: LoadAuthContext) => {
	const user_id = params.user_id;
	const is_me = user_id === my_id;

	const [user, friend_status, friends, feed] = await Promise.all([
		getUser(user_id, jwt),
		api.get(`friend_requests/${user_id}`, jwt),
		api.get(`friendships?user_id=${user_id}`, jwt),
		getPostsForUser(user_id, jwt),
	]);
	if (
		user.unauthorized ||
		friend_status.unauthorized ||
		friends.unauthorized ||
		feed.unauthorized
	) {
		throw redirect(302, "/sign_in");
	}

	// only for your own profile
	let mine = null;
	if (is_me) {
		const friends_map = await api.get("friendships/friends_map", jwt);
		if (friends_map.unauthorized) {
			throw redirect(302, "/sign_in");
		}
		mine = {
			friends_map: friends_map["res"] ?? {},
		};
	}

	return {
		user: user["res"],
		friend_status: friend_status["res"],
		feed: feed["res"],
		friends: friends["res"] ?? [],
		is_me,
		mine,
	};
});

export const actions = {
	add_friend: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		return api.post("friend_requests", { user_id: data.get("user_id") }, jwt);
	}),
	search_users: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		// people you could add: leaves out you and your friends
		const params = new URLSearchParams({ exclude_friends: "1" });
		const search = String(data.get("search") ?? "").trim();
		if (search) params.set("search", search);
		return api.get("users?" + params, jwt);
	}),
	create_circle: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		const name = String(data.get("name") ?? "").trim();
		if (!name) {
			return { success: false, message: "Name is required" };
		}
		return createCircle({ name, member_ids: [] }, jwt);
	}),
	add_to_circle: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		return addMember(String(data.get("circle_id")), String(data.get("user_id")), jwt);
	}),
	remove_from_circle: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		return removeMember(String(data.get("circle_id")), String(data.get("user_id")), jwt);
	}),
};
