import EmberRouter from '@ember/routing/router';
import config from 'worldcup/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('worldcup', { path: '/' });
  this.route('worldcup', { path: '/:id' });
});
