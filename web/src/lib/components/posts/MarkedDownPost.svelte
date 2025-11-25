<script lang="ts">
	import { marked } from "marked";

	let { captured_text } = $props();

	// // TODO: purify html input
	// class MyRenderer extends marked.Renderer {
	// 	link({ href, title, text }) {
	// 		return super.link({ href, title, text });
	// 	}
	// 	heading({ tokens, depth }) {
	// 		2 + 5;
	// 		console.log("sarah test");
	// 		const text = this.parser.parseInline(tokens);
	// 		// const escapedText = text.toLowerCase().replace(/[^\w]+/g, "-");
	//
	// 		const hclass = (() => {
	// 			switch (depth) {
	// 				case 1:
	// 					return `text-4xl`;
	// 				case 2:
	// 					return `text-3xl`;
	// 				case 3:
	// 					return `text-2xl`;
	// 				default:
	// 					return `text-xl`;
	// 			}
	// 		})();
	//
	// 		return `
	//           <h${depth} class=${hclass}>
	//             ${text}
	//           </h${depth}>`;
	// 	}
	// }

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

	const description = {
		name: "description",
		level: "inline", // Is this a block-level or inline-level tokenizer?
		start(src) {
			return src.match(/:/)?.index;
		}, // Hint to Marked.js to stop and check for a match
		tokenizer(src, tokens) {
			const rule = /^:([^:\n]+):([^:\n]*)(?:\n|$)/; // Regex for the complete token, anchor to string start
			const match = rule.exec(src);
			if (match) {
				return {
					// Token to generate
					type: "description", // Should match "name" above
					raw: match[0], // Text to consume from the source
					dt: this.lexer.inlineTokens(match[1].trim()), // Additional custom properties, including
					dd: this.lexer.inlineTokens(match[2].trim()), //   any further-nested inline tokens
				};
			}
		},
		renderer(token) {
			return `\n<dt>${this.parser.parseInline(token.dt)}</dt><dd>${this.parser.parseInline(token.dd)}</dd>`;
		},
		childTokens: ["dt", "dd"], // Any child tokens to be visited by walkTokens
	};

	marked.use({ renderer });

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
