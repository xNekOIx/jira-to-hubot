
module.exports = (robot) -> 
  robot.router.post '/hubot/chat-jira-comment/:room', (req, res) ->
    room = req.params.room
    body = req.body
  
    userURL = if body.user then "#{body.user.displayName}" else null
    issue = if body.issue then "*#{body.issue.key}* (#{body.issue.self}) \n#{body.issue.fields.summary}" else null

    robot.logger.info body

    message = switch body.webhookEvent
      when "jira:issue_created" then "#{userURL} had just created issue:\n#{issue}"
      when "jira:issue_deleted" then "#{userURL} had just deleted issue:\n#{issue}"
      when "jira:issue_updated" then "#{userURL} had just updated issue:\n#{issue}"
      else null

      # time logging 
      # when "jira:worklog_updated" then "#{userURL} had just logged time to issue:\n#{issue}"

    if message 
      robot.messageRoom req.params.room, message

    res.send 'OK'
