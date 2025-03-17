<script lang="ts">

    let {border_color} = $props();
    let border_default = border_color ?? "border-teal-700";

</script>

<div class="p-6 border-2 {border_default} rounded-lg shadow-sm dark:bg-gray-800 dark:border-gray-700">
    <slot />
</div>