class Storyline < ActiveRecord::Base

  belongs_to :story

  attr_accessor :crawler

  def description=(s)
    super s.to_s.truncate(254)
  end

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
      "#{seconds} seconds"
    else
      "unknown"
    end
  end

end