<script lang="ts">
    import PendingFriendRequestNotification
        from "$lib/components/notifications/PendingFriendRequestNotification.svelte";
    import {notifs} from '$lib/state/notifications.svelte';
    import {current_user} from "$lib/state/current_user.svelte";
    import {goto} from "$app/navigation";


</script>

<div>
    {#each notifs.notifs as notification}
        {#if (notification.notif_type === "pending_friend_request")}
            <PendingFriendRequestNotification notif={notification}/>
        {/if}
    {/each}
</div>