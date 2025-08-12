<script lang="ts">
	import Link from "$lib/components/text/Link.svelte";
	import H1 from "$lib/components/text/H1.svelte";
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Bumblebeans" />
</svelte:head>

<section>
	<div class="flex items-center justify-center">
		<div>
			<H1>
				<span class="text-yellow-700">BumbleBeans</span> by
				<span class="text-cyan-800">Celery</span>
			</H1>

			<h2 class="text-md">welcome to my app!!!</h2>

			<p>&nbsp;</p>
			<p>demo instructions</p>
			<ul>
				<li>- create an account</li>
				<li>- sign in!</li>
				<li>- add friends :)</li>
				<li>- make a post!!!</li>
				<li>- create an event or save a book, movie, etc you want to remember or share</li>
			</ul>
		</div>
	</div>
</section>
