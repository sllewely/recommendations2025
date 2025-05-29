import { z } from "zod";

export const profileFormSchema = z.object({
	name: z.string().min(4).max(50),
	blurb: z.string().optional(),
	string_tags: z.string().optional(),
	email: z.string().email(),
	password: z.string().min(6).optional(),
});

export type FormSchema = typeof profileFormSchema;
