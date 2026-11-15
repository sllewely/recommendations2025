<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import PostForm from "$src/routes/posts/PostForm.svelte";
	import type { PageData } from "./$types.js";

	let { data }: { data: PageData } = $props();
</script>

<SubHeader>
	<SubHeaderTitle title="edit post" caption="writing to your friends builds community" />
</SubHeader>

<PostForm {data} />
