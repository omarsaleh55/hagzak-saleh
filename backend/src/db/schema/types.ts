import { customType } from 'drizzle-orm/pg-core';

export const geography = customType<{ data: string }>({
  dataType() {
    return 'geography(POINT, 4326)';
  },
});

export const tsvector = customType<{ data: string }>({
  dataType() {
    return 'tsvector';
  },
});

export const vector = customType<{ data: number[]; config: { dimensions: number } }>({
  dataType(config) {
    return `vector(${config?.dimensions ?? 1536})`;
  },
});
