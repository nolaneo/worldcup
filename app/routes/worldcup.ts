import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import Api from 'worldcup/services/api';
import { taskFor } from 'ember-concurrency-ts';
import Sweepstakes, { Player } from 'worldcup/services/sweepstakes';
import { data as collegeData } from 'worldcup/data/college';
import { data as pintmenData } from 'worldcup/data/pintmen';
import { data as babb } from 'worldcup/data/babb';
import { data as ashData } from 'worldcup/data/ashbourne';

type SweepstakesId = 'college' | 'pintmen' | 'babb' | 'ashbourne';
export default class WorldCup extends Route {
  @service declare api: Api;
  @service declare sweepstakes: Sweepstakes;

  async model(params: { id: SweepstakesId }) {
    if (params.id === 'college') {
      this.sweepstakes.setPlayers(collegeData as Array<Player>);
    }
    if (params.id === 'pintmen') {
      this.sweepstakes.setPlayers(pintmenData as Array<Player>);
    }
    if (params.id === 'babb') {
      this.sweepstakes.setPlayers(babb as Array<Player>);
    }
    if (params.id === 'ashbourne') {
      this.sweepstakes.setPlayers(ashData as Array<Player>);
    }

    await taskFor(this.api.loadModel).perform();
    taskFor(this.api.enqueueRefresh).perform();
    return this.api.model;
  }
}
