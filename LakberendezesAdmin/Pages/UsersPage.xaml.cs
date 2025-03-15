using LakberendezesAdmin.Pages.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;
using System.Windows.Media;

namespace LakberendezesAdmin.Pages
{
    public partial class UsersPage : Page
    {
        private static readonly HttpClient _httpClient = new HttpClient();
        private List<User> _allUsers = new List<User>(); 
        private string _token;

        public UsersPage()
        {
            InitializeComponent();
            _token = Properties.Settings.Default.JwtToken;
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
            LoadUsers();
        }

        private async void LoadUsers()
        {
            try
            {
                _allUsers = await GetUsersAsync();
                UsersGrid.ItemsSource = _allUsers;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async Task<List<User>> GetUsersAsync()
        {
            try
            {
                var request = new HttpRequestMessage(HttpMethod.Get,"https://localhost:7247/api/Users");
                request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                var response = await _httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();

                var jsonString = await response.Content.ReadAsStringAsync();

                var users = JsonSerializer.Deserialize<List<User>>(jsonString, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

                return users ?? new List<User>();
            }
            catch (HttpRequestException ex)
            {
                MessageBox.Show($"Hiba történt a HTTP kérés során: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                return new List<User>();
            }
            catch (JsonException ex)
            {
                MessageBox.Show($"Hiba történt a JSON deszerializálás során: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                return new List<User>();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Általános hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                return new List<User>();
            }
        }

        private void DataGridRow_MouseEnter(object sender, MouseEventArgs e)
        {
            if (sender is DataGridRow row)
            {
                row.Background = new SolidColorBrush(Color.FromRgb(240, 240, 240));
            }
        }

        private void btnKeres_Click(object sender, RoutedEventArgs e)
        {
            string searchText = SearchTextBox.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(searchText))
            {
                UsersGrid.ItemsSource = _allUsers;
            }
            else
            {
                List<User> filteredusers = _allUsers.Where(u =>
                    u.Id.ToString().Contains(searchText) ||
                    u.Email.ToLower().Contains(searchText)||
                    u.UserName.ToLower().Contains(searchText)==true
                ).ToList();
                UsersGrid.ItemsSource = filteredusers;
            }

        }

        private async void Export_Click(object sender, RoutedEventArgs e)
        {
            string apiUrl = "https://localhost:7247/api/Users/Export";

            try
            {
                var request = new HttpRequestMessage(HttpMethod.Get, apiUrl);
                request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                var response = await _httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();
                // Excel fájl letöltése
                byte[] excelData = await response.Content.ReadAsByteArrayAsync();

                //fájl mentése
                string filePath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "felhasznalok.xlsx");
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
        private async void Delete_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            if (button != null)
            {
                // Az id kinyerése a gomb Tag tulajdonságából
                string usid = (string)button.Tag;

                var result = MessageBox.Show($"Biztosan törlöd a(z) {usid} tervet?", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    var request = new HttpRequestMessage(HttpMethod.Delete,$"https://localhost:7247/api/Users/{usid}");
                    request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                    var response = await _httpClient.SendAsync(request);
                    response.EnsureSuccessStatusCode();
                    if (response.IsSuccessStatusCode)
                    {
                        MessageBox.Show("Termék sikeresen törölve!");

                        // Keresés az elem után
                        var ToRemove = _allUsers.FirstOrDefault(p => p.UserName == usid);
                        if (ToRemove != null)
                        {
                            _allUsers.Remove(ToRemove);
                        }

                        // Refresh a DataGrid nézetben
                        UsersGrid.ItemsSource = null;
                        UsersGrid.ItemsSource = _allUsers;
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