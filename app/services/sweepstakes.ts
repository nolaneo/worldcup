import { CountryCode } from './api';
import Service from '@ember/service';

export type Player = {
  teams: Array<CountryCode>;
  image: string;
};

export default class Sweepstakes extends Service {
  players!: Array<Player>;
  countryMapping: Record<CountryCode, Array<Player>> = {
    ENG: [],
    DEN: [],
    MKD: [],
    ITA: [],
    RUS: [],
    UKR: [],
    NED: [],
    POL: [],
    WAL: [],
    GER: [],
    CRO: [],
    FIN: [],
    BEL: [],
    SWE: [],
    HUN: [],
    POR: [],
    TUR: [],
    SVK: [],
    FRA: [],
    SUI: [],
    SCO: [],
    ESP: [],
    AUT: [],
    CZE: [],
  };

  setPlayers(players: Array<Player>) {
    this.players = players;

    this.players.forEach((player) => {
      player.teams.forEach((countryCode) => {
        this.countryMapping[countryCode].push(player);
      });
    });
  }
}
