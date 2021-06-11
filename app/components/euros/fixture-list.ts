import { FixtureWireformat } from './../../services/api';
import Component from '@glimmer/component';

interface Args {
  fixtures: Array<FixtureWireformat>;
}

export default class EurosFixtureList extends Component<Args> {
  onlyShowRecentlyCompleted: boolean = true;

  get completedFixtures() {
    return this.args.fixtures
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
    return this.args.fixtures
      .filter((fixture) => fixture.status === 'LIVE')
      .sort((a, b) => {
        return (
          new Date(a.kickOffTime.dateTime).getTime() -
          new Date(b.kickOffTime.dateTime).getTime()
        );
      });
  }

  get upcomingFixtures() {
    return this.args.fixtures
      .filter((fixture) => fixture.status === 'UPCOMING')
      .sort((a, b) => {
        return (
          new Date(a.kickOffTime.dateTime).getTime() -
          new Date(b.kickOffTime.dateTime).getTime()
        );
      });
  }
}
