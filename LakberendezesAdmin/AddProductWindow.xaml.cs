using LakberendezesAdmin.Pages.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
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
<<<<<<< HEAD
    /// <summary>
    /// Interaction logic for AddProductWindow.xaml
    /// </summary>
=======

>>>>>>> 3dd1804 (Export)
    public partial class AddProductWindow : Window
    {
        private readonly HttpClient httpClient;
        public AddProductWindow()
        {
            InitializeComponent();
            httpClient = new HttpClient { BaseAddress = new Uri("https://localhost:7247/") };
        }

        private async void Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Ellenőrizzük, hogy minden mező ki van-e töltve
                if (string.IsNullOrWhiteSpace(ProductNameTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ProductPriceTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ProductimgTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ProductshIdTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ProductUrlTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ProducttypeTextBox.Text) ||
                    string.IsNullOrWhiteSpace(ProductroomTextBox.Text))
                {
                    MessageBox.Show("Minden mezőt ki kell tölteni!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                // Konvertálás és ellenőrzés
                if (!decimal.TryParse(ProductPriceTextBox.Text, out decimal price) || price <= 0)
                {
                    MessageBox.Show("Hibás ár! Csak pozitív számot adj meg.", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (!int.TryParse(ProductshIdTextBox.Text, out int shopId) ||
                    !int.TryParse(ProducttypeTextBox.Text, out int productTypeId) ||
                    !int.TryParse(ProductroomTextBox.Text, out int roomId))
                {
                    MessageBox.Show("Hibás azonosító formátum! Csak számokat adj meg.", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (!Uri.IsWellFormedUriString(ProductUrlTextBox.Text, UriKind.Absolute))
                {
                    MessageBox.Show("Érvénytelen shoplink URL!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
<<<<<<< HEAD

=======
                //Termék hozzáadása
>>>>>>> 3dd1804 (Export)
                var newProduct = new
                {
                    name = ProductNameTextBox.Text,
                    price = price,
                    shoplink = ProductUrlTextBox.Text,
                    imageurl = ProductimgTextBox.Text,
                    shopid = shopId,
                    product_type_id = productTypeId,
                    roomid = roomId
                };
<<<<<<< HEAD

=======
                //Json adatok előállítása
>>>>>>> 3dd1804 (Export)
                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                string json = JsonSerializer.Serialize(newProduct, options);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await httpClient.PostAsync("https://localhost:7247/api/Products", content);
<<<<<<< HEAD

=======
                //Státuszkódok kezelése
>>>>>>> 3dd1804 (Export)
                if (response.IsSuccessStatusCode)
                {
                    MessageBox.Show("Termék sikeresen hozzáadva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
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
