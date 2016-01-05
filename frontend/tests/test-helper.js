/* global QUnit */

import Ember from 'ember';
import resolver from './helpers/resolver';
import {
  setResolver
} from 'ember-qunit';

const { isEmpty } = Ember;

setResolver(resolver);

QUnit.assert.empty = function(value, message) {
  message = message || `Value is a ${typeof value}, not empty`;
  const empty = isEmpty(value);
  this.push(empty, value, empty, message);
};
