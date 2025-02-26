using Microsoft.AspNetCore.Mvc;
using MimeKit;
using System.Text;
using Lakberendezes.Models;
using MailKit.Net.Smtp;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailController : Controller
    {
        [HttpPost("send-cart")]
        public async Task<IActionResult> SendCartEmail([FromBody] CartEmailRequestDTO request)
        {
            if (request == null || string.IsNullOrEmpty(request.Email) || request.CartItems == null || request.CartItems.Count == 0)
            {
                return BadRequest("Érvénytelen adatok.");
            }

            try
            {
                var emailMessage = new MimeMessage();
                emailMessage.From.Add(new MailboxAddress("RoomLab", "noreply@roomlab.com"));
                emailMessage.To.Add(new MailboxAddress("", request.Email));
                emailMessage.Subject = "🛒 Kosár tartalma - RoomLab";

                var bodyBuilder = new BodyBuilder();
                StringBuilder emailBody = new StringBuilder();

                emailBody.AppendLine(@"
<!DOCTYPE html>
<html lang='hu'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta name='color-scheme' content='light dark'>
    <meta name='supported-color-schemes' content='light dark'>
    <title>Kosár tartalma - RoomLab</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #f5f5f5;
            padding: 20px;
            -webkit-font-smoothing: antialiased;
        }

        .email-wrapper {
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        .email-header {
            background: linear-gradient(135deg, #6a57d4 0%, #5438d7 100%);
            padding: 40px 20px;
            text-align: center;
            color: #ffffff !important;
        }

        .logo {
            font-size: 32px;
            font-weight: 700;
            color: #ffffff !important;
            -webkit-text-fill-color: #ffffff;
        }

        .email-body {
            padding: 32px;
        }

        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin: 24px 0;
            background: #ffffff;
            border-radius: 8px;
            overflow: hidden;
        }

        .cart-table th {
            background: #6a57d4;
            color: #ffffff !important;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }

        .cart-table td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
            color: #4a5568;
        }

        .cart-table tr:last-child td {
            border-bottom: none;
        }

        .view-button {
            display: inline-block;
            background: #6a57d4 !important;
            color: #ffffff !important;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 14px;
            -webkit-text-fill-color: #ffffff;
        }

        .footer {
            background: #f8fafc;
            padding: 24px;
            text-align: center;
            border-top: 1px solid #e2e8f0;
        }

        @media screen and (max-width: 600px) {
            body {
                padding: 10px;
            }

            .email-wrapper {
                border-radius: 8px;
            }

            .cart-table {
                display: block;
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }

            .cart-table th,
            .cart-table td {
                white-space: nowrap;
            }
        }

        @media (prefers-color-scheme: dark) {
            body {
                background: #1a1a1a;
                color: #ffffff;
            }

            .email-wrapper {
                background: #2d2d2d;
            }

            .cart-table {
                background: #363636;
            }

            .cart-table td {
                border-color: #404040;
                color: #e0e0e0;
            }

            .footer {
                background: #363636;
                border-color: #404040;
            }
        }
    </style>
</head>
<body>
    <div class='email-wrapper'>
        <div class='email-header'>
            <div class='logo'>RoomLab</div>
            <div style='margin-top: 8px; font-size: 16px;'>Kosár tartalma</div>
        </div>
        
        <div class='email-body'>
            <p style='font-size: 16px; color: #4a5568; margin-bottom: 24px;'>
                Kedves Vásárlónk!<br>
                Az alábbi termékeket tetted a kosaradba:
            </p>

            <table class='cart-table'>
                <tr>
                    <th>Termék</th>
                    <th>Ár</th>
                    <th>Vásárlás</th>
                </tr>");

                foreach (var item in request.CartItems)
                {
                    emailBody.AppendLine($@"
                <tr>
                    <td>{item.Name}</td>
                    <td>{item.Price:N0} Ft</td>
                    <td><a href='{item.ShopLink}' class='view-button' target='_blank'>Megnézem</a></td>
                </tr>");
                }

                emailBody.AppendLine(@"
            </table>
        </div>

        <div class='footer'>
            <p style='color: #64748b; font-size: 14px;'>
                Köszönjük, hogy a RoomLab-ot használod! 🎨<br>
                <strong>RoomLab Csapat</strong>
            </p>
        </div>
    </div>
</body>
</html>");

                bodyBuilder.HtmlBody = emailBody.ToString();
                emailMessage.Body = bodyBuilder.ToMessageBody();

                using (var smtpClient = new SmtpClient())
                {
                    await smtpClient.ConnectAsync("smtp.gmail.com", 587, false);
                    await smtpClient.AuthenticateAsync("roomlabservice@gmail.com", "aofb aesx wmaa jhdc");
                    await smtpClient.SendAsync(emailMessage);
                    await smtpClient.DisconnectAsync(true);
                }

                return Ok(new { message = "Az e-mail sikeresen elküldve!" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Hiba történt az e-mail küldésekor: " + ex.Message);
            }
        }

    }
}
