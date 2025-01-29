using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace Lakberendezes.Models
{
    public class EmailSender : IEmailSender
    {
        private readonly string _smtpServer = "smtp.gmail.com"; // Cseréld le a saját SMTP szerveredre
        private readonly int _smtpPort = 587;
        private readonly string _smtpUser = "roomlabservice@gmail.com"; // Cseréld le a saját email címedre
        private readonly string _smtpPass = "hijg moqx fbnc jygz"; // Cseréld le a saját jelszavadra

        public async Task SendEmailAsync(string email, string subject, string message)
        {
            using (var client = new SmtpClient(_smtpServer, _smtpPort))
            {
                client.Credentials = new NetworkCredential(_smtpUser, _smtpPass);
                client.EnableSsl = true;

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_smtpUser),
                    Subject = subject,
                    Body = message,
                    IsBodyHtml = true,
                };
                mailMessage.To.Add(email);

                await client.SendMailAsync(mailMessage);
            }
        }
    }
}
