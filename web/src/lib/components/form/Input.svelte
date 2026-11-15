<script>
	let {
		name,
		label,
		onchange,
		input_type = "text",
		value = "",
		placeholder = "",
		required = false,
		list = "",
	} = $props();
	let req = required ? "required" : "";
</script>

<div class="mb-5">
	<label for={name} class="block mb-2 text-sm font-medium text-gray-900"
		>{label}
		<input
			type={input_type}
			{name}
			id={name}
			class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
			{value}
			{placeholder}
			{req}
			{list}
			autocomplete="off"
			{onchange}
		/>
	</label>
</div>
