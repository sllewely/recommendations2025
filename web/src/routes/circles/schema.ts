import z from "zod";

export const circleFormSchema = z.object({
	name: z.string().min(1, "Circle name is required"),
	member_ids: z.array(z.string()).min(1, "At least one member is required"),
});

export type CircleFormSchema = typeof circleFormSchema;
