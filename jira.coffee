
module.exports = (robot) -> 
  robot.router.post '/hubot/chat-jira-comment/:room', (req, res) ->
    room = req.params.room
    body = req.body
  
    userURL = if body.user then "<#{body.user.self}|#{body.user.displayName}>" else null
    issue = if body.issue then "<#{body.issue.self}|#{body.issue.key}> #{body.issue.fields.summary}" else null

    message = switch body.webhookEvent
      when "jira:issue_created" then "#{userURL} created #{issue}"
      when "jira:issue_deleted" then "#{userURL} deleted #{issue}"
      when "jira:issue_updated" then "#{userURL} updated #{issue}"
      when "jira:worklog_updated" then "#{userURL} logged time to #{issue}"
      else null

    if message 
      robot.messageRoom req.params.room, message
    else
      console.log body

    res.send 'OK'
