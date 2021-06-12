import Api, { FixtureWireformat } from './../../services/api';
import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';

interface Args {
  fixtures: Array<FixtureWireformat>;
}
export default class EurosFixtureList extends Component<Args> {
  @service declare api: Api;

  @tracked onlyShowRecentlyCompleted: boolean = true;

  @action toggleRecentResultsList() {
    this.onlyShowRecentlyCompleted = !this.onlyShowRecentlyCompleted;
  }

  get completedFixtures() {
    return this.api.model.fixtures
      .filter((fixture) => {
        return (
          fixture.status === 'FINISHED' &&
          (!this.onlyShowRecentlyCompleted ||
            this.fixtureFromLast24Hours(new Date(fixture.kickOffTime.dateTime)))
        );
      })
      .sort((a, b) => {
        return (
          new Date(a.kickOffTime.dateTime).getTime() -
          new Date(b.kickOffTime.dateTime).getTime()
        );
      });
  }

  fixtureFromLast24Hours(date: Date): boolean {
    let now = Date.now();
    let one_day_ago = now - 1000 * 60 * 60 * 24;
    return date.getTime() > one_day_ago;
  }

  get liveFixtures() {
    return this.api.model.fixtures
      .filter((fixture) => fixture.status === 'LIVE')
      .sort((a, b) => {
        return (
          new Date(a.kickOffTime.dateTime).getTime() -
          new Date(b.kickOffTime.dateTime).getTime()
        );
      });
  }

  get upcomingFixtures() {
    return this.api.model.fixtures
      .filter((fixture) => fixture.status === 'UPCOMING')
      .sort((a, b) => {
        return (
          new Date(a.kickOffTime.dateTime).getTime() -
          new Date(b.kickOffTime.dateTime).getTime()
        );
      });
  }
}
