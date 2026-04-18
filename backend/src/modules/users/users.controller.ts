import type { NextFunction, Request, Response } from 'express';
import * as usersService from './users.service';
import { successResponse } from '../../shared/utils/response';
import type { NewUser } from '../../db/schema';

export async function create(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    // Body is validated by the route middleware before reaching here
    const user = await usersService.createUser(req.body as NewUser);
    successResponse(res, user, 'User created', 201);
  } catch (err) {
    next(err);
  }
}

export async function getAll(_req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const users = await usersService.getAllUsers();
    successResponse(res, users);
  } catch (err) {
    next(err);
  }
}

export async function getById(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const user = await usersService.getUserById(req.params.id);
    successResponse(res, user);
  } catch (err) {
    next(err);
  }
}

export async function update(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    // Body is validated by the route middleware before reaching here
    const user = await usersService.updateUser(req.params.id, req.body as Partial<NewUser>);
    successResponse(res, user, 'User updated');
  } catch (err) {
    next(err);
  }
}

export async function remove(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    await usersService.deleteUser(req.params.id);
    successResponse(res, null, 'User deleted');
  } catch (err) {
    next(err);
  }
}
