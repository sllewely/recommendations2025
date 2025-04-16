<script lang="ts">
    import {fly} from 'svelte/transition';
    import Link from "$lib/components/text/Link.svelte";

    interface Props {
        notif: Notification;
    }

    let {notif}: Props = $props();

</script>

<header class="bg-lime-200 text-black py-4 px-3" transition:fly={{x: 200, duration: 2000}}>
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

