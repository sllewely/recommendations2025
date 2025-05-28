import { z } from "zod";

export const signupFormSchema = z.object({
	name: z.string().min(1).max(255),
	email: z.string().min(1).max(255),
	password: z.string().min(6).max(100),
});

export type SignupFormSchema = typeof signupFormSchema;
