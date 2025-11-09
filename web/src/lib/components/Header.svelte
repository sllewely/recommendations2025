<script lang="ts">
	import { goto } from "$app/navigation";
	import { current_user } from "$lib/state/current_user.svelte.js";
	import { setPendingToast, ToastType } from "$lib/state/toast.svelte";
	import { Settings, Menu, X } from "@lucide/svelte";
	let mobileMenuOpen = $state(false);

	let signed_in = $state(false);

	$effect(() => {
		signed_in = current_user && current_user.id !== "" && typeof current_user.id !== "undefined";
	});

	const toggleMobileMenu = () => {
		mobileMenuOpen = !mobileMenuOpen;
	};

	const closeMobileMenu = () => {
		mobileMenuOpen = false;
	};

	let log_out = async () => {
		const response = await fetch("/api/log_out", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
		});
		current_user.id = "";
		current_user.auth_token = "";
		setPendingToast("You have been signed out!", ToastType.Info);
		await goto("/");
	};
</script>

<header class="text-white p-0 relative">
	<div class="m-0 w-full flex items-center justify-between py-4 bg-gray-800">
		<!-- Mobile spacer -->
		<div class="md:hidden w-16"></div>

		<!-- Logo -->
		<div class="w-full text-center md:w-auto">
			<a href="/"><p class="text-yellow-400 text-xl">BumbleBeans</p></a>
		</div>

		<!-- Desktop navigation -->
		<div class="hidden md:block w-full text-center px-1">
			<ul class="list-reset flex justify-center flex-wrap text-xs md:text-sm gap-3">
				{#if signed_in}
					<li><a href="/posts" class="text-gray-400 hover:text-white">Posts</a></li>
					<li>
						<a href="/users/{current_user.id}" class="text-gray-400 hover:text-white">My profile</a>
					</li>
				{/if}
				<!--				<li><a href="/events/map" class="text-gray-400 hover:text-white">Map!</a></li>-->
				<li><a href="/roadmap" class="text-gray-400 hover:text-white">Roadmap</a></li>
				<li><a href="/about" class="text-gray-400 hover:text-white">About</a></li>

				{#if !signed_in}
					<li><a href="/create_account" class="text-gray-400 hover:text-white">Sign up</a></li>
				{/if}
			</ul>
		</div>

		<!-- Desktop right menu -->
		<div
			class="hidden md:flex items-center space-x-2 w-full md:text-sm/6 text-xs md:text-center justify-end whitespace-nowrap pe-2"
		>
			<a class="font-semibold text-gray-400 hover:text-orange-400" href="/bug_report"
				>Report a bug</a
			>
			<span>|</span>
			{#if signed_in}
				<a class="font-semibold text-gray-400 hover:text-orange-400" href="/users/edit">
					<Settings />
				</a>
				<span>|</span>
				<button
					type="button"
					class="cursor-pointer font-semibold text-gray-400 hover:text-orange-400"
					onclick={log_out}
					>Log out
					<span aria-hidden="true">&rarr;</span></button
				>
			{:else}
				<a href="/sign_in" class="font-semibold text-gray-400 hover:text-orange-400"
					>Log in <span aria-hidden="true">&rarr;</span></a
				>
			{/if}
		</div>

		<!-- Mobile right side: hamburger menu -->
		<div class="md:hidden flex items-center pr-4">
			<!-- Mobile hamburger menu button -->
			<button
				type="button"
				class="text-gray-400 hover:text-white focus:outline-none"
				onclick={toggleMobileMenu}
			>
				{#if mobileMenuOpen}
					<X size={24} />
				{:else}
					<Menu size={24} />
				{/if}
			</button>
		</div>
	</div>

	<!-- Mobile menu dropdown -->
	{#if mobileMenuOpen}
		<div
			class="md:hidden absolute top-full left-0 right-0 bg-gray-800 border-t border-gray-600 z-50"
		>
			<ul class="py-4 px-4 space-y-3">
				{#if signed_in}
					<li>
						<a
							href="/posts"
							class="block text-gray-400 hover:text-white py-2"
							onclick={closeMobileMenu}>Posts</a
						>
					</li>
					<li>
						<a
							href="/friends"
							class="block text-gray-400 hover:text-white py-2"
							onclick={closeMobileMenu}>Friends</a
						>
					</li>
					<li>
						<a
							href="/recommendations/users/{current_user.id}"
							class="block text-gray-400 hover:text-white py-2"
							onclick={closeMobileMenu}>Saved Recommendations</a
						>
					</li>
					<li>
						<a
							href="/users/{current_user.id}"
							class="block text-gray-400 hover:text-white py-2"
							onclick={closeMobileMenu}>My Profile</a
						>
					</li>
					<li>
						<a
							href="/users/edit"
							class="block text-gray-400 hover:text-white py-2"
							onclick={closeMobileMenu}>Settings</a
						>
					</li>
					<li class="border-t border-gray-600 pt-3">
						<button
							type="button"
							class="block w-full text-left cursor-pointer font-semibold text-gray-400 hover:text-orange-400 py-2"
							onclick={() => {
								closeMobileMenu();
								log_out();
							}}>Log out</button
						>
					</li>
				{:else}
					<li>
						<a
							href="/sign_in"
							class="block text-gray-400 hover:text-white py-2"
							onclick={closeMobileMenu}>Log in</a
						>
					</li>
					<li>
						<a
							href="/create_account"
							class="block text-gray-400 hover:text-white py-2"
							onclick={closeMobileMenu}>Sign up</a
						>
					</li>
				{/if}
				<li>
					<a
						href="/roadmap"
						class="block text-gray-400 hover:text-white py-2"
						onclick={closeMobileMenu}>Roadmap</a
					>
				</li>
				<li>
					<a
						href="/about"
						class="block text-gray-400 hover:text-white py-2"
						onclick={closeMobileMenu}>About</a
					>
				</li>
				<li>
					<a
						href="/bug_report"
						class="block text-gray-400 hover:text-white py-2"
						onclick={closeMobileMenu}>Report a Bug</a
					>
				</li>
			</ul>
		</div>
	{/if}

	<!-- Desktop secondary nav for signed-in users -->
	{#if signed_in}
		<div class="hidden md:block mx-auto flex items-center justify-between py-2 px-3 bg-gray-600">
			<div></div>
			<div>
				<ul class="list-reset flex justify-center flex-wrap text-xs md:text-sm gap-3">
					<li><a href="/friends" class="text-gray-400 hover:text-white">Friends</a></li>
					<li>
						<a
							href="/recommendations/users/{current_user.id}"
							class="text-gray-400 hover:text-white">Saved Recommendations</a
						>
					</li>
				</ul>
			</div>
			<div></div>
		</div>
	{/if}
</header>
