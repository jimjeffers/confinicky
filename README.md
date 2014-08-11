# Confinicky [![Build Status](https://travis-ci.org/jimjeffers/confinicky.png)](https://travis-ci.org/jimjeffers/confinicky) [![Code Climate](https://codeclimate.com/github/jimjeffers/confinicky.png)](https://codeclimate.com/github/jimjeffers/confinicky) [![Inline docs](http://inch-ci.org/github/jimjeffers/confinicky.png)](http://inch-ci.org/github/jimjeffers/confinicky)

A simple CLI to manage your environment variables.

Run `conficky --help` for a current list of useable commands.

## Listing Environment Variables

You can easily see all of your environment variables using `cfy list` or `cfy ls`.

```
→ cfy ls
+-----------------------+---------------------------------------------------------------------------------------------------------+
| CONFINICKY_FILE_PATH  | /Users/jim/bin/dotfiles/bash/env                                                                        |
| DOCKER_HOST           | tcp://192.168.59.103:2375                                                                               |
| EDITOR                | "subl -w"                                                                                               |
| GEM_CERTIFICATE_CHAIN | '~/bin/dotfiles/gem/gem-public_cert.pem'                                                                |
| GEM_PRIVATE_KEY       | '~/bin/dotfiles/gem/gem-private_key.pem'                                                                |
| INFOPATH              | $INFOPATH:/opt/local/share/info                                                                         |
| MANPATH               | $MANPATH:/opt/local/share/man:/usr/local/git/man                                                        |
| NODE_PATH             | /usr/local/lib/node:/usr/local/lib/node_modules                                                         |
| PATH                  | /Users/jim/.rvm/gems/ruby-2.1.2/bin:/Users/jim/.rvm/gems/ruby-2.1.2@global/bin:/Users/jim/.rvm/rubie... |
| PGDATA                | /usr/local/var/postgres                                                                                 |
| PYTHONPATH            | /usr/local/lib/python2.7/site-packages:$PYTHONPATH                                                      |
| VCPROMPT_FORMAT       | "[%n:%b](%m%u)"                                                                                         |
+-----------------------+---------------------------------------------------------------------------------------------------------+
```

## Contributing to confinicky

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Jim Jeffers. See LICENSE.txt for further details.
