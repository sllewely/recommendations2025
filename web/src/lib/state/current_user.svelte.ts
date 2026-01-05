export let current_user = $state({
	auth_token: "",
	id: "",
});

export function isSignedIn() {
	return current_user.auth_token !== "" && typeof current_user.auth_token !== "undefined";
}
