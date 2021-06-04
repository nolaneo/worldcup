import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import Api from 'euros/services/api';
import { taskFor } from 'ember-concurrency-ts';

export default class Euros extends Route {
  @service declare api: Api;

  async model() {
    return await taskFor(this.api.loadFixtures).perform();
  }
}
