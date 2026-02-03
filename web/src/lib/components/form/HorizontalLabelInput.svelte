<script lang="ts">
	import { Input } from "$lib/components/ui/input";
	import { Label } from "formsnap";
	import label from "$lib/components/ui/label";

	let { label_title, ...restProps } = $props();
</script>

<div class="flex flex-row gap-6 pb-6">
	<Label class="font-semibold">{label}</Label>
	<Input {...restProps} />
</div>
