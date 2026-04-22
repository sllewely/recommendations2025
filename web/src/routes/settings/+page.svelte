<script lang="ts">
	import UserForm from "./UserForm.svelte";
	import { Button } from "$lib/components/ui/button";
	import * as Collapsible from "$lib/components/ui/collapsible";
	import { buttonVariants } from "$lib/components/ui/button/index.js";
	import { ClipboardCheck, ClipboardPlus } from "lucide-svelte";
	import { global } from "$lib/state/global.svelte";

	let { data, form } = $props();

	let copiedRss = $state(false);
	let clickCopyRss = () => {
		navigator.clipboard.writeText(data.rss_url);
		copiedRss = true;
	};
</script>

<div class="flex flex-col gap-2">
	<span class="text-3xl">Settings</span>
	<div>
		<Button href="/settings/notifications">Debug Notifications</Button>
		<Button href="/settings/profile_picture">Profile picture</Button>
	</div>
	<Collapsible.Root class="w-full">
		<Collapsible.Trigger class={buttonVariants({ variant: "secondary", size: "lg", class: "" })}>
			Show RSS API key
		</Collapsible.Trigger>
		<Collapsible.Content class="w-full">
			<div class="flex flex-row justify-between border-1 p-2">
				<span class="text-sm">{data.rss_url}</span>
				<Button size="icon" onclick={clickCopyRss}>
					{#if copiedRss}
						<ClipboardCheck />
					{:else}
						<ClipboardPlus />
					{/if}
				</Button>
			</div>
		</Collapsible.Content>
	</Collapsible.Root>

	<div>
		<div>
			<UserForm form_data={data.form} tags={data.user.tags} />
		</div>
	</div>
</div>
