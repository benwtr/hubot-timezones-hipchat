# Description
#   Display timezones for team (users in a given room) from hipchat API
#
# Configuration:
#   HUBOT_TIMEZONES_HIPCHAT_TOKEN
#   HUBOT_TIMEZONES_DEFAULT_ROOM - id or name of default room to use
#
# Commands:
#   hubot tz - Show timezones for users in the default room
#   hubot tz <room_id_or_name> - Show timezones for users in the given room
#
# Dependencies:
#   sync-request
#   moment-timezone
#
# Notes:
#   Uses sync-request for synchronous http requests, this module blocks
#   while making the http requests
#
# Author:
#   @benwtr
#

HC_API = 'https://api.hipchat.com/v2'

AUTH_TOKEN = process.env.HUBOT_TIMEZONES_HIPCHAT_TOKEN
DEFAULT_ROOM = process.env.HUBOT_TIMEZONES_DEFAULT_ROOM

request = require 'sync-request'
moment = require 'moment-timezone'

String.prototype.pad_r = (l,c) ->
  this+Array(l-this.length+1).join(c||" ")

sync_get = (url) ->
  r = request 'GET', url, {headers: {'Authorization': "Bearer #{AUTH_TOKEN}"}}
  JSON.parse r.getBody()

get_room_tzdata = (robot, room) ->
  room = encodeURIComponent(room)
  url = "#{HC_API}/room/#{room}/participant?include-offline=true"
  ids = (person.id for person in sync_get(url).items)
  user_data = (sync_get("#{HC_API}/user/#{id}") for id in ids)
  tz_data = {}
  for user in user_data
    tz_data[user.timezone] ||= []
    tz_data[user.timezone].push user
  tz_data

format_output = (tz_data) ->
  tz_pad = Math.max.apply @, (tz_name.length for tz_name, _ of tz_data)
  current_time = new Date().getTime()
  output = for tz_name, users of tz_data
    time = moment(current_time).tz(tz_name)
    tz = time.format('ZZ z').pad_r 10
    formatted_time = time.format('ddd hh:mmA').pad_r 11
    names = (user.mention_name for user in users).join(', ')
    "[#{formatted_time} #{tz} #{tz_name.pad_r tz_pad}] #{names}\n"
  output.sort().join('')   # todo: sort by offset instead of string


module.exports = (robot) ->

  robot.respond /tz (.*)$/i, (msg) ->
    room = msg.match[1]
    tz_data = get_room_tzdata robot, room
    msg.reply("\n" + format_output(tz_data))

  robot.respond /tz$/i, (msg) ->
    room = DEFAULT_ROOM
    tz_data = get_room_tzdata robot, room
    msg.reply("\n" + format_output(tz_data))
