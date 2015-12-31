import SessionRoutes from './routes/session';

// Configuration for development and testing
export default function() {
  this.namespace = 'api';
}

// Configuration for tests only
export function testConfig() {
  SessionRoutes.call(this);
}
