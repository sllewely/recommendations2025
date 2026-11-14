<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import EventsForm from "../EventsForm.svelte";
	import type { PageData } from "./$types.js";

	let { data }: { data: PageData } = $props();
</script>

<SubHeader>
	<SubHeaderTitle title="create event" caption="get your friends together" />
</SubHeader>

<EventsForm {data} />
