import { z } from "zod";

export const signinFormSchema = z.object({
	email: z.string().min(1).max(255),
	password: z.string().min(6).max(100),
});

export type SigninFormSchema = typeof signinFormSchema;
