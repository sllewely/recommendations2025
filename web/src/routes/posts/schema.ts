import z from "zod";

export const postFormSchema = z.object({
	content: z.string().min(1, "text is required"),
	id: z.string().uuid().optional(),
	privacy: z.enum(["public", "friends", "specific"]).default("public"),
	privacy_user_ids: z.string().array().default([]),
	privacy_circle_ids: z.string().array().default([]),
});

export type PostFormSchema = typeof postFormSchema;
