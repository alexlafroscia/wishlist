import Ember from 'ember';
import { moduleFor, test } from 'ember-qunit';
import Pretender from 'pretender';

const tokenRegex = /^Token{1}\s(\w*)$/;
const authTokenValue = 'abcd';

moduleFor('service:ajax', 'Unit | Service | ajax', {
  // Specify the other units that are required for this test.
  // needs: ['service:foo']
});

test('it adds the access token if it is available', function(assert) {
  assert.expect(1);

  const server = new Pretender(function() {
    this.get('/api/session', function({ requestHeaders }) {
      const match = tokenRegex.exec(requestHeaders.Authorization);
      const [, authToken] = match;
      assert.equal(authTokenValue, authToken, 'Added correct auth token');
      return [200, {}, JSON.stringify({})];
    });
  });

  const service = this.subject({
    session: Ember.Object.create({ accessToken: authTokenValue })
  });
  return service.request('/api/session')
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

  const service = this.subject({
    session: Ember.Object.create({ accessToken: '' })
  });
  return service.request('/api/session')
    .then(function() {
      server.shutdown();
    });
});
