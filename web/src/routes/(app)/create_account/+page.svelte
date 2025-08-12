<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";

	import FormButton from "$lib/components/form/FormButton.svelte";
	import Input from "$lib/components/form/Input.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import { toasts, newToast, ToastType } from "$lib/state/toast.svelte.js";
	import SignupForm from "./SignupForm.svelte";
	import type { PageData } from "../../../../.svelte-kit/types/src/routes";

	let { data }: { data: PageData } = $props();
</script>

<div>
	<H1>Create account</H1>

	<SignupForm form_data={data.form} />
</div>
