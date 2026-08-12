# Contributing Guidelines for silverline-services-docker

## CI & Dependency Management Conventions
- **GitHub Actions Tag SHA Pinning**: All GitHub Action references in  MUST be pinned to the exact commit SHA of the official release tag (e.g., ).
- **Inline Version Comments**: The inline comment next to the SHA MUST specify the exact tag version used. This enables Dependabot to recognize the release version, generate human-readable SemVer PR titles (), and automatically update version comments during upgrades.
- **Dependabot Configuration**: Dependabot version updates are enabled via  for , , npm <command>

Usage:

npm install        install all the dependencies in your project
npm install <foo>  add the <foo> dependency to your project
npm test           run this project's tests
npm run <foo>      run the script named <foo>
npm <command> -h   quick help on <command>
npm -l             display usage info for all commands
npm help <term>    search for help on <term>
npm help npm       more involved overview

All commands:

    access, adduser, approve-scripts, audit, bugs, cache, ci,
    completion, config, dedupe, deny-scripts, deprecate, diff,
    dist-tag, docs, doctor, edit, exec, explain, explore,
    find-dupes, fund, get, help, help-search, init, install,
    install-ci-test, install-test, link, ll, login, logout, ls,
    org, outdated, owner, pack, ping, pkg, prefix, profile,
    prune, publish, query, rebuild, repo, restart, root, run,
    sbom, search, set, shrinkwrap, stage, star, stars, start,
    stop, team, test, token, trust, undeprecate, uninstall,
    unpublish, unstar, update, version, view, whoami

Specify configs in the ini-formatted file:
    /Users/mwfarb/.npmrc
or on the command line via: npm <command> --key=value

More configuration info: npm help config
Configuration fields: npm help 7 config

npm@11.16.0 /opt/homebrew/lib/node_modules/npm (), and .
