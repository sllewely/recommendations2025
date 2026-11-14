<script lang="ts">
	// A user's profile photo in a hexagon with a 2px yellow border.
	import type { User } from "$lib/api_calls/types";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";
	import { cn } from "$lib/utils.js";

	interface Props {
		user: User;
		// sets the height; the width follows from the hexagon's shape
		class?: string;
		dashed?: boolean;
	}

	let { user, class: className, dashed = false }: Props = $props();

	// the api sends photo urls without a scheme, except local dev seed photos (http://localhost)
	let photo = $derived.by(() => {
		const url = user.profile_photo_url;
		if (!url) return null;
		return /^(https?:\/\/|blob:)/.test(url) ? url : "https://" + url;
	});
	// a photo that fails to load (e.g. 404) falls back to initials instead of showing alt text
	let failed = $state<string | null>(null);
	let src = $derived(photo && failed !== photo ? photo : null);

	// no photo: the first letters of the first two words of their name ("Kevin A Clark" -> "KA"),
	// or the first two letters of a one-word name. words that don't start with a letter, like
	// "(Kanyi)", are skipped. the logo if there's no name at all
	let initials = $derived.by(() => {
		const words = (user.name ?? "")
			.trim()
			.split(/\s+/)
			.filter((w) => /^\p{L}/u.test(w));
		const letters = words.length > 1 ? words[0][0] + words[1][0] : (words[0] ?? "").slice(0, 2);
		return letters.toUpperCase();
	});
</script>

<!-- a regular, pointy-top hexagon (width = height * sqrt(3)/2), clipped with no background so
     transparent photos show what's behind. the border is a 2px stroke drawn along the hexagon's
     edge; the clip cuts off its outer half, leaving an even 1px inside on every edge -->
<!-- the image is absolutely positioned so it never affects the avatar's size: only the
     height class and the aspect ratio decide it -->
<!-- @container lets the initials size themselves to the avatar: cqw is 1% of its width, which
     the height and aspect ratio fix (an inline-size container, so cqh wouldn't work) -->
{#if dashed}
	<span class={cn("relative block aspect-[0.8660254] h-12 shrink-0", className)}>
		<svg
			aria-hidden="true"
			class="absolute inset-0 size-full overflow-visible"
			viewBox="0 0 86.60254 100"
		>
			<polygon
				points="43.30127,1.5 85.10254,25.75 85.10254,74.25 43.30127,98.5 1.5,74.25 1.5,25.75"
				class="fill-zinc-100 stroke-zinc-400 dark:fill-zinc-700/50 dark:stroke-zinc-500"
				stroke-width="1"
				stroke-dasharray="4 3"
				vector-effect="non-scaling-stroke"
			/>
		</svg>
	</span>
{:else}
	<div
		class={cn(
			"hex @container relative aspect-[0.8660254] h-12 shrink-0 overflow-hidden",
			className,
		)}
	>
		{#if src}
			<img
				{src}
				alt="{user.name}'s avatar"
				class="absolute inset-0 size-full object-cover"
				onerror={() => (failed = photo)}
			/>
		{:else if initials}
			<!-- no photo: initials, bold, lowercase and small, on a filled hexagon -->
			<span
				role="img"
				aria-label="{user.name}'s initials"
				class="absolute inset-0 grid place-items-center bg-yellow-400 text-[42.5cqw] leading-none font-bold lowercase text-yellow-50"
				>{initials}</span
			>
		{:else}
			<img src={bblogo} alt="" class="absolute inset-0 size-full object-cover" />
		{/if}
		<svg
			aria-hidden="true"
			class="pointer-events-none absolute inset-0 size-full text-yellow-400"
			viewBox="0 0 100 100"
			preserveAspectRatio="none"
		>
			<polygon
				points="50,0 100,25 100,75 50,100 0,75 0,25"
				fill="none"
				stroke="currentColor"
				stroke-width="2"
				vector-effect="non-scaling-stroke"
			/>
		</svg>
	</div>
{/if}

<style>
	.hex {
		clip-path: polygon(50% 0, 100% 25%, 100% 75%, 50% 100%, 0 75%, 0 25%);
	}
</style>
