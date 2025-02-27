using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace Lakberendezes.Models
{
    public class EmailSender : IEmailSender
    {
<<<<<<< HEAD
        private readonly string _smtpServer = "smtp.gmail.com"; // Cseréld le a saját SMTP szerveredre
        private readonly int _smtpPort = 587;
        private readonly string _smtpUser = "roomlabservice@gmail.com"; // Cseréld le a saját email címedre
        private readonly string _smtpPass = "aofb aesx wmaa jhdc"; // Cseréld le a saját jelszavadra

=======
        private readonly string _smtpServer = "smtp.gmail.com"; 
        private readonly int _smtpPort = 587;
        private readonly string _smtpUser = "roomlabservice@gmail.com"; 
        private readonly string _smtpPass = "aofb aesx wmaa jhdc"; 
>>>>>>> 55d865c (Exportálás excelbe)
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
