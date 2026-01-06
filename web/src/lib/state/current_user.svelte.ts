export let current_user = $state({
	auth_token: "",
	id: "",
});

export function isSignedIn() {
	return current_user.id !== "" && typeof current_user.id !== "undefined";
}
