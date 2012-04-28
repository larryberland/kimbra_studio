class Storyline < ActiveRecord::Base

  attr_accessor :crawler

  belongs_to :story

  def describe(description)
    self.update_attribute(:description, description) unless crawler
  end

  def describe_more(more_stuff)
    unless crawler
      new_description = self.description.to_s << " " << more_stuff.to_s
      self.update_attribute(:description, new_description)
    end
  end

  def seconds_comment
    if seconds
      "For #{seconds} seconds."
    else
      "For unknown time."
    end
  end

end