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
using LakberendezesAdmin.Pages.Models;

namespace LakberendezesAdmin.Pages
{

    public partial class SavedPlans : Page
    {
        private static readonly HttpClient httpClient = new HttpClient();
        private List<Plan> _planList=new List<Plan>();
        private string _token;
        public SavedPlans()
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
                _planList = await GetProductsAsync();
                PlansGrid.ItemsSource = _planList;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async Task<List<Plan>> GetProductsAsync()
        {
            var request = new HttpRequestMessage(HttpMethod.Get, "https://roomlabapi.up.railway.app/api/UserPlans");
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
            var response = await httpClient.SendAsync(request);
            response.EnsureSuccessStatusCode();

            var jsonString = await response.Content.ReadAsStringAsync();
            var plans = JsonSerializer.Deserialize<List<Plan>>(jsonString, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });
            return plans;
        }


        private async void Button_Click(object sender, RoutedEventArgs e)
        {
            string searchText = SearchTextBox.Text.Trim().ToString();

            if (string.IsNullOrEmpty(searchText))
            {
                PlansGrid.ItemsSource = _planList;
            }
            else
            {
                List<Plan> filteredPlans = _planList.Where(plan =>
                    plan.id.ToString().Contains(searchText) == true
                ).ToList();
                PlansGrid.ItemsSource = filteredPlans;
            }
        }

        private async void Delete_Click_1(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            if (button != null)
            {
                // Az id kinyerése a gomb Tag tulajdonságából
                int planId = Convert.ToInt32(button.Tag);

                var result = MessageBox.Show($"Biztosan törlöd a(z) {planId} tervet?", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    var request =new HttpRequestMessage(HttpMethod.Delete,$"https://roomlabapi.up.railway.app/api/UserPlans/{planId}");
                    request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                    var response = await httpClient.SendAsync(request);
                    response.EnsureSuccessStatusCode();
                    if (response.IsSuccessStatusCode)
                    {
                        MessageBox.Show("Termék sikeresen törölve!");

                        // Keresés az elem után
                        var itemToRemove = _planList.FirstOrDefault(p => p.id == planId);
                        if (itemToRemove != null)
                        {
                            _planList.Remove(itemToRemove);
                        }

                        // Refresh a DataGrid nézetben
                        PlansGrid.ItemsSource = null;
                        PlansGrid.ItemsSource = _planList;
                    }
                    else
                    {
                        MessageBox.Show("Hiba történt a törlés során.");
                    }
                }
            }
        }


        private async void Export_Click_2(object sender, RoutedEventArgs e)
        {
            string apiUrl = "https://roomlabapi.up.railway.app/api/UserPlans/Export";

            try
            {
                var request = new HttpRequestMessage(HttpMethod.Get, apiUrl);
                request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                var response = await httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();
                // Excel fájl letöltése
                byte[] excelData = await response.Content.ReadAsByteArrayAsync();

                //fájl mentése
                string filePath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Tervek.xlsx");
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
