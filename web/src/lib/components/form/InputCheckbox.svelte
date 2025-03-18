<script>
    let { name, label, value='' } = $props();
</script>
<div class="mb-5">
    <label for={name} class="block mb-2 text-sm font-medium text-gray-900">{label}
        <input
                type="checkbox"
                name={name}
                id={name}
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
                value={value}
        />
    </label>
</div>