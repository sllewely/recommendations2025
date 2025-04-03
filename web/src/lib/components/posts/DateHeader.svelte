<script lang="ts">
    import Card from "$lib/components/Card.svelte";
    import Link from "$lib/components/text/Link.svelte";
    import H2 from "$lib/components/text/H2.svelte";

    let {event_item} = $props();
</script>
<div class="p-2 ">
<div class="p-4 flex justify-center bg-white border border-gray-200 rounded-lg shadow-sm bg-orange-300 dark:border-gray-700">
    <H2>{event_item['date_header']}</H2>

</div>
</div>