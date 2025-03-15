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
            string email=EmailTextBox.Text;
            string password=PasswordBox.Password;
            var loginData = new { email, password };
            var json=JsonSerializer.Serialize(loginData);
            var content=new StringContent(json, System.Text.Encoding.UTF8, "application/json");
            try
            {
                var response = await _httpClient.PostAsync("https://localhost:7247/api/Users/login", content);
                if (response.IsSuccessStatusCode)
                {
                    DialogResult = true;
                }
                else
                {
                    ErrorMessage.Text = "Hibás email vagy jelszó";
                    ErrorMessage.Visibility = Visibility.Visible;
                }
            }catch(Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK,MessageBoxImage.Error );
            }
        }

    }
}
