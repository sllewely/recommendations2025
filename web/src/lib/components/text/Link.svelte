<script lang="ts">
	let { url } = $props();
</script>

<a class="text-teal-400 hover:text-orange-400" href={url}>
	<slot />
</a>
