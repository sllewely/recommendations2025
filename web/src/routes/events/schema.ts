import { z } from "zod";

export const eventsFormSchema = z.object({
	title: z.string().min(2).max(120),
	start_date: z.string(),
	end_date: z.string().nullable(),
	start_time: z.string().default("17:00"),
	time_zone: z.string(),
	description: z.string(),
	address: z.string().nullable(),
	url: z.string().nullable(),
	event_type: z.string().nullable(),
	is_public: z.boolean().default(true),
	invited_friend_ids: z.string().array().default([]),
	id: z.string().nullable(),
});

export type EventsFormSchema = typeof eventsFormSchema;
