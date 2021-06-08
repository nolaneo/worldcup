import { FixtureWireformat } from './../../services/api';
import Component from '@glimmer/component';

interface Args {
  fixtures: Array<FixtureWireformat>;
}

export default class EurosFixtureList extends Component<Args> {
  get upcomingFixtures() {
    return this.args.fixtures
      .filter(
        (fixture) => fixture.status === 'UPCOMING' || fixture.status === 'LIVE'
      )
      .sort((a, b) => {
        return (
          new Date(a.kickOffTime.dateTime).getTime() -
          new Date(b.kickOffTime.dateTime).getTime()
        );
      });
  }
}
