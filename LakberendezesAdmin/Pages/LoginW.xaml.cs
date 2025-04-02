using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Text.Json;
using System.Windows.Shapes;
using LakberendezesAdmin.Pages.Models;

namespace LakberendezesAdmin.Pages
{
    public partial class LoginW : Window
    {
        private static readonly HttpClient _httpClient = new HttpClient();

        public LoginW()
        {
            InitializeComponent();
        }

        private async void Login_Click(object sender, RoutedEventArgs e)
        {
            var loginData = new { email = EmailTextBox.Text, password = PasswordBox.Password };
            var json = JsonSerializer.Serialize(loginData);
            var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync("https://roomlabapi.up.railway.app/api/Users/login", content);
                var responseBody = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    try
                    {
                        var tokenResponse = JsonSerializer.Deserialize<AuthResponse>(responseBody);
                        if (tokenResponse != null && !string.IsNullOrEmpty(tokenResponse.token))
                        {

                            Properties.Settings.Default.JwtToken = tokenResponse.token;
                            Properties.Settings.Default.Save();
                            MessageBox.Show("Sikeres bejelentkezés", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);

                            DialogResult= true;
                        }
                        else
                        {
                            ErrorMessage.Text = "Hibás email vagy jelszó!";
                            ErrorMessage.Visibility = Visibility.Visible;
                        }
                    }
                    catch (JsonException jsonEx)
                    {
                        MessageBox.Show($"Hiba a JSON feldolgozása során: {jsonEx.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
                else
                {
                    ErrorMessage.Text = "Hibás email vagy jelszó!";
                    ErrorMessage.Visibility = Visibility.Visible;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hiba történt: " + ex.Message, "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

    }
}
