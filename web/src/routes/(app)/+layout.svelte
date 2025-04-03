<script lang="ts">
    import Header from '$lib/components/Header.svelte';
    import Footer from '$lib/components/Footer.svelte';
    import '../../app.css';
    import Toast from "$lib/components/Toast.svelte";
    import { current_user, isSignedIn } from '$lib/state/current_user.svelte.js';

    let { children, data } = $props();

    current_user.id = data.current_user_id;

</script>

<div class="app">
    <Header/>
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
