import { parseAbsoluteToLocal } from "@internationalized/date";

// e.g. "tue, nov 17, 11am" or "fri, mar 5, 2027, 7:30pm" (year only when it isn't this year).
// uses the browser's timezone, so call it in the browser (onMount), not during server render.
export function formatWhen(iso: string): string {
	const when = parseAbsoluteToLocal(iso);
	const date = when.toDate();
	const sameYear = when.year === new Date().getFullYear();
	const day = new Intl.DateTimeFormat("en-US", {
		weekday: "short",
		month: "short",
		day: "numeric",
		year: sameYear ? undefined : "numeric",
		timeZone: when.timeZone,
	}).format(date);
	const time = new Intl.DateTimeFormat("en-US", {
		hour: "numeric",
		minute: when.minute === 0 ? undefined : "2-digit",
		hour12: true,
		timeZone: when.timeZone,
	})
		.format(date)
		.replace(/\s/g, "");
	return `${day}, ${time}`.toLowerCase();
}

// e.g. "tue, nov 17" or "fri, mar 5, 2027" (year only when it isn't this year).
// uses the browser's timezone, so call it in the browser, not during server render.
export function formatDay(iso: string): string {
	const when = parseAbsoluteToLocal(iso);
	const sameYear = when.year === new Date().getFullYear();
	return new Intl.DateTimeFormat("en-US", {
		weekday: "short",
		month: "short",
		day: "numeric",
		year: sameYear ? undefined : "numeric",
		timeZone: when.timeZone,
	})
		.format(when.toDate())
		.toLowerCase();
}

// the local calendar day of an instant, e.g. "2026-11-17", for grouping. browser-only, like formatDay.
export function localDayKey(iso: string): string {
	return parseAbsoluteToLocal(iso).toString().slice(0, 10);
}
