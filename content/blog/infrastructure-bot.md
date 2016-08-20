+++
date = "2016-08-19T18:29:11-07:00"
draft = true
title = "Infrastructure bot"

+++

Using bot as a tool to trigger command is very convenience. We don't
have to get on the VPN, SSH into servers and run commands. By using a
bot like an UI, it's quick to get something. If yon are on the road and
want o check some status, it's faster to type something itno Slack. It
does, however, raise some concern about security. Hence we can limit to
some commands to only allow from some users. But that's out of scope of
this post.

In this, we are introducing [Infra
Bot](https://github.com/NotyIm/bot-slack), a tool that let you define
command and run from Slack. It's written in Elixir so you will need
Elixir. Simply follow
[this](http://elixir-lang.org/install.html#unix-and-unix-like) to
install it.

After you are done, let's deploy our bot. 

## Getting slack credential

Create a slack app to get client and secret token. Make sure you enable
the bot and interactive button. The url of its is
[domain_where_you_deploy_bot]/button

## Setting environment variables

The bot needs those:

```
export SLACK_CLIENT_ID=id
export SLACK_CLIENT_SECRET=secret
export BOT_PREFIX=[trigger_word]
export MDBDB=mysqldb_name
export MDBHOST=db_host
export MDBUSER=root
export MDBPASSWORD=root
```

The **BOT_PREFIX** is a trigger word so when you type `bot do this for
me`.

## Define command

Create a file call `config/command.exs` with this content:


```
use Mix.Config

config :infra_bot, :command_runner,
  [
    {"my_action",
      %{
        trigger: ~r/^vinh (.*)/,
        regex:
~r/vinh\s*(?<resource>.*)(for|of|on)\s*(?<client>[^\s]+)/,
        command: %{
          sub_action: %{
            text: "sub action",
            cmd: "script_to_be_run",
            args: ["client", "resource"],
          },
        }
      }
    },

  ]
```

You can define a regex using capture name and pass them via **args**
parameters. When you send a message with that pattern, the bot parse it
to get parameter, and invoke the script in command with passing
parameters.

Example, I can have this:

```
use Mix.Config

config :infra_bot, :command_runner,
  [
    {"server_metric",
      %{
        trigger: ~r/^bot (.*)/,
        regex:
~r/bot\s*(?<metric>.*)(for|of|on)\s*(?<server>[^\s]+)/,
        command: %{
          sub_action: %{
            text: "shutdown ",
            cmd: "",
            args: ["client", "resource"],
          },
        }
      }
    },

  ]
```

## Run the app

After configuring and have setting ready, you can run it like:

```
source ./env  # to get env var
MIX_ENV=production mix phoenix.server
```

## Connect the bot

Go to [your_domain]:[port]/auth/1, you will be redirec to slack to
install your own bot. Once that's done, you can go to slack and should
see it online. Now, command it to do thing
