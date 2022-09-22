/* eslint-env node */
'use strict';

module.exports = function () {
  let ENV = {
    build: {},
    rootURL: '/worldcup/',
    locationType: 'hash',
    ghpages: {
      gitRemoteUrl: 'git@github.com:/nolaneo/worldcup',
    },
  };
  return ENV;
};
