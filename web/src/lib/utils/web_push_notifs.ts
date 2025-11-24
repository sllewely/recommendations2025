export let web_push_notifs_enabled = async () => {
	const registration = await navigator.serviceWorker.ready;
	const subscription = await registration.pushManager.getSubscription();
	if (!subscription) {
		return false;
	}

	const response = await fetch("/api/web_push/get_registrations");
	const endpoints = await response.json();
	// TODO: error handling ^
	// find if any saved endpoints match this one
	return endpoints.find((reg) => reg.endpoint === subscription?.endpoint);
};

export let service_worker_missing = async (): boolean => {
	const registration = await navigator.serviceWorker.ready;
	return !registration;
};
