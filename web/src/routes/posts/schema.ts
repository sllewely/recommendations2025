import z from "zod";

export const postFormSchema = z.object({
	content: z.string().min(1, "text is required"),
	id: z.string().uuid().optional(),
});

export type PostFormSchema = typeof postFormSchema;
