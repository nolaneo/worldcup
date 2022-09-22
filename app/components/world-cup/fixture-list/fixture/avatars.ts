import { CountryCode } from '../../../../services/api';
import Component from '@glimmer/component';
import Sweepstakes, { Player } from 'worldcup/services/sweepstakes';
import { inject as service } from '@ember/service';

interface Args {
  countryCode: CountryCode;
}

export default class WorldCupFixtureListFixtureAvatarsComponent extends Component<Args> {
  @service declare sweepstakes: Sweepstakes;

  get players(): Array<Player> {
    return this.sweepstakes.countryMapping[this.args.countryCode];
  }
}
