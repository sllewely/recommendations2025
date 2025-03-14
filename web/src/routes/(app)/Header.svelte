<script lang="ts">
	import { page } from '$app/state';
</script>

<header class="bg-gray-800 text-white py-4 px-3">
	<div class="container mx-auto flex items-center justify-between">
		<div class="w-full  md:text-center md:mb-0 mb-8">
			<p class="text-gray-400 text-xl">Recommendations and Events</p>
		</div>
		<div class="w-full md:text-center md:mb-0 mb-8">
			<ul class="list-reset flex justify-center flex-wrap text-xs md:text-sm gap-3">
				<li><a href="/posts" class="text-gray-400 hover:text-white">Posts</a></li>
				<li class="mx-4"><a href="/roadmap" class="text-gray-400 hover:text-white">Roadmap</a></li>
			</ul>
		</div>
		<div class="w-full  md:text-center md:mb-0 mb-8 justify-end">
			<a class="text-sm/6 font-semibold text-gray-400 hover:text-orange-400" >Log out <span aria-hidden="true">&rarr;</span></a>
		</div>
	</div>
</header>

