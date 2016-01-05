import Ember from 'ember';
import DS from 'ember-data';

const { RSVP, Service, computed, inject, isEmpty } = Ember;
const { PromiseObject } = DS;
const { service } = inject;
const { reject } = RSVP;

export default Service.extend({
  ajax: service(),

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
   * Get the current user
   *
   * @public
   * @property {PromiseObject} currentUser
  */
  currentUser: computed(function() {
    const promise = this.get('ajax').post('/api/session')
      .then(() => {
        // magic
      });
    return PromiseObject.create({ promise });
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
    const errors = [];
    if (isEmpty(email)) {
      errors.push('Email must be provided');
    }
    if (isEmpty(password)) {
      errors.push('Password must be provided');
    }
    if (!(typeof email === 'string' || email instanceof String)) {
      errors.push('Email must be a string');
    }
    if (!(typeof password === 'string' || password instanceof String)) {
      errors.push('Password must be a string');
    }
    if (!isEmpty(errors)) {
      return reject({ errors });
    }
    const data = { email, password };
    const options = {
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify(data)
    };
    return this.get('ajax').post('/api/session', options)
      .then((result) => {
        const token = result.authToken;
        this.set('accessToken', token);
      });
  },

  /**
   * Destroy the user session
   *
   * @public
   * @method logout
   * @return {Promise} Resolves if successfull
   */
  logout() {
    return this.get('ajax').delete('/api/session', { dataType: 'json' })
      .then(() => {
        this.set('accessToken', null);
      });
  }
});
