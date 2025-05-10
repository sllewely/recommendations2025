import {z} from "zod";

export const profileFormSchema = z.object({
    name: z.string().min(4).max(50),
    blurb: z.string().nullable(),
    tags: z.string().nullable(),
    email: z.string().email(),
    password: z.string().min(6),
});

export type FormSchema = typeof profileFormSchema;