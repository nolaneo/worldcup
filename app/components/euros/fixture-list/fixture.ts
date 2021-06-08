import Component from '@glimmer/component';
import { FixtureWireformat } from 'euros/services/api';

interface Args {
  fixture: FixtureWireformat;
}

export default class EurosFixtureListFixtureComponent extends Component<Args> {
  get isLive(): boolean {
    return this.args.fixture.status === 'LIVE';
  }

  get isUpcoming(): boolean {
    return this.args.fixture.status === 'UPCOMING';
  }

  get isFinished(): boolean {
    return this.args.fixture.status === 'FINISHED';
  }
}
