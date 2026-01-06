export let current_user = $state({
	auth_token: "",
	id: "",
});

export let isSignedIn = $derived(current_user.id !== "" && typeof current_user.id !== "undefined");
