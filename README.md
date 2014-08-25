# Confinicky [![Build Status](https://travis-ci.org/jimjeffers/confinicky.png)](https://travis-ci.org/jimjeffers/confinicky) [![Code Climate](https://codeclimate.com/github/jimjeffers/confinicky.png)](https://codeclimate.com/github/jimjeffers/confinicky) [![Inline docs](http://inch-ci.org/github/jimjeffers/confinicky.png)](http://inch-ci.org/github/jimjeffers/confinicky)

A simple CLI to manage your environment variables.

Run `cfy --help` for a current list of useable commands.

## Setup Confinicky

First, install the gem:

```
→ gem install confinicky
```

Next, setup confinicky to use a dedicated file for your aliases and environment variables.  Confinicky will use `~/aliases` and `~/env` by default. You'll then want to source these documents in your `.bash_profile` or `.bashrc` files:

```
→ cfy setup
+---------+--------------------+
|        Configuration         |
+---------+--------------------+
| type    | path               |
+---------+--------------------+
| aliases | /Users/me/aliases |
| env     | /Users/me/env     |
+---------+--------------------+

What file do you want to store your environment vars in?
(leave blank to keep current)

Created file at: /Users/me/env

What file do you want to store your aliases in?
(leave blank to keep current)

Created file at: /Users/me/aliases

Wrote the following configuration to:
/Users/me/.Confinicky

Be sure to add the following lines to your ~/.bash_profile or ~/.bashrc files:
. /Users/me/env
. /Users/me/aliases
```

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

## Creating / Setting an Environment Variable

You can easily add or adjust an environment variable using `cfy set` which expects a parameter such as `MY_VAR=value`.

```
→ cfy set DOCKER_HOST=tcp://192.168.59.103:2375
Successfully set 'DOCKER_HOST=tcp://192.168.59.103:2375'.
Run 'source /Users/jim/bin/dotfiles/bash/env' or open a new terminal/shell window.
```

## Removing an Environment Variable

You can easily add or adjust an environment variable using `cfy remove` or `cfy rm`.

```
→ cfy remove MY_VAR
Successfully removed 'MY_VAR'.
Open a new terminal/shell window for this change to take affect.
```

## Detecting Duplicate Exports

If your environment files have turned into a junk drawer with PATH getting defined multiple times throughout the file or otherwise, you can get a summary by running `cfy duplicates`.

```
→ cfy duplicates
+----------+---+
| PATH     | 7 |
| MANPATH  | 3 |
| INFOPATH | 3 |
+----------+---+
Identified 3 variables with multiple 'export' statements in /Users/jim/bin/dotfiles/bash/env
Run 'cfy clean' to reduce these statements.
```

## Cleaning Duplicate Exports

You can run `cfy clean` which replaces multiple export declarations with the actual value of the environment variable.

```
→ cfy clean
Backup your existing file before continuuing? (y/n)
y
Backup saved to: /Users/jim/bin/dotfiles/bash/env1407782855.bak.tmp
Your file is clean. 3 duplicate statements have been reduced.
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
