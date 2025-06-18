<script lang="ts">
    import EventsForm from "../EventsForm.svelte";

    let { data, form } = $props();

</script>

<EventsForm form_data={data.form}/>
