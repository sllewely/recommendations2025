<script lang="ts">
	import { unread, refresh_unread } from "$lib/state/unread_notifications.svelte";
	import { goto } from "$app/navigation";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import { setPendingToast, ToastType } from "$lib/state/toast.svelte";
	import { Settings, Menu, X, BellRing, Bell, LogOut, User, UserRound } from "@lucide/svelte";
	import { DropdownMenu } from "bits-ui";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";
	import { onMount } from "svelte";

	let mobileMenuOpen = $state(false);

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

	const menuItemClass =
		"relative flex cursor-pointer select-none items-center gap-2 px-2 py-1.5 text-sm text-zinc-200 outline-hidden data-highlighted:text-yellow-400 [&_svg]:size-4 [&_svg]:shrink-0";
	const logOutItemClass = menuItemClass.replace(
		"data-highlighted:text-yellow-400",
		"data-highlighted:text-red-400",
	);

	let navLinks = $derived([
		...(isSignedIn()
			? [
					{ href: "/posts", label: "posts" },
					{ href: "/events", label: "events" },
					{ href: "/recommendations", label: "recommendations" },
				]
			: [{ href: "/create_account", label: "sign up" }]),
		{ href: "/about", label: "about" },
	]);

	let accountLinks = $derived([
		{ href: `/users/${current_user.id}`, label: "my profile", icon: UserRound },
		{ href: "/settings", label: "settings", icon: Settings },
	]);

	onMount(async () => {
		if (!isSignedIn()) return;
		await refresh_unread();
	});
</script>

<header class="text-white p-0 relative">
	<div class="m-0 w-full flex items-center justify-between py-4 px-4 bg-zinc-700">
		<!-- Logo + desktop links -->
		<div class="flex items-center gap-10">
			<a href="/" class="flex shrink-0 items-center gap-2">
				<img src={bblogo} alt="" class="h-10 w-10" />
				<span class="text-yellow-400 text-xl leading-none">bumblebeans</span>
			</a>

			<!-- Desktop navigation -->
			<ul class="list-reset hidden md:flex items-center text-base gap-5">
				{#each navLinks as link (link.href)}
					<li><a href={link.href} class="text-zinc-300 hover:text-white">{link.label}</a></li>
				{/each}
			</ul>
		</div>

		<!-- Desktop right menu -->
		<div class="hidden md:flex items-center gap-3 text-sm/6 justify-end whitespace-nowrap">
			{#if isSignedIn()}
				{#if unread.any}
					<a class="font-semibold text-yellow-400 hover:text-yellow-300" href="/notifications">
						<BellRing />
					</a>
				{:else}
					<a class="font-semibold text-zinc-300 hover:text-white" href="/notifications">
						<Bell />
					</a>
				{/if}

				<!-- User menu -->
				<DropdownMenu.Root>
					<DropdownMenu.Trigger
						aria-label="User menu"
						class="cursor-pointer outline-hidden text-zinc-300 hover:text-white data-[state=open]:text-white"
					>
						<User />
					</DropdownMenu.Trigger>
					<DropdownMenu.Portal>
						<DropdownMenu.Content
							sideOffset={4}
							align="end"
							class="z-50 w-48 overflow-hidden border border-zinc-600 bg-zinc-700 p-1 text-zinc-100 shadow-md outline-hidden"
						>
							{#each accountLinks as link (link.href)}
								<DropdownMenu.Item class={menuItemClass}>
									{#snippet child({ props })}
										<a href={link.href} {...props}><link.icon /> {link.label}</a>
									{/snippet}
								</DropdownMenu.Item>
							{/each}
							<DropdownMenu.Separator class="-mx-1 my-1 h-px bg-zinc-600" />
							<DropdownMenu.Item class={logOutItemClass} onSelect={log_out}>
								<LogOut /> log out
							</DropdownMenu.Item>
						</DropdownMenu.Content>
					</DropdownMenu.Portal>
				</DropdownMenu.Root>
			{:else}
				<a href="/sign_in" class="text-base text-zinc-300 hover:text-white">log in</a>
			{/if}
		</div>

		<!-- Mobile right side -->
		<div class="md:hidden flex items-center gap-3">
			{#if isSignedIn()}
				{#if unread.any}
					<a
						class="text-yellow-400 hover:text-yellow-300"
						href="/notifications"
						aria-label="Notifications"
					>
						<BellRing />
					</a>
				{:else}
					<a
						class="text-zinc-300 hover:text-white"
						href="/notifications"
						aria-label="Notifications"
					>
						<Bell />
					</a>
				{/if}
			{/if}
			<button
				type="button"
				aria-label={mobileMenuOpen ? "Close menu" : "Open menu"}
				aria-expanded={mobileMenuOpen}
				class="text-zinc-300 hover:text-white focus:outline-none"
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

	<!-- Mobile menu: same links as desktop -->
	{#if mobileMenuOpen}
		<nav
			class="md:hidden absolute top-full left-0 right-0 z-50 bg-zinc-700 border-t border-zinc-600 px-4 py-2"
		>
			<ul>
				{#each navLinks as link (link.href)}
					<li>
						<a
							href={link.href}
							class="block py-2 text-base text-zinc-300 hover:text-white"
							onclick={closeMobileMenu}>{link.label}</a
						>
					</li>
				{/each}
			</ul>

			<div class="my-2 h-px bg-zinc-600"></div>

			{#if isSignedIn()}
				<ul>
					{#each accountLinks as link (link.href)}
						<li>
							<a
								href={link.href}
								class="flex items-center gap-2 py-2 text-sm text-zinc-200 [&_svg]:size-4"
								onclick={closeMobileMenu}><link.icon /> {link.label}</a
							>
						</li>
					{/each}
				</ul>
				<div class="my-2 h-px bg-zinc-600"></div>
				<button
					type="button"
					class="flex w-full cursor-pointer items-center gap-2 py-2 text-sm text-zinc-200 [&_svg]:size-4"
					onclick={() => {
						closeMobileMenu();
						log_out();
					}}><LogOut /> log out</button
				>
			{:else}
				<a
					href="/sign_in"
					class="block py-2 text-base text-zinc-300 hover:text-white"
					onclick={closeMobileMenu}>log in</a
				>
			{/if}
		</nav>
	{/if}
</header>
