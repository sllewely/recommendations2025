<script lang="ts">
	import { marked } from "marked";

	let { captured_text } = $props();

	// TODO: purify html input
	class MyRenderer extends marked.Renderer {
		link({ href, title, text }) {
			return super.link({ href, title, text });
		}
		heading({ tokens, depth }) {
			2 + 5;
			console.log("sarah test");
			const text = this.parser.parseInline(tokens);
			// const escapedText = text.toLowerCase().replace(/[^\w]+/g, "-");

			const hclass = (() => {
				switch (depth) {
					case 1:
						return `text-4xl`;
					case 2:
						return `text-3xl`;
					case 3:
						return `text-2xl`;
					default:
						return `text-xl`;
				}
			})();

			return `
            <h${depth} class=${hclass}>
              ${text}
            </h${depth}>`;
		}
	}

	const renderer = {
		heading({ tokens, depth }) {
			const text = this.parser.parseInline(tokens);
			// const escapedText = text.toLowerCase().replace(/[^\w]+/g, "-");

			const hclass = (() => {
				switch (depth) {
					case 1:
						return `text-4xl`;
					case 2:
						return `text-3xl`;
					case 3:
						return `text-2xl`;
					default:
						return `text-xl`;
				}
			})();

			return `
            <h${depth} class=${hclass}>
              ${text}
            </h${depth}>`;
		},
		// link({ href, title, tokens }) {
		// 	const text = this.parser.parseInline(tokens) as string;
		// 	const cleanHref = cleanUrl(href);
		// 	if (cleanHref === null) {
		// 		return text;
		// 	}
		// 	href = cleanHref;
		// 	let out = '<a href="' + href + '"';
		// 	if (title) {
		// 		out += ' title="' + escape(title) + '"';
		// 	}
		// 	out += ">" + text + "</a>";
		// 	return out;
		// },
	};

	marked.use({ renderer: new MyRenderer() });

	let marked_text = $derived(marked(captured_text));
</script>

<link rel="stylesheet" href="../../../app.css" />

<div class="markddown">
	<section>
		<p>afe</p>
		{@html marked_text}
	</section>
</div>

<style>
	@reference '../../../app.css';

	div.markddown :global(p) {
		color: #0000ff;
	}
	div.markddown :global(h1) {
		@apply text-4xl;
	}
	div.markddown :global(h2) {
		@apply text-4xl;
	}
	/*section :global(p) {*/
	/*	color: #0000ff;*/
	/*}*/
	/*div :global(p) {*/
	/*	color: #ffff00;*/
	/*}*/
</style>
