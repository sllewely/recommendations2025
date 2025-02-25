<script lang="ts">
    import Header from './Header.svelte';
    import '../../app.css';

    let { children } = $props();
</script>

<div class="app">
    <Header />

    <main>
        {@render children()}
    </main>

    <footer>
        <p>
            recommendations by celery
        </p>
    </footer>
</div>


