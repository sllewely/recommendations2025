<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import SignupForm from "./SignupForm.svelte";
	import type { PageData } from "./$types.js";

	let { data }: { data: PageData } = $props();
</script>

<div>
	<H1>Create account</H1>

	<SignupForm form_data={data.form} />
</div>
