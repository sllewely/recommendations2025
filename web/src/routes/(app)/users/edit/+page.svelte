<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import UserForm from "./UserForm.svelte";
	import Link from "$lib/components/text/Link.svelte";

	let { data, form } = $props();
	let creating = $state(false);

	let user = data.user;

	let tags = $state(user.tags);
	$effect(() => {
		tags = data.user.tags;
	});
</script>

<div>
	<p>#TODO page needs a fun background!!</p>
	<H1>{user.name}</H1>
	<Link url="">photo upload</Link>

	<div>
		<UserForm form_data={data.form} {tags} />
	</div>
</div>
