using LakberendezesAdmin.Pages;
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
    /// <summary>
    /// Interaction logic for AddCateg.xaml
    /// </summary>
    public partial class AddCateg : Window
    {
        private readonly HttpClient httpClient = new HttpClient();
        public event EventHandler RoomAdded;
        private string _token;
        public AddCateg()
        {
            InitializeComponent();
            _token = Properties.Settings.Default.JwtToken;
            httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
        }

        private async void save_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Ellenőrizzük, hogy minden mező ki van-e töltve
                if (string.IsNullOrWhiteSpace(RoomNameTextBox.Text))
                {
                    MessageBox.Show("Minden mezőt ki kell tölteni!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                //HELYSÉG hozzáadása
                var newShop = new
                {
                    name = RoomNameTextBox.Text,
                };
                //Json adatok előállítása
                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                string json = JsonSerializer.Serialize(newShop, options);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var request = new HttpRequestMessage(HttpMethod.Post, "https://roomlabapi.up.railway.app/api/Categories")
                {
                    Content = content
                };
                var response = await httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();

                //Státuszkódok kezelése
                if (response.IsSuccessStatusCode)
                {
                    MessageBox.Show("Helység sikeresen hozzáadva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                    RoomAdded?.Invoke(this, EventArgs.Empty);
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
