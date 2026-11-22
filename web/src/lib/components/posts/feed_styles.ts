// Card + accent styling for the feed, from the redesign (f6826f0)
export const CARD_BG = "rounded-xl bg-zinc-100 dark:bg-zinc-700/50";
export const CARD = CARD_BG + " px-3 py-2";

// class names written out in full so Tailwind finds them.
// `hover` lights up the card's dashed border while its ".card-link" is hovered
export const ACCENTS = {
	sky: {
		text: "text-sky-500 dark:text-sky-300",
		hover: "has-[.card-link:hover]:border-sky-500 dark:has-[.card-link:hover]:border-sky-200",
	},
	lime: {
		text: "text-lime-500 dark:text-lime-300",
		hover: "has-[.card-link:hover]:border-lime-500 dark:has-[.card-link:hover]:border-lime-200",
	},
	fuchsia: {
		text: "text-fuchsia-500 dark:text-fuchsia-300",
		hover:
			"has-[.card-link:hover]:border-fuchsia-500 dark:has-[.card-link:hover]:border-fuchsia-200",
	},
} as const;

export type Accent = keyof typeof ACCENTS;

export const FEED_ACCENTS: Record<string, Accent> = {
	Post: "sky",
	Event: "lime",
	Recommendation: "fuchsia",
};
