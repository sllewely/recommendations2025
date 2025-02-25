<script lang="ts">
	import { page } from '$app/state';
</script>

<header class="bg-white">

	<nav class="mx-auto flex max-w-7xl items-center justify-between p-6 lg:px-8">
		<div class="flex lg:flex-1">
			<a href="/">
				<span class="sr-only">Img text for screen reader</span>
			</a>
		</div>
		<div class="hidden lg:flex lg:gap-x-12">
			<div class="relative">
				<a href="/" class="text-sm/6 font-semibold text-gray-900">Home</a>
				<a href="/about" class="text-sm/6 font-semibold text-gray-900">About</a>
			</div>
		</div>
		<div class="hidden lg:flex lg:flex-1 lg:justify-end">
			<a href="/sign_in" class="text-sm/6 font-semibold text-gray-900">Log in <span aria-hidden="true">&rarr;</span></a>
		</div>
	</nav>

</header>

