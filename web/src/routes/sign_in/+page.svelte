<script lang="ts">
    let name="Roonie";

    async function submitSignin(event: Event) {}

</script>

<h1>{name.toUpperCase()}!  Are you a kitty cat???</h1>

<h2>Sign in</h2>

<form on:submit|preventDefault={submitSignin} method="POST">
    <label for="email">E-mail:</label>
    <input type="text" name="email" id="email"/><br />
    <label for="password">Password:</label>
    <input type="password" name="password" id="password"/><br />
    <button type="submit">Sign in</button>
</form>