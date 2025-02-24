<script lang="ts">
    async function submitCreateAccount(event: Event) {};

    async function onsubmit() {
        console.log($state.snapshot(name));
        console.log("sarah");
    }

    let name = $state("");

    $inspect(name);

</script>

<h2>Create account</h2>

<form {onsubmit}>
    <label for="friend_code">Friend Code:</label>
    <input type="text" name="friend code" id="friend_code"/><br />
    <label for="name">Name</label>
    <input type="text" name="name" id="name" bind:value={name}/><br />
    <label for="email">E-mail:</label>
    <input type="text" name="email" id="email"/><br />
    <label for="password">Password:</label>
    <input type="password" name="password" id="password"/><br />
    <button type="submit">Create account</button>
</form>