using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace LakberendezesAdmin
{

    public partial class AddShops : Window
    {
        private readonly HttpClient httpClient= new HttpClient();
        private string _token;
        public AddShops()
        {
            InitializeComponent();
            _token = Properties.Settings.Default.JwtToken;
            httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
        }
        private async void Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Ellenőrizzük, hogy minden mező ki van-e töltve
                if (string.IsNullOrWhiteSpace(ShopNameTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ShopUrlTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ShopphoneTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ShopemailTextBox.Text))
                {
                    MessageBox.Show("Minden mezőt ki kell tölteni!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (!ShopphoneTextBox.Text.StartsWith("+"))
                {
                    MessageBox.Show("Rossz telefonszám formátum, helyes: (+36)", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                }

                if (!ShopemailTextBox.Text.Contains("@"))
                {
                    MessageBox.Show("Érvénytelen email cím!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return; 
                }

                if (!Uri.IsWellFormedUriString(ShopUrlTextBox.Text, UriKind.Absolute))
                {
                    MessageBox.Show("Érvénytelen  URL!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                //Termék hozzáadása
                var newShop = new
                {
                    name = ShopNameTextBox.Text,
                    websiteurl = ShopUrlTextBox.Text,
                    PhoneNumber= ShopphoneTextBox.Text,
                    Email = ShopemailTextBox.Text
                };
                //Json adatok előállítása
                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                string json = JsonSerializer.Serialize(newShop, options);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var request = new HttpRequestMessage(HttpMethod.Post, "https://roomlabapi.up.railway.app/api/Shops")
                {
                    Content = content
                };
                var response = await httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();
                //Státuszkódok kezelése
                if (response.IsSuccessStatusCode)
                {
                    MessageBox.Show("Üzlet sikeresen hozzáadva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                    this.Close();
                }
                else
                {
                    string errorResponse = await response.Content.ReadAsStringAsync();
                    MessageBox.Show($"Hiba: {response.StatusCode}\n{errorResponse}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
