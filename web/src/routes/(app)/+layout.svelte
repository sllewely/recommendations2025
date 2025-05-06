<script lang="ts">
    import Header from '$lib/components/Header.svelte';
    import Footer from '$lib/components/Footer.svelte';
    import '../../app.css';
    import Toast from "$lib/components/Toast.svelte";
    import { current_user } from '$lib/state/current_user.svelte.js';
    import { notifs } from '$lib/state/notifications.svelte';
    import { friends_map, fetch_friends_map } from "$lib/state/friends_map.svelte";
    import {onMount} from "svelte";
    import BannerNotifications from "$lib/components/notifications/BannerNotifications.svelte";

    let { children, data } = $props();

     $effect(() => current_user.id = data.current_user_id);


    // every 10 seconds, poll notifications
    onMount( () => {
        fetch_friends_map();

        // TODO: switch to SSE instead of polling
        let fetch_notifs = async () => {
            const response = await fetch('/api/fetch_notifications', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            const res = await response.json();
            if (res['res']) {
                let notif_map = res['res'].map((notif_json) =>
                    ({
                        id: notif_json.id,
                        notif_type: notif_json.notif_type,
                        message: notif_json.message,
                        extras: notif_json.extras,
                        created_at: notif_json.created_at,
                    })
                );
                notifs.notifs = notif_map;
            } else {
                console.log('error getting notifications ' + res['error']);
            }
        };
        fetch_friends_map();
        fetch_notifs();
        const interval = setInterval(() => {
                fetch_notifs();
            }, 1000 * 60 * 5); // 5 minutes


            return () => {
                clearInterval(interval);
            }
        }
    );

</script>


<div class="app">
    <Header/>
    <BannerNotifications />
    <Toast />



    <main>
        {@render children()}
    </main>

    <Footer />
</div>

<style>
    .app {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    main {
        flex: 1;
        display: flex;
        flex-direction: column;
        padding: 1rem;
        width: 100%;
        max-width: 64rem;
        margin: 0 auto;
        box-sizing: border-box;
    }


    @media (min-width: 480px) {
        footer {
            padding: 12px 0;
        }
    }
</style>
