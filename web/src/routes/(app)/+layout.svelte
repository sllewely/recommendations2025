<script lang="ts">
    import Header from '$lib/components/Header.svelte';
    import Footer from '$lib/components/Footer.svelte';
    import '../../app.css';
    import Toast from "$lib/components/Toast.svelte";
    import { current_user, isSignedIn } from '$lib/state/current_user.svelte.js';
    import PendingFriendRequestNotification from "$lib/components/PendingFriendRequestNotification.svelte";
    import {goto, invalidate} from "$app/navigation";
    import {onMount} from "svelte";

    let { children, data } = $props();

    current_user.id = data.current_user_id;

    let notifications = $state([]);

    // every 10 seconds, poll notifications
    onMount( () => {

        let fetch_notifs = async () => {
            const response = await fetch('/api/fetch_notifications', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            const res = await response.json();
            notifications = res['res'] ?? [];
            console.log('interval')
        }
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
<!--    <PendingFriendRequestNotification />-->
    {notifications}
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
