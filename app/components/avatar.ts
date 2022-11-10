import Component from '@glimmer/component';
interface AvatarArgs {
  url: string;
  title: string;
}

export default class Avatar extends Component<AvatarArgs> {
  get image(): string {
    if (this.args.url.includes('http')) return this.args.url;

    return `assets/${this.args.url}`;
  }
}
