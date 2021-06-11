import Service from '@ember/service';
import { TaskGenerator, task, dropTask, timeout } from 'ember-concurrency';
import { taskFor } from 'ember-concurrency-ts';

const standingsEndpoint = `https://standings.uefa.com/v1/standings?groupIds=2006438,2006439,2006440,2006441,2006442,2006443`;
const fixturesEnpoint = `https://match.uefa.com/v2/matches?matchId=2024441,2024442,2024443,2024444,2024445,2024446,2024447,2024448,2024449,2024450,2024451,2024452,2024453,2024454,2024455,2024456,2024457,2024458,2024459,2024460,2024461,2024462,2024463,2024464,2024465,2024466,2024467,2024468,2024469,2024470,2024471,2024472,2024473,2024474,2024475,2024476,2024477,2024478,2024479,2024480,2024481,2024482,2024483,2024484,2024485,2024486,2024487,2024488,2024489,2024490,2024491`;
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
  model!: {
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
      standings: result[0] as Array<GroupStandingWireFormat>,
      fixtures: result[1] as Array<FixtureWireformat>,
    };
  }

  @task
  *enqueueRefresh(): TaskGenerator<void> {
    yield timeout(15_000); //15 seconds
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
