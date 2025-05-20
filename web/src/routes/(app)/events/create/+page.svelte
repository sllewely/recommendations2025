<script lang="ts">
    import EventsForm from "../EventsForm.svelte";

    let { data, form } = $props();

</script>
{console.log(data.form)}


<EventsForm form_data={data.form}/>
