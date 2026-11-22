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
	// a photo that fails to load (e.g. 404) falls back to the logo instead of showing alt text
	let failed = $state<string | null>(null);
	let src = $derived(photo && failed !== photo ? photo : null);
</script>

<!-- a regular, pointy-top hexagon (width = height * sqrt(3)/2), clipped with no background so
     transparent photos show what's behind. the border is a 2px stroke drawn along the hexagon's
     edge; the clip cuts off its outer half, leaving an even 1px inside on every edge -->
<!-- the image is absolutely positioned so it never affects the avatar's size: only the
     height class and the aspect ratio decide it -->
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
	<div class={cn("hex relative aspect-[0.8660254] h-12 shrink-0 overflow-hidden", className)}>
		{#if src}
			<img
				{src}
				alt="{user.name}'s avatar"
				class="absolute inset-0 size-full object-cover"
				onerror={() => (failed = photo)}
			/>
		{:else}
			<img src={bblogo} alt="profile picture" class="absolute inset-0 size-full object-cover" />
		{/if}
		<svg
			aria-hidden="true"
			class="pointer-events-none absolute inset-0 size-full text-yellow-500 dark:text-yellow-400"
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
