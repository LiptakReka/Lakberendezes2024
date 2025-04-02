using System;
using System.Collections.Generic;
using System.IO;
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
using System.Windows.Navigation;
using System.Windows.Shapes;
using LakberendezesAdmin.Pages;
using LakberendezesAdmin.Pages.Models;

namespace LakberendezesAdmin.Pages
{

    public partial class Shops : Page
    {
        private HttpClient client = new HttpClient();
        private List<Shop> _shopList = new List<Shop>();
        private string _token;
        public Shops()
        {
            InitializeComponent();
            _token = Properties.Settings.Default.JwtToken;
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
            LoadData();

        }
        private async void LoadData()
        {
            try
            {
                _shopList = await GetShopsAsync();
                ShopsGrid.ItemsSource = _shopList;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private async Task<List<Shop>> GetShopsAsync()
        {
            var request = new HttpRequestMessage(HttpMethod.Get, "https://roomlabapi.up.railway.app/api/Shops");
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
            var response = await client.SendAsync(request);
            response.EnsureSuccessStatusCode();

            var jsonString = await response.Content.ReadAsStringAsync();
            var shopss = JsonSerializer.Deserialize<List<Shop>>(jsonString, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });
            return shopss;
        }

        private void Search_Click(object sender, RoutedEventArgs e)
        {
            string searchText = Searchtextbox.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(searchText))
            {
                ShopsGrid.ItemsSource = _shopList;
            }
            else
            {
                List<Shop> filteredsHOPS = _shopList.Where(Shops =>
                    Shops.id.ToString().Contains(searchText) ||
                    Shops.name.ToLower().Contains(searchText)
                ).ToList();
                ShopsGrid.ItemsSource = filteredsHOPS;
            }
        }

        private void NewShop_Click(object sender, RoutedEventArgs e)
        {
            var addShops = new AddShops();
            if (addShops.ShowDialog() == true)
            {
                LoadData();
            }
        }
        private async void DeleteShop_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            if (button != null)
            {
                // Az id kinyerése a gomb Tag tulajdonságából
                int shid = Convert.ToInt32(button.Tag);

                var result = MessageBox.Show($"Biztosan törlöd a(z) {shid} üzletet", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    var request = new HttpRequestMessage(HttpMethod.Delete,$"https://roomlabapi.up.railway.app/api/Shops/{shid}");
                    request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                    var response = await client.SendAsync(request);
                    response.EnsureSuccessStatusCode();
                    if (response.IsSuccessStatusCode)
                    {
                        MessageBox.Show("Üzlet sikeresen törölve!");

                        // Keresés az elem után
                        var ToRemove = _shopList.FirstOrDefault(p => p.id == shid);
                        if (ToRemove != null)
                        {
                            _shopList.Remove(ToRemove);
                        }

                        
                        ShopsGrid.ItemsSource = null;
                        ShopsGrid.ItemsSource = _shopList;
                    }
                    else
                    {
                        MessageBox.Show("Hiba történt a törlés során.");
                    }
                }
            }
        }

        private async void Export_Click(object sender, RoutedEventArgs e)
        {
            string apiUrl = "https://roomlabapi.up.railway.app/api/Shops/Export";

            try
            {
                var request = new HttpRequestMessage(HttpMethod.Get, apiUrl);
                request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                var response = await client.SendAsync(request);
                response.EnsureSuccessStatusCode();
                // Excel fájl letöltése
                byte[] excelData = await response.Content.ReadAsByteArrayAsync();

                //fájl mentése
                string filePath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Uzletek.xlsx");
                using (var fs = new FileStream(filePath, FileMode.Create, FileAccess.Write, FileShare.Read))
                {
                    await fs.WriteAsync(excelData, 0, excelData.Length);
                }


                MessageBox.Show($"Az Excel fájl sikeresen letöltve!\nElérési út: {filePath}", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);

                // Fájl megnyitása
                System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo(filePath) { UseShellExecute = true });
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt a letöltés során: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
