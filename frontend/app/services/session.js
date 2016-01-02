import Ember from 'ember';
import ajax from 'ic-ajax';

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
  }),

  /**
   * Get an access token with an email and password.
   *
   * @public
   * @method login
   * @param {String} email
   * @param {String} password
   * @return {Promise} Resolves to current user
   */
  login(email, password) {
    const data = { email, password };
    const options = {
      url: '/api/session',
      dataType: 'json',
      type: 'POST',
      data
    };
    return ajax(options)
      .then((result) => {
        const token = result.authToken;
        this.set('accessToken', token);
      });
  }
});
