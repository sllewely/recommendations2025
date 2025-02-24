<script lang="ts">

    let {data, form} = $props();

    let name="Roonie";

    // async function submitSignin(event: Event) {}

</script>

<h1>{name.toUpperCase()}!  Are you a kitty cat???</h1>

<h2>Sign in</h2>

<form method="POST" action="?/signin">
    <label for="email">E-mail:
    <input
            type="text"
            name="email"
            value="{form?.description ?? ''}"
            id="email"
            autocomplete="off"
            required/>
    </label><br />
    <label for="password">Password:
    <input type="password" name="password" id="password" autocomplete="off" required/>
    </label><br />
    <button type="submit">Sign in</button>
</form>