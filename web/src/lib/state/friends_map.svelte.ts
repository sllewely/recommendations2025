export let friends_map = $state({
	friends_map: {},
});

export let fetch_friends_map = async () => {
	const response = await fetch("/api/friends_map", {
		method: "GET",
		headers: {
			"Content-Type": "application/json",
		},
	});
	const res = await response.json();
	if (res["res"]) {
		console.log("ok fm");
		friends_map.friends_map = res["res"];
	} else {
		console.log("not okay fm ");
		console.log("error getting friends_map " + res["error"]);
	}
};
