# Copy API

- Create airtable.com account
- Go to https://airtable.com/account and generate & copy the API key
- Create application.yml file by using application.yml.example file and store keys you got from airtable
- Go to https://airtable.com and click on Add a base from scratch and call it Copy
- Set 2 columns called Key and Copy
- Add 3 rows
  - `greeting`, `Hi {name}, welcome to {app}!`
  - `intro.created_at`, `Intro created on {created_at, datetime}`
  - `intro.updated_at`, `Intro updated on {updated_at, datetime}`
- Add a few more rows of your own choosing
- Start server `rails s`

## Routes:
- /copy API endpoint returns all the copy in JSON format
- /copy/{key} API endpoint that returns the value associated with the key, for example:
  1. `/copy/greeting?name=John&app=Bridge` return `{value: 'Hi John, welcome to Bridge!'}`
  2. `/copy/intro.created_at?created_at=1603814215` return `{value: 'Intro created on Tues Oct 27 3:56:55PM'}`
  3. `/copy/intro.updated_at?updated_at=1604063144` return `{value: 'Intro updated on Fri Oct 30 1:05:44PM'}`
- /copy/refresh to refresh the copy data from airtable
- /copy?since=<current epoch time> only returns the updated after give time
