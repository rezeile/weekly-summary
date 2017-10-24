# Weekly Summary

*Last Updated: October 23 2017*

---

> A Mac OS agent (i.e. user daemon) that reads the [Mac OSX Calender App](https://en.wikipedia.org/wiki/Calendar_(Apple)) and sends a weekly summary to a user's email about how her time was spent.

---

## Table of Contents

1. [Setup](#setup)
    1. [Postfix mail server](#postfix-mail-server)
    1. [Writing a plist file](#writing-a-plist-file)
    1. [Daemon configuration file](#daemon-configuration-file)
1. [Emailed timelog example](#emailed-timelog-example)

## Setup

`weekly-summary` is a daemon that does not require any user interaction. However it does require a small amount of initial configuration. In particular, it needs to know where to email the summarised timelogs, where to store the email text file on the file system, and how frequently itshould run (i.e. weekly,daily,hourly, etc ...). 

For illustrative purposes, the rest of this document will refer to a fictionalized mail server `mail.bobjones.com` and email address `mail@bobjones.com`.

### Postfix mail server

[Postfix](http://www.postfix.org/) is a mail server that is natively integrated to the Mac OSX operating system. We will first configure our outgoing mail server which will be used by the `sendmail` utility (which will be invoked as part of a script written by the daemon itself). To configure the mail server, we will execute the following on the command line:

`sudo vim /etc/postfix/main.cf`

At the end of `main.cf` add the following lines:

```cf
relayhost = mail.bobjones.com:26
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_sasl_mechanism_filter = plain
smtp_use_tls = yes
```

The `relayhost` above contains the name of the mail server and the port number at which it is listening. In the example above we have a mail server that already exists at `mail.bobjones.com`. If you don't have a domain at which you have a mail server you can use the `smtp.gmail.com` if you own a gmail account. For other email hosts, check their configuration settings.

The second important field from the configuration file is:

`smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd`. 

This field tells our mail server where our user credentials are encryptically stored: `/etc/postfix/sasl_passwd`. 

So we will create the file by running the following command:

`sudo vim /etc/postfix/sasl_passwd`

Inside the file we will enter:

`mail.bobjones.com:26 mail@bobjones.com:#skked893@#`

Here `mail.bobjones.com:26` is the name of the `relayhost` which is defined in `main.cf`. `mail@bobjones.com` is the source email address that our email originates from and `#skked893@#` is the password. 

We will want to restrict access to the `sasl_passwd` file by running the following `sudo chmod 600 /etc/postfix/sasl_passwd`

Finally we will want to create [postmap](http://www.postfix.org/postmap.1.html) lookup table and restart our postfix mail server daemon by running the following:

```
sudo postmap /etc/postfix/sasl_passwd
sudo launchctl stop org.postfix.master
sudo launchctl start org.postfix.master
```

**[Back to top](#table-of-contents)**

### Writing a plist file

A mac daemon is controlled by service management framework [`launchd`](https://en.wikipedia.org/wiki/Launchd). (To view a list of system and user daemons managed by `launchd` run `launchctl list`.)

A property list (extension `.plist`) is an xml file that configures a `launchd` daemon. For our example the property list located in the same directory as the readme is called `local.weeklysummary.plist`. This file should be placed at the following directory `~/Library/LaunchAgents` on your Mac.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>local.weeklysummary.plist</string>
    <key>StartCalendarInterval</key>
    <dict>
      <key>Weekday</key>
      <integer>6</integer>
      <key>Hour</key>
      <integer>23</integer>
      <key>Minute</key>
      <integer>59</integer>
    </dict>
    <key>Program</key>
    <string>/Path/to/executable</string>
  </dict>
</plist>
```

We will describe some of the key elements of the property file from above. 

```
<key>Label</key>
<string>local.weeklysummary.plist</string>
```

The key `<key>Label</key>` describes the name of the property list which should be unique among system daemons.

```
<key>StartCalendarInterval</key>
<dict>
      <key>Weekday</key>
      <integer>6</integer>
      <key>Hour</key>
      <integer>23</integer>
      <key>Minute</key>
      <integer>59</integer>
    </dict>
```

The second key defines a calendar interval inside a `<dict>...</dict>` which instructs `launchd` when to execute the program. `6` means the sixth day of the week (Saturday), `23` denotes the 23 hour of the day (i.e. 11pm), and `59` denotes the 59th minute of the the hour. Thus this daemon will execute every saturday at 11:59pm.

```
<key>Program</key>
<string>/Path/to/executable</string>
```

Lastly the `<key>Program</key>` last tag defines where the actual executable program is located.


**[Back to top](#table-of-contents)**

### Daemon configuration file

We will also need a configuration file called `config.json` that will have several properties (JSON keys) that the daemon program will require. This config.json file should be placed in the same location as the daemon executable which is described int the `plist` file above under the `<key>Program</key>` tag. A description of the different properties is given below. 

| Property Name | Description | Example
|---|---|---|
| launchPath | shell environment path | `"/bin/bash"`
| emailBodyPath | location of email text on file system | `"Users/bob/weekly-summary/email.txt"` |
| scriptPath | location of bash script that invokes [`sendmail`](https://en.wikipedia.org/wiki/Sendmail) | `"Users/bob/weekly-summary/scripts/email.sh"` |
| sourceEmailAddress | source email address | `mail@bobjones.com` |
| destEmailAddress | destination email address | `bobjones@gmail.com` |
| launchArguments | arguments to pass to `scriptPath` | `"Users/bob/weekly-summary/scripts/email.sh"` |
| baseTasks | recurring weekly tasks | `["gym","programming","basketball"]` |

Here's an example `config.json` entry for Bob Jones:

```
{
    "launchPath": "/bin/bash",
    "emailBodyPath": "Users/bob/weekly-summary/email.txt",
    "scriptPath": "Users/bob/weekly-summary/scripts/email.sh",
    "sourceEmailAddress": "mail@bobjones.com",
    "destEmailAddress": "bobjones@gmail.com",
    "launchArguments": ["Users/bob/weekly-summary/scripts/email.sh""],
    "baseTasks": ["gym","programming","basketball"]
}

```

**[Back to top](#table-of-contents)**

## Emailed timelog example

<img src="https://github.com/rezeile/weekly-summary/blob/master/img/email_00.png">

**[Back to top](#table-of-contents)**

## License

#### (The MIT License)

Copyright (c) 2017 Eliezer Abate

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
