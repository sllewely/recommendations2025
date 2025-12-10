<script lang="ts">
	import { marked } from "marked";

	let { captured_text } = $props();

	const user_tag = {
		name: "user_tag",
		level: "inline", // Is this a block-level or inline-level tokenizer?
		start(src) {
			return src.match(/@\[/)?.index;
		}, // Hint to Marked.js to stop and check for a match
		tokenizer(src, tokens) {
			const rule = /^@(\[.+?\]\(\/users\/.+?\))/; // Regex for the complete token, anchor to string start
			const match = rule.exec(src);
			if (match) {
				return {
					// Token to generate
					type: "user_tag", // Should match "name" above
					raw: match[0], // Text to consume from the source
					entire: this.lexer.inlineTokens(match[1].trim()), // Additional custom properties
				};
			}
		},
		renderer(token) {
			const uuid_regex = /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/;
			const uuid = uuid_regex.exec(token.entire[0].raw)?.[0];
			return `<div class="user_tag" id=${uuid}>@${this.parser.parseInline(token.entire)}</div>`;
		},
	};

	// @TODO: I want a user card to load on hover
	// exec only in browser
	// onMount(() => {
	// 	window.addEventListener("DOMContentLoaded", () => {
	// 		const container = document.querySelector("div.user_tag");
	// 		if (container === null) return;
	// 		container.addEventListener("mouseenter", (e) => {
	// 			console.log("detect user tag");
	// 			console.log(e.target.id);
	// 		});
	// 	});
	// });

	marked.use({ extensions: [user_tag] });
	let marked_text = $derived(marked(captured_text));
</script>

<link rel="stylesheet" href="../../../app.css" />

<div class="markddown">
	<div class="hidden">
		<p>text</p>
		<h1>h1</h1>
		<h2>h2</h2>
		<h3>h3</h3>
	</div>
	<section>
		{@html marked_text}
	</section>
</div>

<style>
	@reference '$src/app.css';

	div.markddown :global(p) {
		@apply text-base;
	}
	div.markddown :global(h1) {
		@apply text-4xl;
	}
	div.markddown :global(h2) {
		@apply text-3xl;
	}
	div.markddown :global(h3) {
		@apply text-2xl;
	}
	div.markddown :global(a) {
		@apply underline text-cyan-500;
	}
	div.markddown :global(li) {
		@apply text-sm;
		list-style-type: disc;
		list-style-position: inside;
	}
	div.markddown :global(code) {
		@apply bg-gray-200 p-1 rounded;
	}
</style>
