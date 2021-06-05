import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import Api from 'euros/services/api';
import { taskFor } from 'ember-concurrency-ts';
import Sweepstakes, { Player } from 'euros/services/sweepstakes';
import { data as collegeData } from 'euros/data/college';
import { data as pintmenData } from 'euros/data/pintmen';

type SweepstakesId = 'college' | 'pintmen';
export default class Euros extends Route {
  @service declare api: Api;
  @service declare sweepstakes: Sweepstakes;

  async model(params: { id: SweepstakesId }) {
    if (params.id === 'college') {
      this.sweepstakes.setPlayers(collegeData as Array<Player>);
    }
    if (params.id === 'pintmen') {
      this.sweepstakes.setPlayers(pintmenData as Array<Player>);
    }
    let result = await Promise.all([
      taskFor(this.api.loadStandings).perform(),
      taskFor(this.api.loadFixtures).perform(),
    ]);
    return {
      standings: result[0],
      fixtures: result[1],
    };
  }
}
