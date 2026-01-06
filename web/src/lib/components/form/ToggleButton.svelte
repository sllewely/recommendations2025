<script lang="ts">
	/* Toggle Button
    * Used for selecting one of multiple

     */

	let { color, selected } = $props();

	// TODO: turn into color consts

	const default_color_class = "bg-white hover:bg-orange-200 text-teal-700 border-teal-500";
	const default_color_selected_class = "bg-teal-700 text-white border-teal-500";
	const yellow_class = "bg-yellow-200 hover:bg-yellow-500 text-black border-yellow-500";
	const yellow_selected_class = "bg-yellow-500 text-black border-yellow-500";
	const blue_class = "bg-blue-200 hover:bg-blue-500 text-black border-blue-500";
	const blue_selected_class = "bg-blue-500 text-black border-blue-500";
	const orange_class = "bg-orange-200 hover:bg-orange-500 text-black border-orange-500";
	const orange_selected_class = "bg-orange-500 text-black border-orange-500";

	let color_class = $derived.by(() => {
		if (color === "yellow") return yellow_class;
		if (color === "blue") return blue_class;
		if (color === "orange") return orange_class;
		if (color !== null) console.warn("missing LinkButton color " + color);
		return default_color_class;
	});

	let color_selected_class = $derived.by(() => {
		if (color === "yellow") return yellow_selected_class;
		if (color === "blue") return blue_selected_class;
		if (color === "orange") return orange_selected_class;
		return default_color_selected_class;
	});
</script>

<button
	type="button"
	class="{selected ? color_selected_class : color_class} font-bold py-2 px-4 border rounded"
>
	<slot />
</button>
