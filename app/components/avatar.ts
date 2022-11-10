import Component from '@glimmer/component';
import config from 'worldcup/config/environment';

interface AvatarArgs {
  url: string;
  title: string;
}

export default class Avatar extends Component<AvatarArgs> {
  get image(): string {
    if (this.args.url.includes('http')) return this.args.url;

    return `${config.rootURL}/assets/${this.args.url}`;
  }
}
