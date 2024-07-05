require "resend"

Resend.api_key = ENV["resend_token"]

class Mailer
  def send(content = '', receptor = '', subject = '')
    Resend::Emails.send({
      "from": ENV["server_email"],
      "to": receptor,
      "subject": subject,
      "html": content
    })
  end
end