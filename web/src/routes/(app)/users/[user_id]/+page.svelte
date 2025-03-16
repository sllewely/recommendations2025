<script lang="ts">
    import H1 from '$lib/components/text/H1.svelte'

    let {data} = $props();
    let user = data.user;

</script>
<H1>{user.name}</H1>
<p>Your friend, {user.name}, because presently everyone on the app is your friend</p>