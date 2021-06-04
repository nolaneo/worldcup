import { FixtureWireformat } from './../../services/api';
import Component from '@glimmer/component';

interface Args {
  fixtures: Array<FixtureWireformat>;
}

export default class EurosFixtureList extends Component<Args> {
  get upcomingFixtures() {
    let now = new Date().getTime();
    return this.args.fixtures.filter((fixture) => {
      return new Date(fixture.kickOffTime.dateTime).getTime() > now;
    });
  }
}
