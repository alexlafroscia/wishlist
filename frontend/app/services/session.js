import Ember from 'ember';

const { Service, computed, isEmpty } = Ember;

export default Service.extend({
  accessToken: computed({
    get() {
      return localStorage.getItem('accessToken');
    },
    set(key, value) {
      if (isEmpty(value)) {
        localStorage.removeItem('accessToken');
        return undefined;
      } else {
        localStorage.setItem('accessToken', value);
        return value;
      }
    }
  })
});
