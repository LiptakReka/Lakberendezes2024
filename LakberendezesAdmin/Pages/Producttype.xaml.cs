using LakberendezesAdmin.Pages.Models;
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

namespace LakberendezesAdmin.Pages
{

    public partial class Producttype : Page
    {
        private readonly HttpClient httpClient = new HttpClient();
        private List<ProductType> producttypes = new List<ProductType>();
        private string _token;
        public Producttype()
        {
            InitializeComponent();
            _token = Properties.Settings.Default.JwtToken;
            httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
            LoadData();
        }

        private async void LoadData()
        {
            try
            {
                producttypes = await GetProducttypesAsync();
                ProducttypeGrid.ItemsSource = producttypes;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private async Task<List<ProductType>> GetProducttypesAsync()
        {
            var request = new HttpRequestMessage(HttpMethod.Get ,"https://roomlabapi.up.railway.app/api/ProductTypes");
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
            var response = await httpClient.SendAsync(request);
            response.EnsureSuccessStatusCode();

            var jsonString = await response.Content.ReadAsStringAsync();
            var types = JsonSerializer.Deserialize<List<ProductType>>(jsonString, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });
            return types;
        }
        private void Search_Click(object sender, RoutedEventArgs e)
        {
            string searchText = Searchtextbox.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(searchText))
            {
                ProducttypeGrid.ItemsSource = producttypes;
            }
            else
            {
                List<ProductType> filteredtypes = producttypes.Where(pt =>
                    pt.id.ToString().Contains(searchText)||
                    pt.name.ToLower().Contains(searchText)
                ).ToList();
                ProducttypeGrid.ItemsSource = filteredtypes;
            }
        }

        private async void Export_Click(object sender, RoutedEventArgs e)
        {
            string apiUrl = "https://roomlabapi.up.railway.app/api/ProductTypes/Export";

            try
            {
                var request = new HttpRequestMessage(HttpMethod.Get, apiUrl);
                request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                var response = await httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();
                // Excel fájl letöltése
                byte[] excelData = await response.Content.ReadAsByteArrayAsync();

                //fájl mentése
                string filePath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "butortipusok.xlsx");
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

        private void New_Click(object sender, RoutedEventArgs e)
        {
            var addTypes = new AddTypes();
            addTypes.TypeAdded += async (s, ev) => LoadData();
            addTypes.ShowDialog();
        }
        private async void Delete_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            if (button != null)
            {
                // Az id kinyerése a gomb Tag tulajdonságából
                int PtId = Convert.ToInt32(button.Tag);

                var result = MessageBox.Show($"Biztosan törlöd a(z) {PtId} bútortípust?", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {

                    var request= new HttpRequestMessage(HttpMethod.Delete, $"https://roomlabapi.up.railway.app/api/ProductTypes/{PtId}");
                    request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                    var response = await httpClient.SendAsync(request);
                    response.EnsureSuccessStatusCode();
                    if (response.IsSuccessStatusCode)
                    {
                        MessageBox.Show("Bútortípus sikeresen törölve!");

                        // Keresés az elem után
                        var ToRemove = producttypes.FirstOrDefault(p => p.id == PtId);
                        if (ToRemove != null)
                        {
                            producttypes.Remove(ToRemove);
                        }

                        // Refresh a DataGrid nézetben
                        ProducttypeGrid.ItemsSource = null;
                        ProducttypeGrid.ItemsSource = producttypes;
                    }
                    else
                    {
                        MessageBox.Show("Hiba történt a törlés során.");
                    }
                }
            }
        }
    }
}
