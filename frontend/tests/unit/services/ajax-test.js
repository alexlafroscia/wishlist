import Ember from 'ember';
import { moduleFor, test } from 'ember-qunit';
import FakeServer, { stubRequest } from 'ember-cli-fake-server';

const tokenRegex = /^Token{1}\s(\w*)$/;
const authTokenValue = 'abcd';

moduleFor('service:ajax', 'Unit | Service | ajax', {
  setup() {
    FakeServer.start();
  },
  teardown() {
    FakeServer.stop();
  }
});

test('it adds the access token if it is available', function(assert) {
  assert.expect(1);

  stubRequest('get', '/api/session', function(request) {
    const { requestHeaders } = request;
    const match = tokenRegex.exec(requestHeaders.Authorization);
    const [, authToken] = match;
    assert.equal(authTokenValue, authToken, 'Added correct auth token');
    request.ok();
  });

  const service = this.subject({
    session: Ember.Object.create({ accessToken: authTokenValue })
  });
  return service.request('/api/session');
});

test('it does not add the auth header if the token is empty', function(assert) {
  assert.expect(1);

  stubRequest('get', '/api/session', function(request) {
    const { requestHeaders } = request;
    assert.empty(requestHeaders.Authorization);
    request.ok();
  });

  const service = this.subject({
    session: Ember.Object.create({ accessToken: '' })
  });
  return service.request('/api/session');
});
