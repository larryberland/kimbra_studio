module Admin::Customer::FriendsHelper

  def options_for_friends_names(friend)
    list_except_me = friend.email.friends.collect(&:name) - [friend.name]
    options_for_select(list_except_me)
  end
end
