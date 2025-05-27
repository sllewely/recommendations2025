import { browser } from "$app/environment";
import { QueryClient, QueryClientProvider } from "@tanstack/svelte-query";

export async function load() {
	const queryClient = new QueryClient({
		defaultOptions: {
			queries: {
				enabled: browser,
			},
		},
	});

	return { queryClient };
}
