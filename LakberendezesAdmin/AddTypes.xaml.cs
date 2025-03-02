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

    public partial class AddTypes : Window
    {
        private readonly HttpClient httpClient = new HttpClient();
        public event EventHandler TypeAdded;
        public AddTypes()
        {
            InitializeComponent();
            RoomCombo();
        }

        private void RoomCombo()
        {
            ProducttyperoomCombo.Items.Clear();
            ProducttyperoomCombo.Items.Add(new {categoryid="1", name="Nappali"});
            ProducttyperoomCombo.Items.Add(new {categoryid="3", name="Hálószoba"});
            ProducttyperoomCombo.Items.Add(new{categoryid="4", name="Fürdőszoba"});
            ProducttyperoomCombo.Items.Add(new{categoryid="5", name="Étkező"});
        }
        private async void save_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Ellenőrizzük, hogy minden mező ki van-e töltve
                if (string.IsNullOrWhiteSpace(ProducttypeNameTextBox.Text))
                {
                    MessageBox.Show("Minden mezőt ki kell tölteni!", "Hiba", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var selectedItem = ProducttyperoomCombo.SelectedItem;
                var roomidProperty = selectedItem.GetType().GetProperty("categoryid");
                int roomid = int.Parse(roomidProperty.GetValue(selectedItem).ToString());

                //Termék hozzáadása
                var newProduct = new
                {
                    categoryid = roomid,
                    name = ProducttypeNameTextBox.Text,
                };
                //Json adatok előállítása
                var options = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };
                string json = JsonSerializer.Serialize(newProduct, options);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await httpClient.PostAsync("https://localhost:7247/api/ProductTypes", content);
                //Státuszkódok kezelése
                if (response.IsSuccessStatusCode)
                {
                    MessageBox.Show("Bútortípus sikeresen hozzáadva!", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                    TypeAdded?.Invoke(this, EventArgs.Empty);
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
