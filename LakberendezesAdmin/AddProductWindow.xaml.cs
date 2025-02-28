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

    public partial class AddProductWindow : Window
    {
        private readonly HttpClient httpClient;
        public AddProductWindow()
        {
            InitializeComponent();
            ShopCombo();
            Producttypecombo();
            ProductroomCommbo();
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
                    string.IsNullOrWhiteSpace(ProductUrlTextBox.Text))
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

                if (!Uri.IsWellFormedUriString(ProductUrlTextBox.Text, UriKind.Absolute))
                {
                    MessageBox.Show("Érvénytelen  URL!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                int shopidd = (int)ShopComboBox.SelectedValue;
                int productTypeId = (int)ProducttypeCombo.SelectedValue;
                int roomId=(int)ProductroomCombo.SelectedValue;
                //Termék hozzáadása
                var newProduct = new
                {
                    name = ProductNameTextBox.Text,
                    price = price,
                    shoplink = ProductUrlTextBox.Text,
                    imageurl = ProductimgTextBox.Text,
                    shopid = shopidd,
                    product_type_id = productTypeId,
                    roomid = roomId
                };
                //Json adatok előállítása
                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                string json = JsonSerializer.Serialize(newProduct, options);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await httpClient.PostAsync("https://localhost:7247/api/Products", content);
                //Státuszkódok kezelése
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
        private void ProductroomCommbo()
        {
            ProductroomCombo.Items.Clear();
            ProductroomCombo.Items.Add(new { Id = 1, Name = "Nappali" });
            ProductroomCombo.Items.Add(new { Id = 3, Name = "Hálószoba" });
            ProductroomCombo.Items.Add(new { Id = 5, Name = "Étkező" });
            ProductroomCombo.Items.Add(new { Id = 4, Name = "Fürdőszoba" });
        }
        private void Producttypecombo()
        {
            ProducttypeCombo.Items.Clear();
            ProducttypeCombo.Items.Add(new { Id = 1, Name = "Kanapé" });
            ProducttypeCombo.Items.Add(new { Id = 3, Name = "Dohányzóasztal" });
            ProducttypeCombo.Items.Add(new { Id = 5, Name = "TV állvány" });
            ProducttypeCombo.Items.Add(new { Id = 11, Name = " Ágy" });
            ProducttypeCombo.Items.Add(new { Id = 13, Name = "Éjjeli szekrény" });
            ProducttypeCombo.Items.Add(new { Id = 14, Name = "Szekrény" });
            ProducttypeCombo.Items.Add(new { Id = 16, Name = "Tükör" });
            ProducttypeCombo.Items.Add(new { Id = 19, Name = "Törölköző" });           
            ProducttypeCombo.Items.Add(new { Id = 20, Name = "Kiegészítők" });
            ProducttypeCombo.Items.Add(new { Id = 21, Name = "Étkező asztal" });
            ProducttypeCombo.Items.Add(new { Id = 22, Name = "Polc" });
            ProducttypeCombo.Items.Add(new { Id = 23, Name = "Szék" });

        }

        private void ShopCombo()
        {
            ShopComboBox.Items.Clear();
            ShopComboBox.Items.Add(new { Id = 1, Name = "Jysk" });
            ShopComboBox.Items.Add(new { Id = 2, Name = "Möbelix" });
            ShopComboBox.Items.Add(new { Id = 3, Name = "RS BÚTOR" });
            ShopComboBox.Items.Add(new { Id = 5, Name = "Megfizethető bútor" });
            ShopComboBox.Items.Add(new { Id = 6, Name = "XXXLutz" });
            ShopComboBox.Items.Add(new { Id = 7, Name = "Butlers" });
            ShopComboBox.Items.Add(new { Id = 8, Name = "Magyar bútorbolt" });
            ShopComboBox.Items.Add(new { Id = 9, Name = "Alaba" });
            ShopComboBox.Items.Add(new { Id = 10, Name = "Bogart bútor" });
            ShopComboBox.Items.Add(new { Id = 11, Name = "Bútor7" });
            ShopComboBox.Items.Add(new { Id = 12, Name = "Zondo.hu" });
            ShopComboBox.Items.Add(new { Id = 13, Name = "Bútorline" });
            ShopComboBox.Items.Add(new { Id = 14, Name = "Soma bútor" });
        }

    
    }


}
