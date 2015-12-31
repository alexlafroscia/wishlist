/* globals localStorage */
import { moduleFor, test } from 'ember-qunit';

let previousValue = null;

moduleFor('service:session', 'Unit | Service | session', {
  setup() {
    previousValue = localStorage.getItem('accessToken');
    localStorage.setItem('accessToken', 'abcd');
  },
  teardown() {
    localStorage.setItem('accessToken', previousValue);
    previousValue = null;
  }
});

test('it gets the value from localStorage when getting the accessToken property', function(assert) {
  assert.expect(1);
  const service = this.subject();
  const valueOfAccessToken = service.get('accessToken');
  assert.equal('abcd', valueOfAccessToken);
});

test('it sets the value in localStorage when setting the accessToken property to a value', function(assert) {
  assert.expect(1);
  const service = this.subject();
  service.set('accessToken', 'potato');
  const valLocalStorage = localStorage.getItem('accessToken');
  assert.equal('potato', valLocalStorage);
});

test('it clears the value if localStorage when the accessToken property is set to `null`', function(assert) {
  assert.expect(1);
  const service = this.subject();
  service.set('accessToken', null);
  const valLocalStorage = localStorage.getItem('accessToken');
  assert.equal(undefined, valLocalStorage);
});

test('can get the login token by logging the user in', function(assert) {
  assert.expect(2);
  const service = this.subject({
    accessToken: ''
  });
  return service.login('current-user@example.com', 'foobar')
    .catch(function() {
      assert.ok(false, 'Login failed');
    })
    .then(function() {
      assert.ok(true, 'Login was successful');
      assert.equal('abcde', service.get('accessToken'), 'Set the access token');
    });
});

test('login returns a rejected promise if it failed', function(assert) {
  // Set up error response for endpoint
  server.get('session', { }, 401);

  assert.expect(1);
  const service = this.subject({
    accessToken: ''
  });
  return service.login('current-user@example.com', 'foobar')
    .then(function() {
      assert.ok(false, 'Promise should have been rejected');
    })
    .catch(function() {
      assert.ok(true, 'Promise was rejected');
    });
});

test('login is rejected if the email is not present', function(assert) {
  assert.expect(1);
  const service = this.subject({
    accessToken: ''
  });
  return service.login('', 'foobar')
    .then(function() {
      assert.ok(false, 'Promise should have been rejected');
    })
    .catch(function(data) {
      const { errors } = data;
      const [ error ] = errors;
      assert.equal('Email must be provided', error);
    });
});

test('login is rejected if the password is not present', function(assert) {
  assert.expect(1);
  const service = this.subject({
    accessToken: ''
  });
  return service.login('current-user@example.com', '')
    .then(function() {
      assert.ok(false, 'Promise should have been rejected');
    })
    .catch(function(data) {
      const { errors } = data;
      const [ error ] = errors;
      assert.equal('Password must be provided', error);
    });
});
