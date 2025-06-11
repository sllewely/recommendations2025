import { z } from "zod";

export const profileFormSchema = z.object({
	name: z.string().min(4).max(50),
	blurb: z.string().nullable(),
	string_tags: z.string().nullable(),
	email: z.string().email(),
	password: z.string().min(6).optional(),
	file: z.unknown().nullable(),
});

export type FormSchema = typeof profileFormSchema;
