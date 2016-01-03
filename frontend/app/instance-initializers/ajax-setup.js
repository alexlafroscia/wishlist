import Ember from 'ember';

const { $, isPresent } = Ember;

export function initialize(application) {
  const sessionService = application.resolveRegistration('service:session');
  $.ajaxPrefilter(function(options, originalOptions, xhr) {
    const token = sessionService.get('accessToken');
    if (isPresent(token)) {
      xhr.setRequestHeader('Authorization', `Token ${token}`);
    }
  });
}

export default {
  name: 'ajax-setup',
  initialize
};
