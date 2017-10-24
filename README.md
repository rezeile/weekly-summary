# Weekly Summary

*Last Updated: October 23 2017*

---

> A Mac OS agent (i.e. user daemon) that reads the [Mac OSX Calender App](https://en.wikipedia.org/wiki/Calendar_(Apple)) and sends a weekly summary to a user's email about how her time was spent.

---

<img src="https://github.com/rezeile/weekly-summary/blob/master/img/email_00.png">

## Table of Contents

1. [Setup](#setup)
    1. [Postfix mail server](#postfix-mail-server)
    1. [Daemon config file](#daemon-config-file)
    1. [Writing a plist file](#writing-a-plist-file)
1. [Example](#example)

# Setup

`weekly-summary` is a daemon and thus does not involve any user interaction. Nonetheless it does require initial configuration. In particular, it needs to know where to email the summarised timelogs, where to store the email text file on the file system, and when the program itself should run (i.e. weekly). For illustrative purposes, the rest of this document will refer to a fictionalized mail server `mail.bobjones.com` and email address `mail@bobjones.com`.

### Postfix mail server

[Postfix](http://www.postfix.org/) is a mail server that is natively integrated to the Mac OSX operating system. We will first configure our outgoing mail server which will be used by the `sendmail` utility (which is part of an a script written by the daemon itself). To configure the mail server, we will execute the following on the command line the following:

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

The second important field from the configuration file is `smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd`. This field tells our mail server where our user credentials are encryptically stored: `/etc/postfix/sasl_passwd`. 

So we will create the file by running the following command:

`sudo vim /etc/postfix/sasl_passwd`

Inside the file we will enter:

`mail.bobjones.com:26 mail@bobjones.com:#skked893@#`

Here `mail.bobjones.com:26` is the name of the `relayhost` which is defined in `main.cf`. `mail@bobjones.com` is the source email address that our email originates from and `#skked893@#` is the password. 

We will want to restrict access to the `sasl_passwd` file by running the following `sudo chmod 600 /etc/postfix/sasl_passwd`

Finally we will want to create [postmap](http://www.postfix.org/postmap.1.html) lookup table by and restart our postfix mail server daemon by running the following:

```
sudo postmap /etc/postfix/sasl_passwd
sudo launchctl stop org.postfix.master
sudo launchctl start org.postfix.master
```

**[Back to top](#table-of-contents)**

### Writing a plist file

A root module begins with a root component that defines the base element for the entire application, with a routing outlet defined, example shown using `ui-view` from `ui-router`.

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

**[Back to top](#table-of-contents)**

### Daemon config file

Due to the fact directives support most of what `.component()` does (template directives were the original component), I'm recommending limiting your directive Object definitions to only these properties, to avoid using directives incorrectly:

| Property Name | Description | Example
|---|---|---|
| launchPath | shell environment path | `"/bin/bash"`
| emailBodyPath | location of email text on file system | `"Users/bob/weekly-summary/email.txt"` |
| scriptPath | location of bash script that invokes [`sendmail`](https://en.wikipedia.org/wiki/Sendmail) | `"Users/bob/weekly-summary/scripts/email.sh"` |
| sourceEmailAddress | source email address | `mail@bobjones.com` |
| destEmailAddress | destination email address | `bobjones@gmail.com` |
| launchArguments | arguments to pass to `scriptPath` | `"Users/bob/weekly-summary/scripts/email.sh"` |
| baseTasks | recurring weekly tasks | `["gym","programming","basketball"]` |

**[Back to top](#table-of-contents)**

# Example
* Use `ui-router` [latest alpha](https://github.com/angular-ui/ui-router) (see the Readme) if you want to support component-routing
  * Otherwise you're stuck with `template: '<component>'` and no `bindings`/resolve mapping
* Consider preloading templates into `$templateCache` with `angular-templates` or `ngtemplate-loader`
  * [Gulp version](https://www.npmjs.com/package/gulp-angular-templatecache)
  * [Grunt version](https://www.npmjs.com/package/grunt-angular-templates)
  * [Webpack version](https://github.com/WearyMonkey/ngtemplate-loader)
* Consider using [Webpack](https://webpack.github.io/) for compiling your ES2015 code and styles
* Use [ngAnnotate](https://github.com/olov/ng-annotate) to automatically annotate `$inject` properties
* How to use [ngAnnotate with ES6](https://www.timroes.de/2015/07/29/using-ecmascript-6-es6-with-angularjs-1-x/#ng-annotate)

**[Back to top](#table-of-contents)**

## License

#### (The MIT License)

Copyright (c) 2016-2017 Todd Motto

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
