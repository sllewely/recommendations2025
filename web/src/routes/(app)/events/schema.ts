import {z} from "zod";

export const eventsFormSchema = z.object({
        title: z.string().min(2).max(120),

    }
);

export type EventsFormSchema = typeof eventsFormSchema;