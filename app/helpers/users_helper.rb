module UsersHelper
  def full_name(user)
    [user.last_name, user.first_name].join(", ").to_s
  end
end
