import Ember from 'ember';
import AjaxService from 'ember-ajax/services/ajax';

const { computed, inject, isPresent } = Ember;
const { service } = inject;

export default AjaxService.extend({
  session: service(),
  headers: computed('session.accessToken', {
    get() {
      const headers = {};
      const authToken = this.get('session.accessToken');
      if (isPresent(authToken)) {
        headers.Authorization = `Token ${authToken}`;
      }
      return headers;
    }
  })
});
