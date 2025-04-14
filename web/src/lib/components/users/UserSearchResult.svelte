<script lang="ts">

    let {user} = $props();


</script>

<div class="p-4 border-1 border-gray-200 rounded-sm flex flex-row justify-between">
    <div><p>{user.name}</p></div>
    <div>Add friend</div>
</div>