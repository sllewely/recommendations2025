<script>
	let { name, label, value = false } = $props();
	let checked = value ? "checked" : null;
</script>

<div class="grid grid-cols-2">
	<label for={name} class="mb-2 text-sm font-medium text-gray-900"
		><input
			type="checkbox"
			{name}
			id={name}
			class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 p-2.5"
			{checked}
		/>
		{label}</label
	>
</div>
