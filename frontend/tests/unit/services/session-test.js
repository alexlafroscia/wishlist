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
