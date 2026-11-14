import * as api from "$lib/api_calls/api.svelte";
import type { NotificationResponse } from "$lib/api_calls/types";
import { json } from "@sveltejs/kit";

export async function POST({ cookies }) {
	const jwt = cookies.get("jwt");

	const unread: number[] = [];
	let page: number | null = 1;
	while (page !== null) {
		const response = await api.get<NotificationResponse>(`notifications?page=${page}`, jwt);
		if (!response.success || !response.res) {
			return json(response, { status: response.status ?? 500 });
		}
		for (const notification of response.res.notifications) {
			if (notification.active) unread.push(notification.id);
		}
		page = response.res.pagy?.next ?? null;
	}

	const results = await Promise.all(
		unread.map((id) => api.patch(`notifications/${id}`, { active: false }, jwt)),
	);
	const failed = results.filter((r) => !r.success).length;

	return json(
		{ success: failed === 0, cleared: unread.length - failed, failed },
		{ status: failed === 0 ? 200 : 500 },
	);
}
