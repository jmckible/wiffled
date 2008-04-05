module ApplicationHelper
  # Creates a form with the layout defined in tagged_builder.rb
  def tagged_form_for(name, *args, &block) 
    options = args.last.is_a?(Hash) ? args.pop : {} 
    options = options.merge(:builder => TaggedBuilder) 
    args = (args << options) 
    form_for(name, *args, &block) 
  end
  
  def is_commissioner?
    logged_in? && @league.commissioner == current_player
  end
  
  def is_owner?
    logged_in? && @team.owner == current_player
  end
  
  def is_this_player?
    logged_in? && @player == current_player
  end
  
  def owns_any_team?
    logged_in? && !current_player.ownership.nil?
  end

  def ifh(label, value)
    "<strong>#{label}</strong>: #{h value}<br/>" unless value.blank?
  end
  
  def ifm(label, object, method)
    "<strong>#{label}</strong>: #{h object.send(method)}<br/>" unless object.nil?
  end
  
  def f(float)
    return '-' if float.infinite?
    float.to_s.first(5).gsub(/^0/, '').ljust(4, '0')
  end
  
  def updated_league_topic?
    logged_in? && (current_player.forum_checked_at.nil? || @topic.replied_at > current_player.forum_checked_at)
  end
  
  def thumbnail_for(player)
    if player.avatar.nil?
  	  content_tag :div, '&nbsp;', :class=>:no_picture
    else    
      "<div>#{link_to image_tag(player.avatar.public_filename(:thumb)), player}</div>"
    end
  end
  
end
