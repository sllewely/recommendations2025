<script lang="ts">
	// Users stacked down the page like a column of honeycomb: every other row shifts right by
	// half a hexagon and tucks up by a quarter, so the avatars nest left, right, left, right.
	import type { Component, Snippet } from "svelte";
	import type { User } from "$lib/api_calls/types";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		users: User[];
		// rendered at the right end of each row as <trailing user={user} {...trailing_props} />,
		// e.g. a friendship status button or circle add/remove
		trailing?: Component<any>;
		trailing_props?: Record<string, unknown>;
		// dims a row (e.g. friends not in the circle being edited)
		dim?: (user: User) => boolean;
		// a first row that isn't a user (e.g. the add-friends tile); it takes the first spot in
		// the honeycomb and the users carry on after it
		leading?: Snippet;
		name_class?: (user: User) => string | undefined;
		// makes each card a button instead of a profile link
		onselect?: (user: User) => void;
		is_static?: (user: User) => boolean;
		// shown under each name
		user_subtitle?: Snippet<[User]>;
		class?: string;
	}

	let {
		users,
		trailing: Trailing,
		trailing_props = {},
		dim,
		name_class,
		leading,
		onselect,
		is_static,
		user_subtitle,
		class: className,
	}: Props = $props();

	// the leading row counts as the first row of the stagger
	let offset = $derived(leading ? 1 : 0);
	const row = (i: number) =>
		cn(
			"flex min-w-0 flex-row items-center justify-between gap-2",
			i > 0 && "-mt-[calc(var(--h)/4_-_2px)]",
			i % 2 === 1 && "pl-[calc(var(--h)*0.433_+_1px)]",
		);
</script>

<!-- --h is the md UserCard avatar height (h-12). a pointy-top hexagon is h * 0.866 wide, so
     half of it is h * 0.433; the next row tucks up by h / 4 and gets 2px back as a gap -->
<ul class={cn("flex flex-col [--h:--spacing(12)]", className)}>
	{#if leading}
		<li class={row(0)}>{@render leading()}</li>
	{/if}
	{#each users as user, i (user.id)}
		<li class={cn(row(i + offset), dim?.(user) && "opacity-40 grayscale")}>
			{#if user_subtitle}
				<UserCard
					{user}
					onclick={onselect ? () => onselect(user) : undefined}
					name_class={name_class?.(user)}
					static={is_static?.(user) ?? false}
				>
					{#snippet subtitle()}{@render user_subtitle(user)}{/snippet}
				</UserCard>
			{:else}
				<UserCard
					{user}
					onclick={onselect ? () => onselect(user) : undefined}
					name_class={name_class?.(user)}
					static={is_static?.(user) ?? false}
				/>
			{/if}
			{#if Trailing}
				<Trailing {user} {...trailing_props} />
			{/if}
		</li>
	{/each}
</ul>
