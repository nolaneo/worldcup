import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { TaskGenerator, task, dropTask, timeout } from 'ember-concurrency';
import { taskFor } from 'ember-concurrency-ts';

const standingsEndpoint = `https://standings.uefa.com/v1/standings?groupIds=2006438,2006439,2006440,2006441,2006442,2006443`;
const fixturesEnpoint = `https://match.uefa.com/v5/matches?competitionId=17&utcOffset=1&order=ASC&offset=0&fromDate=2022-11-20&toDate=2022-12-18&limit=100`;
const apiKey = `ceeee1a5bb209502c6c438abd8f30aef179ce669bb9288f2d1cf2fa276de03f4`;

export type CountryCode =
  | 'ENG'
  | 'DEN'
  | 'MKD'
  | 'ITA'
  | 'RUS'
  | 'UKR'
  | 'NED'
  | 'POL'
  | 'WAL'
  | 'GER'
  | 'CRO'
  | 'FIN'
  | 'BEL'
  | 'SWE'
  | 'HUN'
  | 'POR'
  | 'TUR'
  | 'SVK'
  | 'FRA'
  | 'SUI'
  | 'SCO'
  | 'ESP'
  | 'AUT'
  | 'CZE';

export interface TeamWireFormat {
  internationalName: string;
  associationLogoUrl: string;
  countryCode: CountryCode;
  isPlaceholder: boolean;
}
export interface FixtureWireformat {
  homeTeam: TeamWireFormat;
  awayTeam: TeamWireFormat;
  kickOffTime: { dateTime: string };
  group: { groupName: string };
  status: 'UPCOMING' | 'LIVE' | 'FINISHED';
  minute?: { normal: number; injury?: number };
  translations?: { phaseName: { EN: string } };
  score?: { total: { away: number; home: number } };
}

export interface TeamStanding {
  drawn: number;
  goalDifference: number;
  goalsAgainst: number;
  goalsFor: number;
  isLive: boolean;
  lost: number;
  played: number;
  points: number;
  won: number;
  team: TeamWireFormat;
}

export interface GroupStandingWireFormat {
  items: Array<TeamStanding>;
}
export default class Api extends Service {
  @tracked model!: {
    standings: Array<GroupStandingWireFormat>;
    fixtures: Array<FixtureWireformat>;
  };

  @dropTask
  *loadModel(): TaskGenerator<void> {
    let result = yield Promise.all([
      taskFor(this.loadStandings).perform(),
      taskFor(this.loadFixtures).perform(),
    ]);
    this.model = {
      standings: [],
      fixtures: [],
    };
    this.model = {
      standings: result[0] as Array<GroupStandingWireFormat>,
      fixtures: result[1] as Array<FixtureWireformat>,
    };
  }

  @task
  *enqueueRefresh(): TaskGenerator<void> {
    yield timeout(10_000); //10 seconds
    yield taskFor(this.loadModel).perform();
    taskFor(this.enqueueRefresh).perform();
  }

  @task
  *loadFixtures(): TaskGenerator<Array<FixtureWireformat>> {
    return yield this.fetch(fixturesEnpoint);
  }

  @task
  *loadStandings(): TaskGenerator<Array<GroupStandingWireFormat>> {
    return yield this.fetch(standingsEndpoint);
  }

  async fetch(endpoint: string) {
    let result = await fetch(endpoint, {
      headers: {
        'x-api-key': apiKey,
      },
    });
    return await result.json();
  }
}
