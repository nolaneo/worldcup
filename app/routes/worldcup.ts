import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import Api from 'worldcup/services/api';
import { taskFor } from 'ember-concurrency-ts';
import Sweepstakes from 'worldcup/services/sweepstakes';
import { data as collegeData } from 'worldcup/data/college';
import { data as pintmenData } from 'worldcup/data/pintmen';
import { data as babb } from 'worldcup/data/babb';
import { data as ashData } from 'worldcup/data/ashbourne';

var fixedData = {
  college: collegeData,
  pintmen: pintmenData,
  babb: babb,
  ashbourne: ashData,
};

export default class WorldCup extends Route {
  @service declare api: Api;
  @service declare sweepstakes: Sweepstakes;

  async model(params: { id: string }) {
    //@ts-ignore
    var players = fixedData[params.id] || null;
    if (players === null) {
      // attempt to load from the file system
      let response = await fetch(`/players/${params.id}.json`);
      let loadedData = await response.json();
      players = loadedData.data;
    }

    this.sweepstakes.setPlayers(players);
    await taskFor(this.api.loadModel).perform();
    taskFor(this.api.enqueueRefresh).perform();
    return this.api.model;
  }
}
