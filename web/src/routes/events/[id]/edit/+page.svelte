<script lang="ts">
	import { enhance } from "$app/forms";
	import H1 from "$lib/components/text/H1.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto } from "$app/navigation";
	import Card from "$lib/components/Card.svelte";
	import Input from "$lib/components/form/Input.svelte";
	import InputDateTime from "$lib/components/form/InputDateTime.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import moment from "moment";
	import EventsForm from "../../EventsForm.svelte";
	import type { PageData } from "./$types.js";

	let { data }: { data: PageData } = $props();
	// const event = data.event;

	let updating = $state(false);

	// let datetime_string = moment(event.start_date_time, moment.ISO_8601);
	// let date_string = datetime_string.format("YYYY-MM-DD");
	// let time_string = datetime_string.format("hh:mm");
</script>

<div>
	<!--	<H1>Edit Event {event.title}</H1>-->

	<EventsForm {data} />
</div>
