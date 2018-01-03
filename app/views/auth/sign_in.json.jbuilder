json.sid @session.id
json.utoken @session.utoken
# show self user
json.user do
  json.partial! 'users/self', user: @user
end