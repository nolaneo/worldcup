import Api, {
  GroupStandingWireFormat,
  TeamStanding,
  CountryCode,
} from '../../services/api';
import Component from '@glimmer/component';
import Sweepstakes, { Player } from 'worldcup/services/sweepstakes';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

interface Args {
  standings: Array<GroupStandingWireFormat>;
}

interface PlayerStanding {
  drawn: number;
  goalDifference: number;
  goalsAgainst: number;
  goalsFor: number;
  isLive: boolean;
  lost: number;
  played: number;
  points: number;
  won: number;
  player: Player;
}

export default class WorldCupStandingsComponent extends Component<Args> {
  @service declare sweepstakes: Sweepstakes;
  @tracked teamStandings: Partial<Record<CountryCode, TeamStanding>> = {};
  @service declare api: Api;

  constructor(owner: unknown, args: Args) {
    super(owner, args);

    this.api.model.standings
      .flatMap((groupStanding) => groupStanding.items)
      .forEach((teamStanding) => {
        this.teamStandings[teamStanding.team.countryCode] = teamStanding;
      });
  }

  get totals(): Array<PlayerStanding> {
    return this.sweepstakes.players.map((player: Player) => {
      let playerStanding = {
        drawn: 0,
        goalDifference: 0,
        goalsAgainst: 0,
        goalsFor: 0,
        isLive: false,
        lost: 0,
        played: 0,
        points: 0,
        won: 0,
        player: player,
      };
      player.teams.forEach((countryCode) => {
        let teamStanding = this.teamStandings[countryCode];
        if (teamStanding) {
          playerStanding.played += teamStanding.played;
          playerStanding.points += teamStanding.points;
          playerStanding.drawn += teamStanding.drawn;
          playerStanding.goalDifference += teamStanding.goalDifference;
          playerStanding.goalsAgainst += teamStanding.goalsAgainst;
          playerStanding.goalsFor += teamStanding.goalsFor;
          playerStanding.lost += teamStanding.lost;
          playerStanding.won += teamStanding.won;
          playerStanding.isLive ||= teamStanding.isLive;
        }
      });
      return playerStanding;
    });
  }

  get orderedTotals(): Array<PlayerStanding> {
    return this.totals.sort((a, b) => {
      if (a.points < b.points) return 1;
      if (a.points > b.points) return -1;

      if (a.goalDifference < b.goalDifference) return 1;
      if (a.goalDifference > b.goalDifference) return -1;

      if (a.goalsFor < b.goalsFor) return 1;
      if (a.goalsFor > b.goalsFor) return -1;

      if (a.won < b.won) return 1;
      if (a.won > b.won) return -1;

      // Need to update this to do head to head match up if this is still equal
      return 0;
    });
  }
}
