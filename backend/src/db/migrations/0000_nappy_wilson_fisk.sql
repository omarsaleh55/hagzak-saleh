CREATE TYPE "public"."gender_enum" AS ENUM('male', 'female');--> statement-breakpoint
CREATE TABLE "account_statuses" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	"description" text,
	CONSTRAINT "account_statuses_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "amenities" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"code" varchar(40) NOT NULL,
	"label_en" varchar(60) NOT NULL,
	"label_ar" varchar(60),
	"icon_url" text,
	"is_active" boolean DEFAULT true,
	CONSTRAINT "amenities_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "booking_statuses" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	"description" text,
	CONSTRAINT "booking_statuses_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "cancellation_by_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	CONSTRAINT "cancellation_by_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "cancellation_policy_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	"description" text,
	CONSTRAINT "cancellation_policy_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "conversation_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	CONSTRAINT "conversation_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "court_statuses" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	CONSTRAINT "court_statuses_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "document_types" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"code" varchar(40) NOT NULL,
	"label_en" varchar(60) NOT NULL,
	"label_ar" varchar(60),
	CONSTRAINT "document_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "find_player_post_statuses" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	CONSTRAINT "find_player_post_statuses_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "find_player_skill_levels" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	"label_en" varchar(40) NOT NULL,
	"label_ar" varchar(40),
	CONSTRAINT "find_player_skill_levels_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "fraud_flag_types" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"code" varchar(60) NOT NULL,
	"description" text,
	CONSTRAINT "fraud_flag_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "languages" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(10) NOT NULL,
	"name" varchar(50) NOT NULL,
	CONSTRAINT "languages_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "log_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	CONSTRAINT "log_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "message_sender_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	CONSTRAINT "message_sender_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "message_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	CONSTRAINT "message_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "notification_channels" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	CONSTRAINT "notification_channels_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "notification_event_types" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"code" varchar(60) NOT NULL,
	"label" varchar(100) NOT NULL,
	"supports_push" boolean DEFAULT true,
	"supports_email" boolean DEFAULT true,
	"is_active" boolean DEFAULT true,
	CONSTRAINT "notification_event_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "payment_method_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(40) NOT NULL,
	"label" varchar(60) NOT NULL,
	"is_online" boolean NOT NULL,
	"is_active" boolean DEFAULT true,
	CONSTRAINT "payment_method_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "payment_statuses" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	CONSTRAINT "payment_statuses_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "points_transaction_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	CONSTRAINT "points_transaction_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "pricing_labels" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	"label_en" varchar(40) NOT NULL,
	"label_ar" varchar(40),
	CONSTRAINT "pricing_labels_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "promo_applicable_to" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	CONSTRAINT "promo_applicable_to_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "promo_code_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	CONSTRAINT "promo_code_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "reward_action_types" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"code" varchar(60) NOT NULL,
	"label_en" varchar(100) NOT NULL,
	"label_ar" varchar(100),
	"default_points" integer DEFAULT 0 NOT NULL,
	"is_active" boolean DEFAULT true,
	CONSTRAINT "reward_action_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "social_providers" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	CONSTRAINT "social_providers_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "subscription_plan_types" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(20) NOT NULL,
	"label" varchar(40) NOT NULL,
	"monthly_price" numeric(10, 2) DEFAULT '0' NOT NULL,
	"max_active_courts" integer,
	"is_active" boolean DEFAULT true,
	CONSTRAINT "subscription_plan_types_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "surface_types" (
	"id" "smallserial" PRIMARY KEY NOT NULL,
	"name_en" varchar(60) NOT NULL,
	"name_ar" varchar(60),
	"is_active" boolean DEFAULT true,
	CONSTRAINT "surface_types_name_en_unique" UNIQUE("name_en")
);
--> statement-breakpoint
CREATE TABLE "user_roles" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	"description" text,
	CONSTRAINT "user_roles_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "venue_statuses" (
	"id" smallint PRIMARY KEY NOT NULL,
	"code" varchar(30) NOT NULL,
	CONSTRAINT "venue_statuses_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "data_export_requests" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"requested_at" timestamp with time zone DEFAULT now() NOT NULL,
	"fulfilled_at" timestamp with time zone,
	"expires_at" timestamp with time zone,
	"download_url" text,
	"processed_by" uuid,
	"sla_deadline" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "legal_consents" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"consent_type" varchar(40) NOT NULL,
	"version" varchar(20) NOT NULL,
	"accepted" boolean NOT NULL,
	"ip_address" "inet",
	"user_agent" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "login_attempts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid,
	"identifier" varchar(255) NOT NULL,
	"ip_address" "inet" NOT NULL,
	"user_agent" text,
	"device_fingerprint" varchar(255),
	"success" boolean NOT NULL,
	"failure_reason" varchar(60),
	"is_new_device" boolean,
	"is_new_location" boolean,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "otp_rate_limits" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"identifier" varchar(255) NOT NULL,
	"identifier_type" varchar(10) NOT NULL,
	"ip_address" "inet",
	"window_hour_start" timestamp with time zone NOT NULL,
	"window_day_start" date NOT NULL,
	"hourly_count" smallint DEFAULT 0 NOT NULL,
	"daily_count" smallint DEFAULT 0 NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "uq_otp_rate_limits" UNIQUE("identifier","identifier_type","window_day_start")
);
--> statement-breakpoint
CREATE TABLE "otp_records" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid,
	"identifier" varchar(255) NOT NULL,
	"identifier_type" varchar(10) NOT NULL,
	"otp_hash" text NOT NULL,
	"purpose" varchar(30) NOT NULL,
	"ip_address" "inet",
	"is_used" boolean DEFAULT false NOT NULL,
	"used_at" timestamp with time zone,
	"expires_at" timestamp with time zone NOT NULL,
	"attempt_count" smallint DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_devices" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"device_fingerprint" varchar(255) NOT NULL,
	"device_name" varchar(200),
	"platform" varchar(20),
	"os_version" varchar(50),
	"app_version" varchar(20),
	"fcm_token" text,
	"first_seen_at" timestamp with time zone DEFAULT now() NOT NULL,
	"last_seen_at" timestamp with time zone DEFAULT now() NOT NULL,
	"last_ip" "inet",
	"is_trusted" boolean DEFAULT false NOT NULL,
	CONSTRAINT "uq_user_device" UNIQUE("user_id","device_fingerprint")
);
--> statement-breakpoint
CREATE TABLE "user_sessions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"token_hash" text NOT NULL,
	"device_id" varchar(255),
	"device_name" varchar(200),
	"user_agent" text,
	"ip_address" "inet",
	"issued_at" timestamp with time zone DEFAULT now() NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"last_used_at" timestamp with time zone,
	"revoked_at" timestamp with time zone,
	"revoke_reason" varchar(50),
	CONSTRAINT "user_sessions_token_hash_unique" UNIQUE("token_hash")
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"full_name" varchar(100) NOT NULL,
	"email" varchar(255) NOT NULL,
	"email_verified" boolean DEFAULT false NOT NULL,
	"password_hash" text,
	"phone_number" varchar(20) NOT NULL,
	"phone_verified" boolean DEFAULT false NOT NULL,
	"date_of_birth" date,
	"gender" "gender_enum",
	"profile_image_url" text,
	"city" varchar(100),
	"latitude" varchar(20),
	"longitude" varchar(20),
	"role_id" smallint NOT NULL,
	"account_status_id" smallint NOT NULL,
	"preferred_language_id" smallint NOT NULL,
	"social_provider_id" smallint,
	"social_provider_user_id" varchar(255),
	"failed_login_attempts" smallint DEFAULT 0 NOT NULL,
	"locked_until" timestamp with time zone,
	"last_login_at" timestamp with time zone,
	"referral_code" varchar(20) NOT NULL,
	"referred_by_user_id" uuid,
	"two_fa_enabled" boolean DEFAULT false NOT NULL,
	"two_fa_secret" text,
	"terms_accepted_at" timestamp with time zone,
	"terms_version" varchar(20),
	"deleted_at" timestamp with time zone,
	"deletion_requested_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "users_email_unique" UNIQUE("email"),
	CONSTRAINT "users_phone_number_unique" UNIQUE("phone_number"),
	CONSTRAINT "users_referral_code_unique" UNIQUE("referral_code")
);
--> statement-breakpoint
CREATE TABLE "user_favorite_venues" (
	"user_id" uuid NOT NULL,
	"venue_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "venue_amenity_map" (
	"venue_id" uuid NOT NULL,
	"amenity_id" uuid NOT NULL,
	"notes" varchar(200)
);
--> statement-breakpoint
CREATE TABLE "venue_approval_history" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"venue_id" uuid NOT NULL,
	"changed_by" uuid NOT NULL,
	"old_status_id" smallint,
	"new_status_id" smallint NOT NULL,
	"note" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "venue_documents" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"venue_id" uuid NOT NULL,
	"document_type_id" smallint NOT NULL,
	"file_path" text NOT NULL,
	"file_size_bytes" integer NOT NULL,
	"mime_type" varchar(30) NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"reviewed_by" uuid,
	"reviewed_at" timestamp with time zone,
	"rejection_note" text,
	"uploaded_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "venue_images" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"venue_id" uuid NOT NULL,
	"file_path" text NOT NULL,
	"file_size_bytes" integer NOT NULL,
	"mime_type" varchar(30) NOT NULL,
	"width_px" smallint,
	"height_px" smallint,
	"is_primary" boolean DEFAULT false NOT NULL,
	"sort_order" smallint DEFAULT 0 NOT NULL,
	"uploaded_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "venue_payment_methods" (
	"venue_id" uuid NOT NULL,
	"payment_method_type_id" smallint NOT NULL
);
--> statement-breakpoint
CREATE TABLE "venues" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"owner_id" uuid NOT NULL,
	"name" varchar(200) NOT NULL,
	"name_ar" varchar(200),
	"description" text,
	"description_ar" text,
	"address" varchar(400) NOT NULL,
	"city" varchar(100) NOT NULL,
	"latitude" numeric(10, 7) NOT NULL,
	"longitude" numeric(10, 7) NOT NULL,
	"phone_number" varchar(20),
	"rules" text,
	"rules_ar" text,
	"status_id" smallint NOT NULL,
	"approval_note" text,
	"approved_by" uuid,
	"approved_at" timestamp with time zone,
	"cancellation_policy_type_id" smallint NOT NULL,
	"cancellation_hours_before" smallint,
	"cancellation_penalty_percent" smallint,
	"cash_surcharge" numeric(8, 2) DEFAULT '10.00' NOT NULL,
	"subscription_plan_id" smallint NOT NULL,
	"subscription_expires_at" timestamp with time zone,
	"is_featured" boolean DEFAULT false NOT NULL,
	"feature_expires_at" timestamp with time zone,
	"average_rating" numeric(3, 2) DEFAULT '0',
	"total_reviews" integer DEFAULT 0 NOT NULL,
	"total_bookings" integer DEFAULT 0 NOT NULL,
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "court_images" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"court_id" uuid NOT NULL,
	"file_path" text NOT NULL,
	"file_size_bytes" integer NOT NULL,
	"mime_type" varchar(30) NOT NULL,
	"is_primary" boolean DEFAULT false NOT NULL,
	"sort_order" smallint DEFAULT 0 NOT NULL,
	"uploaded_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "courts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"venue_id" uuid NOT NULL,
	"sport_type_id" uuid NOT NULL,
	"surface_type_id" smallint,
	"name" varchar(100) NOT NULL,
	"description" text,
	"description_ar" text,
	"capacity" smallint,
	"has_lighting" boolean DEFAULT false NOT NULL,
	"status_id" smallint NOT NULL,
	"maintenance_note" text,
	"total_bookings" integer DEFAULT 0 NOT NULL,
	"average_rating" numeric(3, 2) DEFAULT '0',
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sport_types" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name_en" varchar(80) NOT NULL,
	"name_ar" varchar(80),
	"icon_url" text,
	"attributes" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"sort_order" smallint DEFAULT 0 NOT NULL,
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "sport_types_name_en_unique" UNIQUE("name_en")
);
--> statement-breakpoint
CREATE TABLE "court_blocked_slots" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"court_id" uuid NOT NULL,
	"block_date" date NOT NULL,
	"start_time" time NOT NULL,
	"end_time" time NOT NULL,
	"reason" varchar(200),
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "court_pricing_slots" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"court_id" uuid NOT NULL,
	"pricing_label_id" smallint,
	"day_of_week" smallint,
	"start_time" time NOT NULL,
	"end_time" time NOT NULL,
	"price_per_hour" numeric(10, 2) NOT NULL,
	"valid_from" date,
	"valid_until" date,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "court_schedule_overrides" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"court_id" uuid NOT NULL,
	"override_date" date NOT NULL,
	"open_time" time,
	"close_time" time,
	"is_closed" boolean DEFAULT false NOT NULL,
	"reason" varchar(200),
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "uq_court_schedule_override" UNIQUE("court_id","override_date")
);
--> statement-breakpoint
CREATE TABLE "court_weekly_availability" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"court_id" uuid NOT NULL,
	"day_of_week" smallint NOT NULL,
	"open_time" time,
	"close_time" time,
	"is_closed" boolean DEFAULT false NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "uq_court_weekly_availability" UNIQUE("court_id","day_of_week")
);
--> statement-breakpoint
CREATE TABLE "promo_codes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"code" varchar(40) NOT NULL,
	"promo_type_id" smallint NOT NULL,
	"value" numeric(10, 2) NOT NULL,
	"min_booking_amount" numeric(10, 2) DEFAULT '0' NOT NULL,
	"max_discount_cap" numeric(10, 2),
	"max_uses_total" integer,
	"max_uses_per_user" smallint DEFAULT 1 NOT NULL,
	"current_uses" integer DEFAULT 0 NOT NULL,
	"applicable_to_id" smallint NOT NULL,
	"applicable_entity_id" uuid,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"is_stackable" boolean DEFAULT false NOT NULL,
	"created_by" uuid NOT NULL,
	"scope" varchar(10) DEFAULT 'global' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "promo_codes_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "booking_slots" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"booking_id" uuid NOT NULL,
	"slot_start" time NOT NULL,
	"slot_end" time NOT NULL,
	"price" numeric(8, 2) NOT NULL,
	"pricing_slot_id" uuid
);
--> statement-breakpoint
CREATE TABLE "booking_status_history" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"booking_id" uuid NOT NULL,
	"old_status_id" smallint,
	"new_status_id" smallint NOT NULL,
	"changed_by" uuid,
	"reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "bookings" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"court_id" uuid NOT NULL,
	"venue_id" uuid NOT NULL,
	"booking_date" date NOT NULL,
	"total_hours" smallint NOT NULL,
	"start_time" time NOT NULL,
	"end_time" time NOT NULL,
	"subtotal" numeric(10, 2) NOT NULL,
	"cash_surcharge" numeric(8, 2) DEFAULT '0' NOT NULL,
	"discount_amount" numeric(8, 2) DEFAULT '0' NOT NULL,
	"promo_discount" numeric(8, 2) DEFAULT '0' NOT NULL,
	"points_discount" numeric(8, 2) DEFAULT '0' NOT NULL,
	"platform_commission" numeric(8, 2) DEFAULT '0' NOT NULL,
	"total_amount" numeric(10, 2) NOT NULL,
	"payment_method_type_id" smallint NOT NULL,
	"status_id" smallint NOT NULL,
	"reservation_expires_at" timestamp with time zone,
	"confirmed_at" timestamp with time zone,
	"cancelled_at" timestamp with time zone,
	"cancellation_reason" text,
	"cancelled_by_type_id" smallint,
	"cancelled_by_user_id" uuid,
	"no_show_marked_at" timestamp with time zone,
	"promo_code_id" uuid,
	"points_used" integer DEFAULT 0 NOT NULL,
	"check_in_at" timestamp with time zone,
	"check_in_method" varchar(10),
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "payments" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"booking_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"payment_method_type_id" smallint NOT NULL,
	"status_id" smallint NOT NULL,
	"gateway_transaction_id" varchar(200),
	"gateway_order_id" varchar(200),
	"gateway_response" jsonb,
	"callback_received_at" timestamp with time zone,
	"callback_signature_valid" boolean,
	"cash_confirmed_by" uuid,
	"cash_confirmed_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "payments_booking_id_unique" UNIQUE("booking_id"),
	CONSTRAINT "payments_gateway_transaction_id_unique" UNIQUE("gateway_transaction_id")
);
--> statement-breakpoint
CREATE TABLE "refunds" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"payment_id" uuid NOT NULL,
	"booking_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"refund_type" varchar(20) NOT NULL,
	"reason" text NOT NULL,
	"policy_applied" varchar(30),
	"penalty_amount" numeric(8, 2) DEFAULT '0' NOT NULL,
	"gateway_refund_id" varchar(200),
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"issued_by" uuid,
	"processed_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "saved_payment_methods" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"payment_method_type_id" smallint NOT NULL,
	"provider_token" text NOT NULL,
	"last_four" char(4),
	"card_brand" varchar(20),
	"expiry_month" smallint,
	"expiry_year" smallint,
	"wallet_number" varchar(20),
	"is_default" boolean DEFAULT false NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "milestone_definitions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name_en" varchar(100) NOT NULL,
	"name_ar" varchar(100),
	"required_bookings_per_month" smallint NOT NULL,
	"bonus_points" integer NOT NULL,
	"badge_name" varchar(60),
	"badge_icon_url" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"sort_order" smallint DEFAULT 0 NOT NULL,
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "points_ledger" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"transaction_type_id" smallint NOT NULL,
	"reward_action_type_id" smallint,
	"points" integer NOT NULL,
	"balance_after" integer NOT NULL,
	"reference_id" uuid,
	"reference_type" varchar(30),
	"expires_at" timestamp with time zone,
	"notes" text,
	"created_by" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_milestone_achievements" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"milestone_id" uuid NOT NULL,
	"achievement_month" date NOT NULL,
	"bookings_count" smallint NOT NULL,
	"points_awarded" integer NOT NULL,
	"points_ledger_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "uq_milestone_achievement" UNIQUE("user_id","milestone_id","achievement_month")
);
--> statement-breakpoint
CREATE TABLE "user_points_summary" (
	"user_id" uuid PRIMARY KEY NOT NULL,
	"points_balance" integer DEFAULT 0 NOT NULL,
	"total_earned" integer DEFAULT 0 NOT NULL,
	"total_redeemed" integer DEFAULT 0 NOT NULL,
	"total_expired" integer DEFAULT 0 NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "referrals" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"referrer_user_id" uuid NOT NULL,
	"referred_user_id" uuid NOT NULL,
	"referral_code_used" varchar(20) NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"first_booking_id" uuid,
	"reward_granted_at" timestamp with time zone,
	"referrer_points_ledger_id" uuid,
	"referred_points_ledger_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "referrals_referred_user_id_unique" UNIQUE("referred_user_id")
);
--> statement-breakpoint
CREATE TABLE "promo_code_usages" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"promo_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"booking_id" uuid NOT NULL,
	"discount_applied" numeric(8, 2) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "promo_code_usages_booking_id_unique" UNIQUE("booking_id"),
	CONSTRAINT "uq_promo_usage" UNIQUE("promo_id","user_id","booking_id")
);
--> statement-breakpoint
CREATE TABLE "review_photos" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"review_id" uuid NOT NULL,
	"file_path" text NOT NULL,
	"file_size_bytes" integer NOT NULL,
	"mime_type" varchar(30) NOT NULL,
	"sort_order" smallint DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "review_reports" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"review_id" uuid NOT NULL,
	"reported_by" uuid NOT NULL,
	"reason" varchar(200) NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"resolved_by" uuid,
	"resolved_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "uq_review_report" UNIQUE("review_id","reported_by")
);
--> statement-breakpoint
CREATE TABLE "reviews" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"booking_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"venue_id" uuid NOT NULL,
	"court_id" uuid NOT NULL,
	"rating" smallint NOT NULL,
	"comment" varchar(1000),
	"owner_reply" text,
	"owner_replied_at" timestamp with time zone,
	"is_reported" boolean DEFAULT false NOT NULL,
	"is_visible" boolean DEFAULT true NOT NULL,
	"edited_at" timestamp with time zone,
	"deleted_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "reviews_booking_id_unique" UNIQUE("booking_id")
);
--> statement-breakpoint
CREATE TABLE "conversation_participants" (
	"conversation_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"joined_at" timestamp with time zone DEFAULT now() NOT NULL,
	"last_read_at" timestamp with time zone,
	"is_muted" boolean DEFAULT false NOT NULL,
	"unread_count" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "conversation_participants_conversation_id_user_id_pk" PRIMARY KEY("conversation_id","user_id")
);
--> statement-breakpoint
CREATE TABLE "conversations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"conversation_type_id" smallint NOT NULL,
	"booking_id" uuid,
	"last_message_at" timestamp with time zone,
	"last_message_preview" varchar(100),
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "messages" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"conversation_id" uuid NOT NULL,
	"sender_id" uuid,
	"sender_type_id" smallint NOT NULL,
	"message_type_id" smallint NOT NULL,
	"content" varchar(2000),
	"file_path" text,
	"file_size_bytes" integer,
	"mime_type" varchar(60),
	"voice_duration_sec" smallint,
	"rich_card_data" jsonb,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "owner_auto_replies" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"owner_id" uuid NOT NULL,
	"message_en" text NOT NULL,
	"message_ar" text,
	"is_active" boolean DEFAULT false NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "owner_auto_replies_owner_id_unique" UNIQUE("owner_id")
);
--> statement-breakpoint
CREATE TABLE "user_blocks" (
	"blocker_id" uuid NOT NULL,
	"blocked_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "user_blocks_blocker_id_blocked_id_pk" PRIMARY KEY("blocker_id","blocked_id")
);
--> statement-breakpoint
CREATE TABLE "ai_chat_messages" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"session_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"role" varchar(20) NOT NULL,
	"content" text NOT NULL,
	"input_type" varchar(10) DEFAULT 'text' NOT NULL,
	"voice_file_path" text,
	"transcription" text,
	"intent_detected" varchar(100),
	"entities" jsonb,
	"actions_executed" jsonb,
	"rich_card_data" jsonb,
	"model_used" varchar(100),
	"tokens_used" integer,
	"response_time_ms" integer,
	"was_flagged" boolean DEFAULT false NOT NULL,
	"flag_reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ai_chat_sessions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"language_id" smallint NOT NULL,
	"turns_count" integer DEFAULT 0 NOT NULL,
	"context_snapshot" jsonb,
	"last_active_at" timestamp with time zone DEFAULT now() NOT NULL,
	"ended_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ai_knowledge_base" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"category" varchar(50) NOT NULL,
	"question_en" text NOT NULL,
	"question_ar" text,
	"answer_en" text NOT NULL,
	"answer_ar" text,
	"keywords" text[],
	"is_active" boolean DEFAULT true NOT NULL,
	"updated_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "speech_transcription_logs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"audio_duration_sec" smallint NOT NULL,
	"language_detected" varchar(10),
	"transcription" text,
	"confidence_score" numeric(4, 3),
	"status" varchar(20) NOT NULL,
	"error_message" text,
	"context" varchar(30) NOT NULL,
	"ai_message_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "notification_preferences" (
	"user_id" uuid NOT NULL,
	"event_type_id" smallint NOT NULL,
	"channel_id" smallint NOT NULL,
	"is_enabled" boolean DEFAULT true NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "notification_preferences_user_id_event_type_id_channel_id_pk" PRIMARY KEY("user_id","event_type_id","channel_id")
);
--> statement-breakpoint
CREATE TABLE "notification_templates" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"event_type_id" smallint NOT NULL,
	"channel_id" smallint NOT NULL,
	"language_id" smallint NOT NULL,
	"subject" varchar(200),
	"body" text NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"updated_by" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "uq_notification_template" UNIQUE("event_type_id","channel_id","language_id")
);
--> statement-breakpoint
CREATE TABLE "notifications" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"event_type_id" smallint NOT NULL,
	"channel_id" smallint NOT NULL,
	"title" varchar(200),
	"body" text NOT NULL,
	"data" jsonb,
	"reference_id" uuid,
	"reference_type" varchar(30),
	"status" varchar(20) DEFAULT 'queued' NOT NULL,
	"retry_count" smallint DEFAULT 0 NOT NULL,
	"last_error" text,
	"sent_at" timestamp with time zone,
	"read_at" timestamp with time zone,
	"scheduled_for" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "find_player_participants" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"post_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"payment_id" uuid,
	"share_amount" numeric(8, 2) NOT NULL,
	"paid_at" timestamp with time zone,
	"joined_at" timestamp with time zone DEFAULT now() NOT NULL,
	"left_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "find_player_posts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"court_id" uuid NOT NULL,
	"booking_id" uuid,
	"booking_date" date NOT NULL,
	"start_time" time NOT NULL,
	"end_time" time NOT NULL,
	"total_cost" numeric(10, 2) NOT NULL,
	"max_players" smallint NOT NULL,
	"current_players" smallint DEFAULT 1 NOT NULL,
	"cost_per_player" numeric(8, 2) NOT NULL,
	"sport_type_id" uuid NOT NULL,
	"skill_level_id" smallint NOT NULL,
	"description" text,
	"status_id" smallint NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "waitlist_entries" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"court_id" uuid NOT NULL,
	"booking_date" date NOT NULL,
	"start_time" time NOT NULL,
	"end_time" time NOT NULL,
	"queue_position" integer NOT NULL,
	"auto_book_enabled" boolean DEFAULT false NOT NULL,
	"saved_payment_method_id" uuid,
	"status" varchar(20) DEFAULT 'waiting' NOT NULL,
	"notified_at" timestamp with time zone,
	"response_deadline" timestamp with time zone,
	"booking_id" uuid,
	"joined_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "uq_waitlist_active" UNIQUE("user_id","court_id","booking_date","start_time")
);
--> statement-breakpoint
CREATE TABLE "fraud_flags" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"flag_type_id" smallint NOT NULL,
	"description" text NOT NULL,
	"ip_address" "inet",
	"device_fingerprint" varchar(255),
	"related_user_ids" uuid[],
	"reference_id" uuid,
	"reference_type" varchar(30),
	"severity" varchar(10) DEFAULT 'medium' NOT NULL,
	"status" varchar(20) DEFAULT 'open' NOT NULL,
	"reviewed_by" uuid,
	"reviewed_at" timestamp with time zone,
	"admin_notes" text,
	"auto_flagged" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "api_request_logs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid,
	"method" varchar(10) NOT NULL,
	"path" varchar(500) NOT NULL,
	"query_params" text,
	"status_code" smallint NOT NULL,
	"response_time_ms" integer NOT NULL,
	"ip_address" "inet",
	"user_agent" text,
	"request_id" uuid,
	"error_code" varchar(20),
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "audit_logs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"log_type_id" smallint NOT NULL,
	"user_id" uuid,
	"target_user_id" uuid,
	"ip_address" "inet",
	"user_agent" text,
	"device_fingerprint" varchar(255),
	"action" varchar(100) NOT NULL,
	"resource_type" varchar(40),
	"resource_id" uuid,
	"old_value" jsonb,
	"new_value" jsonb,
	"result" varchar(10) DEFAULT 'success' NOT NULL,
	"error_code" varchar(20),
	"metadata" jsonb,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "payment_logs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"payment_id" uuid NOT NULL,
	"booking_id" uuid NOT NULL,
	"user_id" uuid,
	"event_type" varchar(60) NOT NULL,
	"old_status" varchar(30),
	"new_status" varchar(30),
	"amount" numeric(10, 2),
	"gateway_transaction_id" varchar(200),
	"signature_valid" boolean,
	"raw_payload" jsonb,
	"ip_address" "inet",
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "security_logs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid,
	"event_type" varchar(60) NOT NULL,
	"ip_address" "inet" NOT NULL,
	"user_agent" text,
	"device_fingerprint" varchar(255),
	"identifier" varchar(255),
	"is_new_device" boolean,
	"is_suspicious" boolean DEFAULT false NOT NULL,
	"details" jsonb,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "system_event_logs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"event_type" varchar(80) NOT NULL,
	"status" varchar(10) NOT NULL,
	"affected_id" uuid,
	"affected_type" varchar(30),
	"records_affected" integer,
	"duration_ms" integer,
	"error_message" text,
	"metadata" jsonb,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "commission_rates" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"plan_id" smallint,
	"owner_id" uuid,
	"rate_percent" numeric(5, 2) NOT NULL,
	"valid_from" timestamp with time zone NOT NULL,
	"valid_until" timestamp with time zone,
	"notes" text,
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "owner_subscriptions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"owner_id" uuid NOT NULL,
	"venue_id" uuid NOT NULL,
	"plan_id" smallint NOT NULL,
	"started_at" timestamp with time zone NOT NULL,
	"expires_at" timestamp with time zone,
	"billing_cycle_days" smallint DEFAULT 30 NOT NULL,
	"amount_paid" numeric(10, 2) DEFAULT '0' NOT NULL,
	"payment_id" uuid,
	"auto_renew" boolean DEFAULT true NOT NULL,
	"cancelled_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "system_settings" (
	"key" varchar(80) PRIMARY KEY NOT NULL,
	"value" text NOT NULL,
	"value_type" varchar(10) NOT NULL,
	"description" text NOT NULL,
	"category" varchar(40) NOT NULL,
	"updated_by" uuid,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "featured_venue_purchases" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"venue_id" uuid NOT NULL,
	"owner_id" uuid NOT NULL,
	"payment_id" uuid NOT NULL,
	"amount_paid" numeric(8, 2) NOT NULL,
	"duration_days" smallint NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"cancelled_at" timestamp with time zone,
	"cancelled_by" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "featured_venue_purchases_payment_id_unique" UNIQUE("payment_id")
);
--> statement-breakpoint
CREATE TABLE "owner_payouts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"owner_id" uuid NOT NULL,
	"venue_id" uuid NOT NULL,
	"booking_id" uuid NOT NULL,
	"payment_id" uuid NOT NULL,
	"gross_amount" numeric(10, 2) NOT NULL,
	"platform_commission" numeric(8, 2) NOT NULL,
	"commission_rate_percent" numeric(5, 2) NOT NULL,
	"cash_surcharge_retained" numeric(8, 2) DEFAULT '0' NOT NULL,
	"net_amount" numeric(10, 2) NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"payout_method" varchar(40),
	"payout_reference" varchar(200),
	"payout_batch_id" uuid,
	"paid_at" timestamp with time zone,
	"cancelled_at" timestamp with time zone,
	"notes" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "owner_payouts_booking_id_unique" UNIQUE("booking_id")
);
--> statement-breakpoint
CREATE TABLE "payout_batches" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"owner_id" uuid NOT NULL,
	"period_start" date NOT NULL,
	"period_end" date NOT NULL,
	"total_gross" numeric(12, 2) NOT NULL,
	"total_commission" numeric(10, 2) NOT NULL,
	"total_net" numeric(12, 2) NOT NULL,
	"payout_count" integer NOT NULL,
	"status" varchar(20) DEFAULT 'draft' NOT NULL,
	"approved_by" uuid,
	"approved_at" timestamp with time zone,
	"paid_at" timestamp with time zone,
	"external_reference" varchar(200),
	"created_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "subscription_invoices" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"subscription_id" uuid NOT NULL,
	"owner_id" uuid NOT NULL,
	"venue_id" uuid NOT NULL,
	"billing_period_start" date NOT NULL,
	"billing_period_end" date NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"status" varchar(20) DEFAULT 'pending' NOT NULL,
	"payment_id" uuid,
	"due_date" date NOT NULL,
	"paid_at" timestamp with time zone,
	"retry_count" smallint DEFAULT 0 NOT NULL,
	"last_attempt_at" timestamp with time zone,
	"failure_reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ai_usage_daily" (
	"user_id" uuid NOT NULL,
	"usage_date" date DEFAULT now() NOT NULL,
	"message_count" integer DEFAULT 0 NOT NULL,
	"last_message_at" timestamp with time zone,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "ai_usage_daily_user_id_usage_date_pk" PRIMARY KEY("user_id","usage_date")
);
--> statement-breakpoint
CREATE TABLE "message_rate_limit_buckets" (
	"user_id" uuid NOT NULL,
	"window_start" timestamp with time zone NOT NULL,
	"message_count" smallint DEFAULT 0 NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "message_rate_limit_buckets_user_id_window_start_pk" PRIMARY KEY("user_id","window_start")
);
--> statement-breakpoint
CREATE TABLE "ai_cost_tracking" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"tracking_date" date DEFAULT now() NOT NULL,
	"model_id" varchar(100) NOT NULL,
	"total_requests" integer DEFAULT 0 NOT NULL,
	"total_input_tokens" bigint DEFAULT 0 NOT NULL,
	"total_output_tokens" bigint DEFAULT 0 NOT NULL,
	"estimated_cost_usd" numeric(10, 4) DEFAULT '0' NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ai_model_configs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"is_active" boolean DEFAULT false NOT NULL,
	"model_provider" varchar(20) NOT NULL,
	"model_id" varchar(100) NOT NULL,
	"system_prompt" text NOT NULL,
	"temperature" numeric(3, 2) DEFAULT '0.70' NOT NULL,
	"max_tokens" integer DEFAULT 1000 NOT NULL,
	"context_window_turns" smallint DEFAULT 10 NOT NULL,
	"fallback_model_id" varchar(100),
	"cost_per_1k_input_tokens" numeric(8, 6),
	"cost_per_1k_output_tokens" numeric(8, 6),
	"updated_by" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "search_analytics" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid,
	"query_text" varchar(200),
	"sport_type_id" uuid,
	"city" varchar(100),
	"search_date" date DEFAULT now() NOT NULL,
	"result_count" integer,
	"clicked_venue_id" uuid,
	"ip_address" "inet",
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "venue_view_counts" (
	"venue_id" uuid NOT NULL,
	"count_date" date DEFAULT now() NOT NULL,
	"impression_count" integer DEFAULT 0 NOT NULL,
	"profile_view_count" integer DEFAULT 0 NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "venue_view_counts_venue_id_count_date_pk" PRIMARY KEY("venue_id","count_date")
);
--> statement-breakpoint
ALTER TABLE "data_export_requests" ADD CONSTRAINT "data_export_requests_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "data_export_requests" ADD CONSTRAINT "data_export_requests_processed_by_users_id_fk" FOREIGN KEY ("processed_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "legal_consents" ADD CONSTRAINT "legal_consents_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "login_attempts" ADD CONSTRAINT "login_attempts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "otp_records" ADD CONSTRAINT "otp_records_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_devices" ADD CONSTRAINT "user_devices_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_role_id_user_roles_id_fk" FOREIGN KEY ("role_id") REFERENCES "public"."user_roles"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_account_status_id_account_statuses_id_fk" FOREIGN KEY ("account_status_id") REFERENCES "public"."account_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_preferred_language_id_languages_id_fk" FOREIGN KEY ("preferred_language_id") REFERENCES "public"."languages"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_social_provider_id_social_providers_id_fk" FOREIGN KEY ("social_provider_id") REFERENCES "public"."social_providers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_referred_by_user_id_users_id_fk" FOREIGN KEY ("referred_by_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_favorite_venues" ADD CONSTRAINT "user_favorite_venues_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_favorite_venues" ADD CONSTRAINT "user_favorite_venues_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_amenity_map" ADD CONSTRAINT "venue_amenity_map_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_amenity_map" ADD CONSTRAINT "venue_amenity_map_amenity_id_amenities_id_fk" FOREIGN KEY ("amenity_id") REFERENCES "public"."amenities"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_approval_history" ADD CONSTRAINT "venue_approval_history_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_approval_history" ADD CONSTRAINT "venue_approval_history_changed_by_users_id_fk" FOREIGN KEY ("changed_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_approval_history" ADD CONSTRAINT "venue_approval_history_old_status_id_venue_statuses_id_fk" FOREIGN KEY ("old_status_id") REFERENCES "public"."venue_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_approval_history" ADD CONSTRAINT "venue_approval_history_new_status_id_venue_statuses_id_fk" FOREIGN KEY ("new_status_id") REFERENCES "public"."venue_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_documents" ADD CONSTRAINT "venue_documents_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_documents" ADD CONSTRAINT "venue_documents_document_type_id_document_types_id_fk" FOREIGN KEY ("document_type_id") REFERENCES "public"."document_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_documents" ADD CONSTRAINT "venue_documents_reviewed_by_users_id_fk" FOREIGN KEY ("reviewed_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_documents" ADD CONSTRAINT "venue_documents_uploaded_by_users_id_fk" FOREIGN KEY ("uploaded_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_images" ADD CONSTRAINT "venue_images_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_images" ADD CONSTRAINT "venue_images_uploaded_by_users_id_fk" FOREIGN KEY ("uploaded_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_payment_methods" ADD CONSTRAINT "venue_payment_methods_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_payment_methods" ADD CONSTRAINT "venue_payment_methods_payment_method_type_id_payment_method_types_id_fk" FOREIGN KEY ("payment_method_type_id") REFERENCES "public"."payment_method_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venues" ADD CONSTRAINT "venues_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venues" ADD CONSTRAINT "venues_status_id_venue_statuses_id_fk" FOREIGN KEY ("status_id") REFERENCES "public"."venue_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venues" ADD CONSTRAINT "venues_approved_by_users_id_fk" FOREIGN KEY ("approved_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venues" ADD CONSTRAINT "venues_cancellation_policy_type_id_cancellation_policy_types_id_fk" FOREIGN KEY ("cancellation_policy_type_id") REFERENCES "public"."cancellation_policy_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venues" ADD CONSTRAINT "venues_subscription_plan_id_subscription_plan_types_id_fk" FOREIGN KEY ("subscription_plan_id") REFERENCES "public"."subscription_plan_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_images" ADD CONSTRAINT "court_images_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_images" ADD CONSTRAINT "court_images_uploaded_by_users_id_fk" FOREIGN KEY ("uploaded_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courts" ADD CONSTRAINT "courts_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courts" ADD CONSTRAINT "courts_sport_type_id_sport_types_id_fk" FOREIGN KEY ("sport_type_id") REFERENCES "public"."sport_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courts" ADD CONSTRAINT "courts_surface_type_id_surface_types_id_fk" FOREIGN KEY ("surface_type_id") REFERENCES "public"."surface_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "courts" ADD CONSTRAINT "courts_status_id_court_statuses_id_fk" FOREIGN KEY ("status_id") REFERENCES "public"."court_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "sport_types" ADD CONSTRAINT "sport_types_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_blocked_slots" ADD CONSTRAINT "court_blocked_slots_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_blocked_slots" ADD CONSTRAINT "court_blocked_slots_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_pricing_slots" ADD CONSTRAINT "court_pricing_slots_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_pricing_slots" ADD CONSTRAINT "court_pricing_slots_pricing_label_id_pricing_labels_id_fk" FOREIGN KEY ("pricing_label_id") REFERENCES "public"."pricing_labels"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_schedule_overrides" ADD CONSTRAINT "court_schedule_overrides_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_schedule_overrides" ADD CONSTRAINT "court_schedule_overrides_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "court_weekly_availability" ADD CONSTRAINT "court_weekly_availability_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "promo_codes" ADD CONSTRAINT "promo_codes_promo_type_id_promo_code_types_id_fk" FOREIGN KEY ("promo_type_id") REFERENCES "public"."promo_code_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "promo_codes" ADD CONSTRAINT "promo_codes_applicable_to_id_promo_applicable_to_id_fk" FOREIGN KEY ("applicable_to_id") REFERENCES "public"."promo_applicable_to"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "promo_codes" ADD CONSTRAINT "promo_codes_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "booking_slots" ADD CONSTRAINT "booking_slots_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "booking_slots" ADD CONSTRAINT "booking_slots_pricing_slot_id_court_pricing_slots_id_fk" FOREIGN KEY ("pricing_slot_id") REFERENCES "public"."court_pricing_slots"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "booking_status_history" ADD CONSTRAINT "booking_status_history_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "booking_status_history" ADD CONSTRAINT "booking_status_history_old_status_id_booking_statuses_id_fk" FOREIGN KEY ("old_status_id") REFERENCES "public"."booking_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "booking_status_history" ADD CONSTRAINT "booking_status_history_new_status_id_booking_statuses_id_fk" FOREIGN KEY ("new_status_id") REFERENCES "public"."booking_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "booking_status_history" ADD CONSTRAINT "booking_status_history_changed_by_users_id_fk" FOREIGN KEY ("changed_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_payment_method_type_id_payment_method_types_id_fk" FOREIGN KEY ("payment_method_type_id") REFERENCES "public"."payment_method_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_status_id_booking_statuses_id_fk" FOREIGN KEY ("status_id") REFERENCES "public"."booking_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_cancelled_by_type_id_cancellation_by_types_id_fk" FOREIGN KEY ("cancelled_by_type_id") REFERENCES "public"."cancellation_by_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_cancelled_by_user_id_users_id_fk" FOREIGN KEY ("cancelled_by_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_promo_code_id_promo_codes_id_fk" FOREIGN KEY ("promo_code_id") REFERENCES "public"."promo_codes"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payments" ADD CONSTRAINT "payments_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payments" ADD CONSTRAINT "payments_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payments" ADD CONSTRAINT "payments_payment_method_type_id_payment_method_types_id_fk" FOREIGN KEY ("payment_method_type_id") REFERENCES "public"."payment_method_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payments" ADD CONSTRAINT "payments_status_id_payment_statuses_id_fk" FOREIGN KEY ("status_id") REFERENCES "public"."payment_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payments" ADD CONSTRAINT "payments_cash_confirmed_by_users_id_fk" FOREIGN KEY ("cash_confirmed_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_payment_id_payments_id_fk" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_issued_by_users_id_fk" FOREIGN KEY ("issued_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "saved_payment_methods" ADD CONSTRAINT "saved_payment_methods_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "saved_payment_methods" ADD CONSTRAINT "saved_payment_methods_payment_method_type_id_payment_method_types_id_fk" FOREIGN KEY ("payment_method_type_id") REFERENCES "public"."payment_method_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "milestone_definitions" ADD CONSTRAINT "milestone_definitions_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "points_ledger" ADD CONSTRAINT "points_ledger_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "points_ledger" ADD CONSTRAINT "points_ledger_transaction_type_id_points_transaction_types_id_fk" FOREIGN KEY ("transaction_type_id") REFERENCES "public"."points_transaction_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "points_ledger" ADD CONSTRAINT "points_ledger_reward_action_type_id_reward_action_types_id_fk" FOREIGN KEY ("reward_action_type_id") REFERENCES "public"."reward_action_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "points_ledger" ADD CONSTRAINT "points_ledger_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_milestone_achievements" ADD CONSTRAINT "user_milestone_achievements_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_milestone_achievements" ADD CONSTRAINT "user_milestone_achievements_milestone_id_milestone_definitions_id_fk" FOREIGN KEY ("milestone_id") REFERENCES "public"."milestone_definitions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_milestone_achievements" ADD CONSTRAINT "user_milestone_achievements_points_ledger_id_points_ledger_id_fk" FOREIGN KEY ("points_ledger_id") REFERENCES "public"."points_ledger"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_points_summary" ADD CONSTRAINT "user_points_summary_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referrer_user_id_users_id_fk" FOREIGN KEY ("referrer_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referred_user_id_users_id_fk" FOREIGN KEY ("referred_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_first_booking_id_bookings_id_fk" FOREIGN KEY ("first_booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referrer_points_ledger_id_points_ledger_id_fk" FOREIGN KEY ("referrer_points_ledger_id") REFERENCES "public"."points_ledger"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referred_points_ledger_id_points_ledger_id_fk" FOREIGN KEY ("referred_points_ledger_id") REFERENCES "public"."points_ledger"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "promo_code_usages" ADD CONSTRAINT "promo_code_usages_promo_id_promo_codes_id_fk" FOREIGN KEY ("promo_id") REFERENCES "public"."promo_codes"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "promo_code_usages" ADD CONSTRAINT "promo_code_usages_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "promo_code_usages" ADD CONSTRAINT "promo_code_usages_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "review_photos" ADD CONSTRAINT "review_photos_review_id_reviews_id_fk" FOREIGN KEY ("review_id") REFERENCES "public"."reviews"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "review_reports" ADD CONSTRAINT "review_reports_review_id_reviews_id_fk" FOREIGN KEY ("review_id") REFERENCES "public"."reviews"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "review_reports" ADD CONSTRAINT "review_reports_reported_by_users_id_fk" FOREIGN KEY ("reported_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "review_reports" ADD CONSTRAINT "review_reports_resolved_by_users_id_fk" FOREIGN KEY ("resolved_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "conversation_participants" ADD CONSTRAINT "conversation_participants_conversation_id_conversations_id_fk" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "conversation_participants" ADD CONSTRAINT "conversation_participants_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_conversation_type_id_conversation_types_id_fk" FOREIGN KEY ("conversation_type_id") REFERENCES "public"."conversation_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "messages" ADD CONSTRAINT "messages_conversation_id_conversations_id_fk" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "messages" ADD CONSTRAINT "messages_sender_id_users_id_fk" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "messages" ADD CONSTRAINT "messages_sender_type_id_message_sender_types_id_fk" FOREIGN KEY ("sender_type_id") REFERENCES "public"."message_sender_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "messages" ADD CONSTRAINT "messages_message_type_id_message_types_id_fk" FOREIGN KEY ("message_type_id") REFERENCES "public"."message_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_auto_replies" ADD CONSTRAINT "owner_auto_replies_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_blocks" ADD CONSTRAINT "user_blocks_blocker_id_users_id_fk" FOREIGN KEY ("blocker_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_blocks" ADD CONSTRAINT "user_blocks_blocked_id_users_id_fk" FOREIGN KEY ("blocked_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ai_chat_messages" ADD CONSTRAINT "ai_chat_messages_session_id_ai_chat_sessions_id_fk" FOREIGN KEY ("session_id") REFERENCES "public"."ai_chat_sessions"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ai_chat_messages" ADD CONSTRAINT "ai_chat_messages_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ai_chat_sessions" ADD CONSTRAINT "ai_chat_sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ai_chat_sessions" ADD CONSTRAINT "ai_chat_sessions_language_id_languages_id_fk" FOREIGN KEY ("language_id") REFERENCES "public"."languages"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ai_knowledge_base" ADD CONSTRAINT "ai_knowledge_base_updated_by_users_id_fk" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "speech_transcription_logs" ADD CONSTRAINT "speech_transcription_logs_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "speech_transcription_logs" ADD CONSTRAINT "speech_transcription_logs_ai_message_id_ai_chat_messages_id_fk" FOREIGN KEY ("ai_message_id") REFERENCES "public"."ai_chat_messages"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_preferences" ADD CONSTRAINT "notification_preferences_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_preferences" ADD CONSTRAINT "notification_preferences_event_type_id_notification_event_types_id_fk" FOREIGN KEY ("event_type_id") REFERENCES "public"."notification_event_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_preferences" ADD CONSTRAINT "notification_preferences_channel_id_notification_channels_id_fk" FOREIGN KEY ("channel_id") REFERENCES "public"."notification_channels"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_templates" ADD CONSTRAINT "notification_templates_event_type_id_notification_event_types_id_fk" FOREIGN KEY ("event_type_id") REFERENCES "public"."notification_event_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_templates" ADD CONSTRAINT "notification_templates_channel_id_notification_channels_id_fk" FOREIGN KEY ("channel_id") REFERENCES "public"."notification_channels"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_templates" ADD CONSTRAINT "notification_templates_language_id_languages_id_fk" FOREIGN KEY ("language_id") REFERENCES "public"."languages"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_templates" ADD CONSTRAINT "notification_templates_updated_by_users_id_fk" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_event_type_id_notification_event_types_id_fk" FOREIGN KEY ("event_type_id") REFERENCES "public"."notification_event_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_channel_id_notification_channels_id_fk" FOREIGN KEY ("channel_id") REFERENCES "public"."notification_channels"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_participants" ADD CONSTRAINT "find_player_participants_post_id_find_player_posts_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."find_player_posts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_participants" ADD CONSTRAINT "find_player_participants_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_participants" ADD CONSTRAINT "find_player_participants_payment_id_payments_id_fk" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_posts" ADD CONSTRAINT "find_player_posts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_posts" ADD CONSTRAINT "find_player_posts_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_posts" ADD CONSTRAINT "find_player_posts_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_posts" ADD CONSTRAINT "find_player_posts_sport_type_id_sport_types_id_fk" FOREIGN KEY ("sport_type_id") REFERENCES "public"."sport_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_posts" ADD CONSTRAINT "find_player_posts_skill_level_id_find_player_skill_levels_id_fk" FOREIGN KEY ("skill_level_id") REFERENCES "public"."find_player_skill_levels"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "find_player_posts" ADD CONSTRAINT "find_player_posts_status_id_find_player_post_statuses_id_fk" FOREIGN KEY ("status_id") REFERENCES "public"."find_player_post_statuses"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "waitlist_entries" ADD CONSTRAINT "waitlist_entries_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "waitlist_entries" ADD CONSTRAINT "waitlist_entries_court_id_courts_id_fk" FOREIGN KEY ("court_id") REFERENCES "public"."courts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "waitlist_entries" ADD CONSTRAINT "waitlist_entries_saved_payment_method_id_saved_payment_methods_id_fk" FOREIGN KEY ("saved_payment_method_id") REFERENCES "public"."saved_payment_methods"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "waitlist_entries" ADD CONSTRAINT "waitlist_entries_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "fraud_flags" ADD CONSTRAINT "fraud_flags_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "fraud_flags" ADD CONSTRAINT "fraud_flags_flag_type_id_fraud_flag_types_id_fk" FOREIGN KEY ("flag_type_id") REFERENCES "public"."fraud_flag_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "fraud_flags" ADD CONSTRAINT "fraud_flags_reviewed_by_users_id_fk" FOREIGN KEY ("reviewed_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_log_type_id_log_types_id_fk" FOREIGN KEY ("log_type_id") REFERENCES "public"."log_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_target_user_id_users_id_fk" FOREIGN KEY ("target_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "security_logs" ADD CONSTRAINT "security_logs_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commission_rates" ADD CONSTRAINT "commission_rates_plan_id_subscription_plan_types_id_fk" FOREIGN KEY ("plan_id") REFERENCES "public"."subscription_plan_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commission_rates" ADD CONSTRAINT "commission_rates_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "commission_rates" ADD CONSTRAINT "commission_rates_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_subscriptions" ADD CONSTRAINT "owner_subscriptions_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_subscriptions" ADD CONSTRAINT "owner_subscriptions_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_subscriptions" ADD CONSTRAINT "owner_subscriptions_plan_id_subscription_plan_types_id_fk" FOREIGN KEY ("plan_id") REFERENCES "public"."subscription_plan_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_subscriptions" ADD CONSTRAINT "owner_subscriptions_payment_id_payments_id_fk" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "system_settings" ADD CONSTRAINT "system_settings_updated_by_users_id_fk" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "featured_venue_purchases" ADD CONSTRAINT "featured_venue_purchases_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "featured_venue_purchases" ADD CONSTRAINT "featured_venue_purchases_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "featured_venue_purchases" ADD CONSTRAINT "featured_venue_purchases_payment_id_payments_id_fk" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "featured_venue_purchases" ADD CONSTRAINT "featured_venue_purchases_cancelled_by_users_id_fk" FOREIGN KEY ("cancelled_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_payouts" ADD CONSTRAINT "owner_payouts_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_payouts" ADD CONSTRAINT "owner_payouts_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_payouts" ADD CONSTRAINT "owner_payouts_booking_id_bookings_id_fk" FOREIGN KEY ("booking_id") REFERENCES "public"."bookings"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_payouts" ADD CONSTRAINT "owner_payouts_payment_id_payments_id_fk" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "owner_payouts" ADD CONSTRAINT "owner_payouts_payout_batch_id_payout_batches_id_fk" FOREIGN KEY ("payout_batch_id") REFERENCES "public"."payout_batches"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payout_batches" ADD CONSTRAINT "payout_batches_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payout_batches" ADD CONSTRAINT "payout_batches_approved_by_users_id_fk" FOREIGN KEY ("approved_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payout_batches" ADD CONSTRAINT "payout_batches_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "subscription_invoices" ADD CONSTRAINT "subscription_invoices_subscription_id_owner_subscriptions_id_fk" FOREIGN KEY ("subscription_id") REFERENCES "public"."owner_subscriptions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "subscription_invoices" ADD CONSTRAINT "subscription_invoices_owner_id_users_id_fk" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "subscription_invoices" ADD CONSTRAINT "subscription_invoices_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "subscription_invoices" ADD CONSTRAINT "subscription_invoices_payment_id_payments_id_fk" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ai_usage_daily" ADD CONSTRAINT "ai_usage_daily_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "message_rate_limit_buckets" ADD CONSTRAINT "message_rate_limit_buckets_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ai_model_configs" ADD CONSTRAINT "ai_model_configs_updated_by_users_id_fk" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "search_analytics" ADD CONSTRAINT "search_analytics_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "search_analytics" ADD CONSTRAINT "search_analytics_sport_type_id_sport_types_id_fk" FOREIGN KEY ("sport_type_id") REFERENCES "public"."sport_types"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "search_analytics" ADD CONSTRAINT "search_analytics_clicked_venue_id_venues_id_fk" FOREIGN KEY ("clicked_venue_id") REFERENCES "public"."venues"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "venue_view_counts" ADD CONSTRAINT "venue_view_counts_venue_id_venues_id_fk" FOREIGN KEY ("venue_id") REFERENCES "public"."venues"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "idx_login_attempts_user_id" ON "login_attempts" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_login_attempts_ip" ON "login_attempts" USING btree ("ip_address");--> statement-breakpoint
CREATE INDEX "idx_login_attempts_created_at" ON "login_attempts" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "idx_otp_identifier" ON "otp_records" USING btree ("identifier","purpose") WHERE is_used = false;--> statement-breakpoint
CREATE INDEX "idx_otp_expires_at" ON "otp_records" USING btree ("expires_at");--> statement-breakpoint
CREATE INDEX "idx_devices_user_id" ON "user_devices" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_devices_fingerprint" ON "user_devices" USING btree ("device_fingerprint");--> statement-breakpoint
CREATE INDEX "idx_sessions_user_id" ON "user_sessions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_sessions_token_hash" ON "user_sessions" USING btree ("token_hash");--> statement-breakpoint
CREATE INDEX "idx_sessions_expires_at" ON "user_sessions" USING btree ("expires_at");--> statement-breakpoint
CREATE INDEX "idx_users_email" ON "users" USING btree ("email");--> statement-breakpoint
CREATE INDEX "idx_users_phone" ON "users" USING btree ("phone_number");--> statement-breakpoint
CREATE INDEX "idx_users_role" ON "users" USING btree ("role_id");--> statement-breakpoint
CREATE INDEX "idx_users_referral_code" ON "users" USING btree ("referral_code");--> statement-breakpoint
CREATE INDEX "idx_users_city" ON "users" USING btree ("city");--> statement-breakpoint
CREATE INDEX "idx_users_deleted_at" ON "users" USING btree ("deleted_at") WHERE deleted_at IS NULL;--> statement-breakpoint
CREATE INDEX "idx_venues_owner_id" ON "venues" USING btree ("owner_id");--> statement-breakpoint
CREATE INDEX "idx_venues_status_id" ON "venues" USING btree ("status_id");--> statement-breakpoint
CREATE INDEX "idx_venues_city" ON "venues" USING btree ("city");--> statement-breakpoint
CREATE INDEX "idx_venues_rating" ON "venues" USING btree ("average_rating");--> statement-breakpoint
CREATE INDEX "idx_venues_featured" ON "venues" USING btree ("is_featured") WHERE is_featured = true;--> statement-breakpoint
CREATE INDEX "idx_venues_status_city" ON "venues" USING btree ("status_id","city");--> statement-breakpoint
CREATE INDEX "idx_courts_venue_id" ON "courts" USING btree ("venue_id");--> statement-breakpoint
CREATE INDEX "idx_courts_sport_type_id" ON "courts" USING btree ("sport_type_id");--> statement-breakpoint
CREATE INDEX "idx_courts_status_id" ON "courts" USING btree ("status_id");--> statement-breakpoint
CREATE INDEX "idx_courts_venue_sport" ON "courts" USING btree ("venue_id","sport_type_id");--> statement-breakpoint
CREATE INDEX "idx_blocked_slots_court_date" ON "court_blocked_slots" USING btree ("court_id","block_date");--> statement-breakpoint
CREATE INDEX "idx_pricing_court_day" ON "court_pricing_slots" USING btree ("court_id","day_of_week") WHERE is_active = true;--> statement-breakpoint
CREATE INDEX "idx_promo_code" ON "promo_codes" USING btree ("code");--> statement-breakpoint
CREATE INDEX "idx_promo_active" ON "promo_codes" USING btree ("is_active","start_date","end_date");--> statement-breakpoint
CREATE UNIQUE INDEX "uq_booking_slot" ON "booking_slots" USING btree ("booking_id","slot_start");--> statement-breakpoint
CREATE INDEX "idx_bookings_user_id" ON "bookings" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_bookings_court_date" ON "bookings" USING btree ("court_id","booking_date");--> statement-breakpoint
CREATE INDEX "idx_bookings_venue_id" ON "bookings" USING btree ("venue_id");--> statement-breakpoint
CREATE INDEX "idx_bookings_status_id" ON "bookings" USING btree ("status_id");--> statement-breakpoint
CREATE INDEX "idx_bookings_confirmed_at" ON "bookings" USING btree ("confirmed_at");--> statement-breakpoint
CREATE INDEX "idx_bookings_reservation_expires" ON "bookings" USING btree ("reservation_expires_at");--> statement-breakpoint
CREATE INDEX "idx_payments_booking_id" ON "payments" USING btree ("booking_id");--> statement-breakpoint
CREATE INDEX "idx_payments_user_id" ON "payments" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_payments_gateway_txn_id" ON "payments" USING btree ("gateway_transaction_id");--> statement-breakpoint
CREATE INDEX "idx_payments_status_id" ON "payments" USING btree ("status_id");--> statement-breakpoint
CREATE INDEX "idx_points_ledger_user_id" ON "points_ledger" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_points_ledger_expires_at" ON "points_ledger" USING btree ("expires_at") WHERE expires_at IS NOT NULL;--> statement-breakpoint
CREATE INDEX "idx_points_ledger_reference" ON "points_ledger" USING btree ("reference_type","reference_id");--> statement-breakpoint
CREATE INDEX "idx_messages_conversation_id" ON "messages" USING btree ("conversation_id","created_at");--> statement-breakpoint
CREATE INDEX "idx_ai_sessions_user_id" ON "ai_chat_sessions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_ai_sessions_last_active" ON "ai_chat_sessions" USING btree ("last_active_at");--> statement-breakpoint
CREATE INDEX "idx_notifications_user_id" ON "notifications" USING btree ("user_id","created_at");--> statement-breakpoint
CREATE INDEX "idx_notifications_status" ON "notifications" USING btree ("status");--> statement-breakpoint
CREATE INDEX "idx_notifications_scheduled" ON "notifications" USING btree ("scheduled_for");--> statement-breakpoint
CREATE INDEX "idx_waitlist_court_slot" ON "waitlist_entries" USING btree ("court_id","booking_date","start_time","queue_position");--> statement-breakpoint
CREATE INDEX "idx_audit_logs_user_id" ON "audit_logs" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_audit_logs_action" ON "audit_logs" USING btree ("action");--> statement-breakpoint
CREATE INDEX "idx_audit_logs_resource" ON "audit_logs" USING btree ("resource_type","resource_id");--> statement-breakpoint
CREATE INDEX "idx_audit_logs_created_at" ON "audit_logs" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "idx_security_logs_user_id" ON "security_logs" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "idx_security_logs_ip" ON "security_logs" USING btree ("ip_address");--> statement-breakpoint
CREATE INDEX "idx_security_logs_created_at" ON "security_logs" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "idx_owner_payouts_owner_id" ON "owner_payouts" USING btree ("owner_id","status");--> statement-breakpoint
CREATE INDEX "idx_owner_payouts_booking_id" ON "owner_payouts" USING btree ("booking_id");--> statement-breakpoint
CREATE INDEX "idx_owner_payouts_batch_id" ON "owner_payouts" USING btree ("payout_batch_id");--> statement-breakpoint
CREATE INDEX "idx_ai_usage_user_date" ON "ai_usage_daily" USING btree ("user_id","usage_date");--> statement-breakpoint
CREATE INDEX "idx_search_analytics_date" ON "search_analytics" USING btree ("search_date");