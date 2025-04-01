<script lang="ts">
    import {goto} from '$app/navigation';
    import Header from './Header.svelte';
    import { fail } from '@sveltejs/kit';
    import Footer from '$lib/components/Footer.svelte';
    import '../../app.css';
    import {current_user} from '$lib/state/current_user.svelte';
    import Toast from "$lib/components/Toast.svelte";

    let { children } = $props();


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
