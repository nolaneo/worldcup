import { FixtureWireformat } from './../../services/api';
import Component from '@glimmer/component';

interface Args {
  fixtures: Array<FixtureWireformat>;
}

export default class EurosFixtureList extends Component<Args> {
  get upcomingFixtures() {
    let now = new Date().getTime();
    return this.args.fixtures
      .filter((fixture) => {
        return new Date(fixture.kickOffTime.dateTime).getTime() > now;
      })
      .sort((a, b) => {
        return (
          new Date(a.kickOffTime.dateTime).getTime() -
          new Date(b.kickOffTime.dateTime).getTime()
        );
      });
  }
}
