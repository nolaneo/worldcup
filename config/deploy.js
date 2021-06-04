/* eslint-env node */
'use strict';

module.exports = function () {
  let ENV = {
    build: {},
    rootURL: '/euros/',
    locationType: 'hash',
    ghpages: {
      gitRemoteUrl: 'git@github.com:/nolaneo/euros',
    },
  };
  return ENV;
};
