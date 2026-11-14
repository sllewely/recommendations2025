<script lang="ts">
	let { border_color, hover_color } = $props();
	let border_default = border_color ?? "border-teal-700";
	let hover = hover_color ?? "";
</script>

<div class="p-6 border-2 {border_default} {hover} rounded-lg shadow-sm">
	<slot />
</div>
