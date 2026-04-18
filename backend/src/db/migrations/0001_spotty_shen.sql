ALTER TABLE "users" ADD COLUMN IF NOT EXISTS "location" geography(POINT, 4326);--> statement-breakpoint
ALTER TABLE "venues" ADD COLUMN IF NOT EXISTS "location" geography(POINT, 4326);--> statement-breakpoint
ALTER TABLE "venues" ADD COLUMN IF NOT EXISTS "search_vector" tsvector;--> statement-breakpoint
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'vector') THEN
    ALTER TABLE "ai_knowledge_base" ADD COLUMN IF NOT EXISTS "embedding_vector" vector(1536);
  END IF;
END $$;
