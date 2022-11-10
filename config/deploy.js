/* eslint-env node */
'use strict';

module.exports = function () {
  let ENV = {
    build: {},
    rootURL: '/',
    locationType: 'hash',
    ghpages: {
      domain: 'nolaneo.com',
      gitRemoteUrl: 'git@github.com:/nolaneo/worldcup',
    },
  };
  return ENV;
};
