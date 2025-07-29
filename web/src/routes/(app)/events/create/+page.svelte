<script lang="ts">
	import { enhance } from "$app/forms";
	import Input from "$lib/components/form/Input.svelte";
	import InputDateTime from "$lib/components/form/InputDateTime.svelte";
	import InputCheckbox from "$lib/components/form/InputCheckbox.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import ToggleButton from "$lib/components/form/ToggleButton.svelte";
	import Card from "$lib/components/Card.svelte";
	import LinkButton from "$lib/components/text/LinkButton.svelte";

	import { RecommendationStatus } from "$lib/enums";
	import InputeDateTime from "$lib/components/form/InputDateTime.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { goto } from "$app/navigation";

	import type { PageData } from "./$types.js";
	import EventsForm from "../EventsForm.svelte";

	let { data }: { data: PageData } = $props();

	let creating = $state(false);

	// TODO:
	// Privacy
</script>

<div>
	<EventsForm {data} />
</div>
