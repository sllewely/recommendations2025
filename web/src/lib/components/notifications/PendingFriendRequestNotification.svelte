<script lang="ts">
    import {fly} from 'svelte/transition';
    import Link from "$lib/components/text/Link.svelte";
    import {current_user} from "$lib/state/current_user.svelte";
    import {goto} from "$app/navigation";

    interface Props {
        notif: Notification;
    }

    let {notif}: Props = $props();

    let clear_notif = async () => {
        const response = await fetch('/api/clear_notification', {
            method: 'POST',
            body: JSON.stringify({id: notif.id}),
            headers: {
                'Content-Type': 'application/json'
            }
        });
        await goto('/friends');
    }

</script>

<header class="bg-lime-200 text-black py-4 px-3 hover:bg-lime-100" transition:fly={{x: 200, duration: 2000}}
        onclick={clear_notif}>
    <div class="container mx-auto flex items-center justify-between">
        <div>
            <p>{notif.message}</p>
        </div>

        <div class="flex">
            <div>
                <Link url="/friends">accept friend request</Link>
            </div>
            <div class="px-4">
                <button class="hover:text-orange-500 text-xl" onclick={() => {}}>x</button>
            </div>
        </div>
    </div>
</header>

