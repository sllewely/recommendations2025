<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import Button from "$lib/components/Button.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";
	import { CircleCheckBig, CircleX, ClipboardCheck, ClipboardCopy } from "@lucide/svelte";
	import { enhance } from "$app/forms";
	import { profileFormSchema } from "./schema";
	import { superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import FormField from "$lib/components/form/FormField.svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import type { User } from "$lib/api_calls/types";
	import { onMount } from "svelte";
	import Avatar from "$lib/components/users/Avatar.svelte";
	import { toast } from "svelte-sonner";
	import WebNotificationsToggle from "$lib/components/notifications/push/WebNotificationsToggle.svelte";

	let { data } = $props();

	let copied = $state<"calendar" | "rss" | null>(null);
	const copy = async (which: "calendar" | "rss", url: string) => {
		await navigator.clipboard.writeText(url);
		copied = which;
	};

	let user = $derived(data.user!);
	let tags = $derived(data.user?.tags ?? []);

	const form = superForm(data.form, {
		validators: zodClient(profileFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);
	let edit_password = $state(false);

	const values = () => ({
		email: $formData.email ?? "",
		name: $formData.name ?? "",
		blurb: $formData.blurb ?? "",
		string_tags: $formData.string_tags ?? "",
	});
	let saved = $state(values());
	const changed = (...keys: (keyof ReturnType<typeof values>)[]) =>
		keys.some((key) => (($formData[key] as string | undefined) ?? "") !== saved[key]);
	let account_dirty = $derived(changed("email") || !!$formData.password);
	let profile_dirty = $derived(changed("name", "blurb", "string_tags"));

	let upload_url = $state("");
	let files = $state<FileList | null>(null);
	let file = $derived(files?.[0] ?? null);
	let uploading = $state(false);
	let preview = $state<string | null>(null);

	onMount(async () => {
		const response = await fetch("/api/images/presigned_upload_url");
		upload_url = (await response.json()).url;
	});

	$effect(() => {
		if (!file) return;
		const url = URL.createObjectURL(file);
		preview = url;
		return () => URL.revokeObjectURL(url);
	});

	const upload = async () => {
		if (!file || !upload_url) return;
		uploading = true;
		try {
			const put = await fetch(upload_url, { method: "PUT", body: file });
			if (!put.ok) throw new Error(await put.text());
			const response = await fetch("/api/images/update_profile_url", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
			});
			const json = await response.json();
			if (json["errors"]) throw new Error(json["errors"]);
			newToast("updated your avatar");
			files = null;
		} catch (error) {
			newToast("couldn't upload your picture: " + (error as Error).message, ToastType.Error);
		} finally {
			uploading = false;
		}
	};

	interface Registration {
		endpoint: string;
	}

	let checked = $state(false);
	let service_worker_found = $state(false);
	let endpoint = $state<string | null>(null);
	let saved_registrations = $state<Registration[]>([]);
	let subscription_saved = $derived(
		!!endpoint && saved_registrations.some((r) => r.endpoint === endpoint),
	);

	let checks = $derived([
		{ ok: service_worker_found, yes: "service worker found", no: "service worker not found" },
		{
			ok: !!endpoint,
			yes: "this browser is subscribed",
			no: "this browser isn't subscribed: turn notifications on below",
		},
		{
			ok: subscription_saved,
			yes: "subscription saved",
			no: "subscription not saved: turn notifications on below",
		},
	]);

	const refresh = async () => {
		try {
			const registration = await navigator.serviceWorker.ready;
			service_worker_found = registration.active !== null;
			const subscription = await registration.pushManager.getSubscription();
			endpoint = subscription?.endpoint ?? null;
			const response = await fetch("/api/web_push/get_registrations");
			saved_registrations = await response.json();
		} catch (error) {
			console.error(error);
		} finally {
			checked = true;
		}
	};

	onMount(refresh);

	const send_test = async () => {
		const response = await fetch("/api/web_push/send_test_notification", {
			method: "POST",
			body: JSON.stringify({}),
			headers: { "Content-Type": "application/json" },
		});
		if (response.ok) {
			toast.success("check ur notifs");
		} else {
			toast.error("hmm problem.");
		}
	};
</script>

<SubHeader>
	<SubHeaderTitle title="settings" />
</SubHeader>

<div class="flex flex-col gap-10">
	{#if data.user}
		<form
			id="user_form"
			method="POST"
			action="?/update_user"
			class="flex flex-col gap-10"
			use:enhance={() => {
				creating = true;
				return async ({ update, result }) => {
					await update({ reset: false });
					creating = false;
					let res = result.data;
					if (res.success) {
						saved = values();
						$formData.password = undefined;
						edit_password = false;
						newToast("You have successfully updated your user");
					} else {
						newToast("Error updating " + res.message, ToastType.Error);
					}
				};
			}}
		>
			<section class="flex flex-col gap-2.5">
				{@render heading("account", account_dirty)}
				<FormField
					{form}
					name="email"
					autocomplete="email"
					label="email"
					description="your account email"
					bind:value={$formData.email}
				/>
				{#if edit_password}
					<FormField
						{form}
						name="password"
						autocomplete="new-password"
						label="new password"
						type="password"
						description="replaces your old password"
						bind:value={$formData.password}
					/>
				{:else}
					<FormRow label="password">
						<Button color="zinc" class="self-start" onclick={() => (edit_password = true)}>
							change password
						</Button>
					</FormRow>
				{/if}
			</section>

			<section class="flex flex-col gap-2.5">
				{@render heading("profile", profile_dirty)}
				<FormRow label="avatar" for="avatar" description="a .png or .jpg">
					<div class="flex flex-row flex-wrap items-center gap-5">
						<Avatar user={preview ? { ...user, profile_photo_url: preview } : user} class="h-16" />
						<input
							id="avatar"
							type="file"
							accept="image/png, image/jpeg"
							bind:files
							class="min-w-0 text-sm text-zinc-500 file:mr-3 file:cursor-pointer file:border file:border-dashed file:border-zinc-500 file:bg-transparent file:px-3 file:py-1.5 file:text-zinc-500 hover:file:border-solid dark:text-zinc-400 dark:file:border-zinc-400 dark:file:text-zinc-400"
						/>
						{#if file}
							<Button onclick={upload} disabled={uploading}>
								{#if uploading}
									<Spinner />
								{/if}
								upload
							</Button>
						{/if}
					</div>
				</FormRow>
				<FormField
					{form}
					name="name"
					autocomplete="name"
					label="name"
					description="your public display name"
					bind:value={$formData.name}
				/>
				<FormField
					{form}
					name="blurb"
					label="blurb"
					description="help people find you :)"
					multiline
					bind:value={$formData.blurb}
				/>
				<FormField
					{form}
					name="string_tags"
					label="tags"
					description="to help people search for you. @xamples are the name of your town, college, or friend group"
					bind:value={$formData.string_tags}
				>
					{#if tags?.length}
						<ul class="flex flex-row flex-wrap gap-x-2 text-sm text-zinc-500 dark:text-zinc-400">
							{#each tags as tag}
								<li>#{tag}</li>
							{/each}
						</ul>
					{/if}
				</FormField>
			</section>
		</form>

		{#snippet heading(title: string, dirty: boolean)}
			<div class="flex min-h-9 flex-row items-center justify-between gap-5">
				<SectionHeading>{title}</SectionHeading>
				{#if dirty}
					<Button type="submit" disabled={creating}>
						{#if creating}
							<Spinner />
						{/if}
						save
					</Button>
				{/if}
			</div>
		{/snippet}
	{/if}

	<section class="flex flex-col gap-3">
		<SectionHeading>notifications</SectionHeading>

		<FormRow
			label="web notifications"
			description="turn them on on each device you want them on: they're per browser"
		>
			{#if checked}
				<ul class="flex flex-col gap-1.5 text-sm">
					{#each checks as check}
						<li class="flex flex-row items-center gap-2">
							{#if check.ok}
								<CircleCheckBig class="size-4 shrink-0 text-lime-400" />
								{check.yes}
							{:else}
								<CircleX class="size-4 shrink-0 text-red-400" />
								{check.no}
							{/if}
						</li>
					{/each}
				</ul>
			{/if}
			<div class="flex flex-row flex-wrap gap-2 py-1.5">
				<WebNotificationsToggle onchange={refresh} />
				{#if subscription_saved}
					<Button color="zinc" onclick={send_test}>send yourself a test</Button>
				{/if}
			</div>
		</FormRow>

		{#if checked}
			<FormRow label="devices" description="browsers you get notifications on (this one is bold)">
				{#if saved_registrations.length === 0}
					<p class="text-sm text-zinc-500 dark:text-zinc-400">none yet</p>
				{:else}
					<ul class="flex flex-col gap-1.5 py-1.5 text-sm">
						{#each saved_registrations as registration}
							<li class={["truncate", registration.endpoint === endpoint && "font-bold"]}>
								{registration.endpoint}
							</li>
						{/each}
					</ul>
				{/if}
			</FormRow>
		{/if}
	</section>

	<section class="flex flex-col gap-3">
		<SectionHeading>feeds</SectionHeading>
		{#if data.calendar_url}
			{@const calendar_url = data.calendar_url}
			<FormRow
				label="calendar"
				description="add it in google/apple calendar (“from url”) to see bumblebeans events"
			>
				<Button class="self-start" onclick={() => copy("calendar", calendar_url)}>
					{#if copied === "calendar"}
						<ClipboardCheck /> copied!
					{:else}
						<ClipboardCopy /> copy calendar url
					{/if}
				</Button>
			</FormRow>
		{/if}
		<FormRow label="rss" description="follow your feed in an rss reader">
			<Button class="self-start" onclick={() => copy("rss", data.rss_url)}>
				{#if copied === "rss"}
					<ClipboardCheck /> copied!
				{:else}
					<ClipboardCopy /> copy rss url
				{/if}
			</Button>
		</FormRow>
	</section>
</div>
