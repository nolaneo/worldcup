import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import Api from 'worldcup/services/api';
import { taskFor } from 'ember-concurrency-ts';
import Sweepstakes, { Player } from 'worldcup/services/sweepstakes';

export default class WorldCup extends Route {
  @service declare api: Api;
  @service declare sweepstakes: Sweepstakes;

  async model(params: { id: string }) {
    var players: Player[];
    try {
      let response = await fetch(`/players/${params.id}.json`);
      let loadedData = await response.json();
      players = loadedData.players;
    } catch {
      players = [];
    }

    this.sweepstakes.setPlayers(players);
    await taskFor(this.api.loadModel).perform();
    taskFor(this.api.enqueueRefresh).perform();
    return this.api.model;
  }
}
