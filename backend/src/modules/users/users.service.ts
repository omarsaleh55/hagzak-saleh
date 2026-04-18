import { eq } from 'drizzle-orm';
import { db } from '../../db';
import { users, type NewUser } from '../../db/schema';
import { NotFoundError, ConflictError } from '../../shared/errors';

export async function createUser(data: NewUser) {
  const existing = await db.query.users.findFirst({ where: eq(users.email, data.email) });
  if (existing) throw new ConflictError('Email already in use');

  const [user] = await db.insert(users).values(data).returning();
  return user;
}

export async function getAllUsers() {
  return db.select().from(users);
}

export async function getUserById(id: string) {
  const user = await db.query.users.findFirst({ where: eq(users.id, id) });
  if (!user) throw new NotFoundError('User');
  return user;
}

export async function updateUser(id: string, data: Partial<NewUser>) {
  const existing = await db.query.users.findFirst({ where: eq(users.id, id) });
  if (!existing) throw new NotFoundError('User');

  const [updated] = await db
    .update(users)
    .set({ ...data, updatedAt: new Date() })
    .where(eq(users.id, id))
    .returning();
  return updated;
}

export async function deleteUser(id: string) {
  const existing = await db.query.users.findFirst({ where: eq(users.id, id) });
  if (!existing) throw new NotFoundError('User');

  await db.delete(users).where(eq(users.id, id));
}
