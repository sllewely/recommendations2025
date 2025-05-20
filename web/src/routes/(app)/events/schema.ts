import {z} from "zod";

export const eventsFormSchema = z.object({
        title: z.string().min(2).max(120),
        start_date: z.string(),
        end_date: z.string().nullable(),
        time_input: z.string(),

    }
);

export type EventsFormSchema = typeof eventsFormSchema;