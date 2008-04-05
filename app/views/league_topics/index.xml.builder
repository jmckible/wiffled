xml.feed :xmlns=>'http://www.w3.org/2005/Atom' do
  xml.id 'http://wiffled.com/league_topics'
  xml.title 'Wiffled Forum', :type=>:text
  xml.link :href=>'http://wiffled.com/league_topics.xml', :rel=>:self, :type=>'application/atom+xml'
  xml.link :href=>'http://wiffled.com/league_topics', :rel=>:alternate, :type=>'text/html'
  xml.updated @league_topics.first.replied_at.strftime('%FT%R:00-05:00')
  xml.author do
    xml.name @league.commissioner.name
  end
  
  for league_topic in @league_topics
    message = league_topic.messages.last
    xml.entry do
      xml.title league_topic.title
      xml.link :href=>league_topic_url(league_topic), :rel=>:alternate, :type=>'text/html'
      xml.id league_topic_url(league_topic)
      xml.updated message.created_at.strftime('%FT%R:00-05:00')
      xml.content message.body, :type=>:html
      xml.author do
        xml.name message.player.name
        xml.uri player_url(message.player)
      end
    end
  end
end