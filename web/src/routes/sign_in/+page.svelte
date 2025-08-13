<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import Link from "$lib/components/text/Link.svelte";

	import type { PageData } from "./$types.js";
	import SigninForm from "./SigninForm.svelte";

	let { data }: { data: PageData } = $props();
</script>

<div>
	<H1>Sign in</H1>
	<Link url="/create_account">Or create an account</Link>

	<div>
		<SigninForm form_data={data.form} />
	</div>
</div>
