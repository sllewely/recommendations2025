<script lang="ts">
	let { url } = $props();
</script>

<a class="text-amber-400" href={url}>
	<slot />
</a>
