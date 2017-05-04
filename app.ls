axios = require \axios
cron = require \node-cron
key =  'Your Application Key'
id_board =  'id of the board that the list should be added to'
token = 'Authorization Token'

generate_list_name = ->
  dateObj = new Date!
  "理解できたこと(" + generate_from_to_date(dateObj) + ")"

generate_from_to_date = (obj) ->
  first_date_of_this_week = generate_first_date_of_this_week obj
  last_date_of_this_week = generate_last_date_of_the_week obj
  first_date_of_this_week + '-' + last_date_of_this_week

# return yyyyMMdd (string) & first day is Monday
generate_first_date_of_this_week = (obj) ->
  current_year = obj.getFullYear!
  current_month = obj.getMonth! + 1
  current_date = obj.getDate!
  current_day = obj.getDay!
  for i from current_day to 2 by -1
    if current_date == 1
      if current_month == 1
        --current_year
        current_month = 12
        current_date = new Date current_year, current_month, 0 .getDate!
      else
        --current_month
        current_date = new Date current_year, current_month, 0 .getDate!
    else
      --current_date
  current_year.toString! + zeroPadding(current_month) + zeroPadding(current_date)

# return yyyyMMdd (string) & last day is Sunday
generate_last_date_of_the_week = (obj) ->
  current_year = obj.getFullYear!
  current_month = obj.getMonth! + 1
  last_date_of_this_month = new Date current_year, current_month, 0 .getDate!
  current_date = obj.getDate!
  current_day = obj.getDay!
  for i from current_day to 6 by 1
    if current_date == last_date_of_this_month
      if current_month == 12
        ++current_year
        current_month = 1
        current_date = 1
      else
        ++current_month
        current_date = 1
    else
      ++current_date
  current_year.toString! + zeroPadding(current_month) + zeroPadding(current_date)

zeroPadding = (num) ->
  if num.toString!.length == 1
    return num = '0' + num.toString!
  else
    return num.toString!

cron.schedule '0 0 0 * * 1', ->
  axios.post 'https://trello.com/1/lists',
    * name: generate_list_name!
      idBoard: id_board
      key: key
      token: token
  .then (res) ->
    console.log 'post succeeded.'
  .catch (err) ->
    console.log err
