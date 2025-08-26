// Common API response types
export interface ApiError {
	error?: string;
	exception?: string;
}

export interface ApiResponse<T = unknown> {
	success: boolean;
	res?: T;
	message?: string;
}

export interface PostsResponse {
	feed_items: (Post | Event | Recommendation)[];
	pagy: unknown;
}

export interface Post {
	id: string;
	created_at: string;
	updated_at: string;
	title?: string;
	description?: string;
	start_date_time?: string;
	address?: string;
	url?: null | string;
	event_type?: string;
	user_id: number;
	end_date_time?: string;
	is_public?: boolean;
	user: User;
	creator_name: string;
	creator_id: number;
	start_date_string?: string;
	start_time_string?: string;
	create_date_string: string;
	create_time_string: string;
	rsvps_count?: number;
	comments: Comment[];
	current_user_status?: null;
	notes?: null | string;
	media_type?: string;
	who_recommended?: string;
	status?: string;
	rating?: number;
	post_title?: string;
	content?: string;
	recommendations?: any[];
}

export interface Comment {
	id: number;
	created_at: string;
	updated_at: string;
	commentable_id: number;
	user_id: number;
	body: string;
}

// TODO: Theres a zod schema for this, can derive it from the schema
export interface UserUpdatePayload {
	name: string;
	blurb: string;
	tags: string[];
	email: string;
	password: string;
}

export interface User {
	id: string;
	username: string;
	name: string;
	tags: string[];
	string_tags?: string;
	blurb: string;
}

export interface Event {
	id: string;
	created_at: Date;
	updated_at: Date;
	title: string;
	description: string;
	start_date_time: string;
	address: string;
	url: string;
	event_type: string;
	user_id: number;
	end_date_time: Date;
	is_public: boolean;
	user: User;
	class_name: string;
	creator_name: string;
	creator_id: number;
	start_date_string: string;
	start_time_string: string;
	create_date_string: string;
	create_time_string: string;
	rsvps_count: number;
	comments: any[];
	current_user_rsvp: null;
	rsvps: any[];
}

export type EventWithDateHeader =
	| { date_header: string }
	| (Event & { time_string: string; date_header?: string });

export type Recommendation = unknown;
export type CreateRecommendationData = unknown;
