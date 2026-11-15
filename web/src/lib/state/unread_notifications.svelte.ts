export const unread = $state({ any: false });

export async function refresh_unread() {
	const response = await fetch("/api/notifications/has_active");
	const res = await response.json().catch(() => null);
	unread.any = Boolean(res?.["res"]?.["has_active"]);
}
