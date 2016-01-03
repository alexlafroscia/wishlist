import Ember from 'ember';
import { initialize } from '../../../instance-initializers/ajax-setup';
import { module, test } from 'qunit';
import destroyApp from '../../helpers/destroy-app';
import Pretender from 'pretender';
import ajax from 'ic-ajax';

const tokenRegex = /^Token{1}\s(\w*)$/;
let sessionService;

module('Unit | Instance Initializer | ajax setup', {
  beforeEach() {
    Ember.run(() => {
      this.application = Ember.Application.create();
      this.application.buildInstance();

      sessionService = Ember.Object.create({ accessToken: '' });
      this.application.register('service:session', sessionService);
    });
  },
  afterEach() {
    Ember.run(this.application, 'destroy');
    destroyApp(this.application);
  }
});

test('it adds the access token if it is available', function(assert) {
  assert.expect(1);

  const authTokenValue = 'abcd';
  sessionService.set('accessToken', authTokenValue);
  const server = new Pretender(function() {
    this.get('/api/session', function({ requestHeaders }) {
      const match = tokenRegex.exec(requestHeaders.Authorization);
      const [, authToken] = match;
      assert.equal(authTokenValue, authToken, 'Added correct auth token');
      return [200, {}, JSON.stringify({})];
    });
  });

  initialize(this.application);
  return ajax({ url: '/api/session' })
    .then(function() {
      server.shutdown();
    });
});

test('it does not add the auth header if the token is empty', function(assert) {
  assert.expect(1);

  const server = new Pretender(function() {
    this.get('/api/session', function({ requestHeaders }) {
      assert.empty(requestHeaders.Authorization);
      return [200, {}, JSON.stringify({})];
    });
  });

  initialize(this.application);
  return ajax({ url: '/api/session' })
    .then(function() {
      server.shutdown();
    });
});
