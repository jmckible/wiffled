class PlayerNotifier < ActionMailer::Base
  
  def commissioner_notification(player)
    @recipients    = player.league.commissioner.email
    @from          = "Wiffled <wiffled@gmail.com>"
    @subject       = "[Wiffled] #{player.name} Signed Up"
    @sent_on       = Time.now
    @body[:player] = player
  end
  
  def announcement(announcement)
    @recipients          = announcement.league.players.collect(&:email)
    @from                = "Wiffled <wiffled@gmail.com>"
    @subject             = "[Wiffled] #{announcement.title}"
    @sent_on             = Time.now
    @body[:announcement] = announcement
  end
  
  def comment(comment)
    @recipients     = comment.player.email
    @from           = "#{comment.sender.name} <#{comment.sender.email}>"
    @subject        = "[Wiffled] New comment from #{comment.sender.name}"
    @sent_on        = Time.now
    @body[:player]  = comment.player
    @body[:comment] = comment
  end
  
  def contract_offer(contract)
    @recipients      = contract.player.email
    @from            = "Wiffled <wiffled@gmail.com>"
    @subject         = "[Wiffled] #{contract.team.name} want you!"
    @sent_on         = Time.now
    @body[:player]   = contract.player
    @body[:contract] = contract
  end
  
  def request_reset(player)
    @recipients    = player.email
    @from          = "Wiffled <wiffled@gmail.com>"
    @subject       = "[Wiffled] A password reset request"
    @sent_on       = Time.now
    @body[:player] = player
  end
  
  def new_password(player, password)
    @recipients      = player.email
    @from            = "Wiffled <wiffled@gmail.com>"
    @subject         = "[Wiffled] Your new password"
    @sent_on         = Time.now
    @body[:player]   = player
    @body[:password] = password
  end
  
end
