import { z } from "zod";

export const eventsFormSchema = z.object({
	title: z.string().min(2).max(120),
	start_date: z.string(),
	end_date: z.string().nullable(),
	start_time: z.string().default("17:00"),
	time_zone: z.string(),
	description: z.string().nullable(),
	address: z.string().nullable(),
	url: z.string().nullable(),
	event_type: z.string().nullable(),
	is_public: z.boolean().nullable(),
});

export type EventsFormSchema = typeof eventsFormSchema;
