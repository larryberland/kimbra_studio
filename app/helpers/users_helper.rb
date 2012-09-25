module UsersHelper

  def full_name(user)
    [user.first_name, user.last_name].join(" ").to_s
  end

end