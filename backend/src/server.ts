import app from './app';
import { config } from './config';
import { connectDatabase } from './config/database';

async function bootstrap() {
  try {
    await connectDatabase();
  } catch (err) {
    console.error('Failed to connect to database:', (err as Error).message);
    process.exit(1);
  }

  app.listen(config.app.port, () => {
    console.info(`Server running on port ${config.app.port} [${config.app.env}]`);
  });
}

void bootstrap();
