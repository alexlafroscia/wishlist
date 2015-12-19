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

  // What we need to do here is get the value for the access token and make sure
  // that it is the same as the value in the localStorage property.  If you look
  // at the code above these tests, you'll see a `setup` and `teardown` method
  // that do some stuff to preserve the initial value in localStorage and then
  // set a temporary value that will be used during each test.  This setup and
  // teardown run before and after every test, so we can make sure that the
  // initial state for each test is identical. What we want to do here is get
  // the value of the `accessToken` property, and then compare is to the initial
  // value that is set above to ensure that it works correctly.
  //
  // As with all Ember properties, you can get it using
  // `service.get('accessToken')
});

test('it sets the value in localStorage when setting the accessToken property to a value', function(assert) {
  assert.expect(1);
  // Set the variable "service" to an instance of our Session Service
  const service = this.subject();

  // Set the value of the `accessToken` property to some new value
  // service.set('accessToken', 'my-new-value');

  // Check that the value in localStorage matches the value that you just set by
  // retrieving the actual localStorage value and comparing it to the one that
  // we just set
});

test('it clears the value if localStorage when the accessToken property is set to `null`', function(assert) {
  assert.expect(1);
  const service = this.subject();

  // I'm going to let this one be a little more open-ended.  It will be pretty
  // similar to the test above; when we set the property to `null` (or anything
  // else that Ember considers "empty", like `undefined` or an empty string), we
  // should clear out the value from localStorage entirely.  After setting the
  // value to `null`, we'll want to "get" it again and make sure that it is now
  // `undefined`.
});
