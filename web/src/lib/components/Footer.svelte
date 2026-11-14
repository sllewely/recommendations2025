<footer class="bg-zinc-700 text-white py-6 mt-16">
	<!-- matches <main> in routes/+layout.svelte: max-width 52rem, 1rem padding -->
	<div class="max-w-[52rem] mx-auto px-4">
		<div class="flex flex-col md:flex-row items-center justify-between gap-3">
			<div class="w-full md:w-auto text-center md:text-left">
				<p class="text-sm text-zinc-300">recommendations and events for friends, by celery</p>
			</div>
			<nav>
				<ul class="flex flex-wrap justify-center gap-x-6 gap-y-2 md:text-sm text-xs">
					<li>
						<a
							href="https://github.com/sllewely/recommendations2025"
							class="text-zinc-300 hover:text-white transition-colors"
						>
							github
						</a>
					</li>
					<li>
						<a href="/bug_report" class="text-zinc-300 hover:text-white transition-colors">
							report bug
						</a>
					</li>
					<li>
						<a href="/roadmap" class="text-zinc-300 hover:text-white transition-colors">
							feature roadmap
						</a>
					</li>
				</ul>
			</nav>
		</div>
	</div>
</footer>
