json.extract! user, :id, :name, :username, :email
# output user roles
json.roles user.get_roles