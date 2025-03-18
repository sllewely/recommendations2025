<script lang="ts">
    import Header from './Header.svelte';
    import { fail } from '@sveltejs/kit';
    import Footer from '$lib/components/Footer.svelte';
    import '../../app.css';
    import {current_user} from '$lib/state/current_user.svelte';

    let { children, data } = $props();
    let user_id = data.user_id;

    current_user.id = user_id;

</script>

<div class="app">
    <Header user_id={user_id}/>

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

    footer {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        padding: 12px;
    }

    footer a {
        font-weight: bold;
    }

    @media (min-width: 480px) {
        footer {
            padding: 12px 0;
        }
    }
</style>
