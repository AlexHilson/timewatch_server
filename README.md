# timewatch_server

This is a super hacky project for automating my timesheet submissions. It started with me experimenting with nightmare.js (see timewatch.js) for browser automation, then I decided to build an API around that and add a Slack integration. 

## timewatch.js
Very basic, logs on and submits a task. Zero error handling.

## API 
The API does the absolute bare minimum for my specific use case.

### get /
Returns a list of users
### get /users/:user_id
Returns user details, including registered tasks
### post /users
Create a new user, requires a JSON object containing keys ‘username’, ‘email’, ‘password’
### post /users/:user_id/tasks
Add a task for a user, requires a JSON object containing keys ‘cost_code’, ‘analysis_code’, ‘hours_per_day’
### post /users/:user_id/submit
Submit timesheet for a particular user
