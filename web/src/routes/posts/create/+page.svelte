<script lang="ts">
	import PostForm from "$src/routes/posts/PostForm.svelte";
	import type { PageData } from "./$types.js";

	let { data }: { data: PageData } = $props();
</script>

<div>
	<PostForm {data} />
</div>
