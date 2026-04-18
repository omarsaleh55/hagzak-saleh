import express from 'express';
import path from 'path';
import usersRouter from './modules/users/users.routes';
import authRouter from './modules/auth/auth.routes';
import { errorHandler, notFoundHandler } from './shared/middleware/errorHandler.middleware';

const app = express();

app.use(express.json());
app.use('/dev', express.static(path.join(__dirname, '..', 'public')));

app.get('/health', (_req, res) => res.json({ status: 'ok' }));
app.use('/api/v1/users', usersRouter);
app.use('/api/v1/auth', authRouter);

app.use(notFoundHandler);
app.use(errorHandler);

export default app;
