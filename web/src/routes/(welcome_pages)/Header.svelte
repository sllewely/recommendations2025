<script lang="ts">
	import { page } from '$app/state';
</script>

<header class="bg-gray-800 text-white py-4 px-3">
	<div class="container mx-auto flex items-center justify-between">
		<div class="w-full  md:text-center md:mb-0 mb-8">
			<p class="text-xs text-gray-400 md:text-sm">by celery</p>
		</div>
		<div class="w-full md:text-center md:mb-0 mb-8">
			<ul class="list-reset flex justify-center flex-wrap text-xs md:text-sm gap-3">
				<li><a href="/" class="text-gray-400 hover:text-white">Home</a></li>
				<li class="mx-4"><a href="/about" class="text-gray-400 hover:text-white">About</a></li>
				<li><a href="/create_account" class="text-gray-400 hover:text-white">Sign up</a></li>
			</ul>
		</div>
		<div class="w-full  md:text-center md:mb-0 mb-8 justify-end">
			<a href="/sign_in" class="text-sm/6 font-semibold text-gray-400 hover:text-orange-400" >Log in <span aria-hidden="true">&rarr;</span></a>
		</div>
	</div>
</header>

