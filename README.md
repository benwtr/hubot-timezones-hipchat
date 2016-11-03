# hubot-timezones-hipchat

Display timezones for team (users in current room) from hipchat API

See [`src/timezones-hipchat.coffee`](src/timezones-hipchat.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-timezones-hipchat --save`

Then add **hubot-timezones-hipchat** to your `external-scripts.json`:

```json
["hubot-timezones-hipchat"]
```

## Sample Interaction

```
user1>> hubot tz
hubot>> 
[Thu 11:01PM +0100 CET  Europe/Amsterdam   ] natoque, penatibus
[Thu 11:01PM +0100 CET  Europe/Berlin      ] blandit
[Thu 06:01PM -0400 EDT  America/Toronto    ] phasellus, Lacus
[Thu 03:01PM -0700 PDT  America/Los_Angeles] Nullam, tristique, diam
```
