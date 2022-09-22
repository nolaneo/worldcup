import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Route | worldcup', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    let route = this.owner.lookup('route:worldcup');
    assert.ok(route);
  });
});
