/* globals localStorage */
import { moduleFor, test } from 'ember-qunit';
import FakeServer, { stubRequest } from 'ember-cli-fake-server';

let previousValue = null;

moduleFor('service:session', 'Unit | Service | session', {
  needs: ['service:ajax'],
  setup() {
    previousValue = localStorage.getItem('accessToken');
    localStorage.setItem('accessToken', 'abcd');
    FakeServer.start();
  },
  teardown() {
    localStorage.setItem('accessToken', previousValue);
    previousValue = null;
    FakeServer.stop();
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
  assert.expect(4);

  const email = 'current-user@example.com';
  const password = 'foobar';
  const accessToken = 'abcde';

  stubRequest('post', '/api/session', function(request) {
    const { requestBody } = request;
    const body = JSON.parse(requestBody);
    assert.equal(body.email, email, 'Sent email field correctly');
    assert.equal(body.password, password, 'Sent password field correctly');
    request.ok({ authToken: accessToken });
  });

  const service = this.subject({
    accessToken: ''
  });
  return service.login(email, password)
    .catch(function() {
      assert.ok(false, 'Login was successful');
    })
    .then(function() {
      assert.ok(true, 'Login was successful');
      assert.equal(service.get('accessToken'), accessToken, 'Set the access token');
    });
});

test('login returns a rejected promise if it failed', function(assert) {
  assert.expect(1);

  stubRequest('post', '/api/session', function(request) {
    request.error();
  });

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

  const service = this.subject({ accessToken: '' });
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

test('login rejected if email is not a String', function(assert) {
  assert.expect(1);
  const service = this.subject({ accessToken: '' });
  return service.login(12345, 'foobar')
    .then(function() {
      assert.ok(false, 'Promise should have been rejected');
    })
    .catch(function(data) {
      const { errors } = data;
      const [ error ] = errors;
      assert.equal('Email must be a string', error);
    });
});

test('login rejected if password is not a String', function(assert) {
  assert.expect(1);
  const service = this.subject({ accessToken: '' });
  return service.login('current-user@example.com', 12345)
    .then(function() {
      assert.ok(false, 'Promise should have been rejected');
    })
    .catch(function(data) {
      const { errors } = data;
      const [ error ] = errors;
      assert.equal('Password must be a string', error);
    });
});

test('login can return multiple errors at once', function(assert) {
  assert.expect(1);
  const service = this.subject({ accessToken: '' });
  return service.login(1234, '')
    .then(function() {
      assert.ok(false, 'Promise should have been rejected');
    })
    .catch(function(data) {
      const { errors } = data;
      assert.equal(errors.length, 2, 'Returns two errors');
    });
});
