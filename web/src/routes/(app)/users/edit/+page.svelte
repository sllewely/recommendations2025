<script lang="ts">
    import H1 from '$lib/components/text/H1.svelte'

    let {data} = $props();
    let user = data.user;

</script>
<p>your info</p>
<H1>{user.name}</H1>
