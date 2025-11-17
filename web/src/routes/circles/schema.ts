import z from "zod";

export const circleFormSchema = z.object({
	name: z.string().min(1, "Circle name is required"),
	memberIds: z.array(z.string()).optional(),
});

export type CircleFormSchema = typeof circleFormSchema;
