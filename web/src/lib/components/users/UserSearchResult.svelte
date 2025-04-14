<script lang="ts">

    import Link from "$lib/components/text/Link.svelte";

    let {user} = $props();


</script>

<div class="p-4 border-1 border-gray-200 rounded-sm flex flex-row justify-between">
    <div>
        <Link url="/users/{user.id}"><p>{user.name}</p></Link>
    </div>
    <div>Add friend</div>
</div>