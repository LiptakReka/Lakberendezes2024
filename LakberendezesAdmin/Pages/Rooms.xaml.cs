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

    public partial class Rooms : Page
    {
        
        private static readonly HttpClient _httpClient = new HttpClient();
        static List<Room> rooms = new List<Room>();
        private string _token;
        public Rooms()
        {
            InitializeComponent();
            _token = Properties.Settings.Default.JwtToken;
            _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
            LoadData();
        }

        private async void LoadData()
        {
           
            try
            {
                rooms = await GetRoomsAsync();
                RoomsGrid.ItemsSource = rooms;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async Task<List<Room>> GetRoomsAsync()
        {
            
            var request = new HttpRequestMessage(HttpMethod.Get,"https://localhost:7247/api/Categories");
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
            var response = await _httpClient.SendAsync(request);
            response.EnsureSuccessStatusCode();

            var jsonString = await response.Content.ReadAsStringAsync();
            var roomss = JsonSerializer.Deserialize<List<Room>>(jsonString, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });
            return roomss;
        }

        private void Search_Click(object sender, RoutedEventArgs e)
        {
            string searchText = Searchtextbox.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(searchText))
            {
                RoomsGrid.ItemsSource = rooms;
            }
            else
            {
                List<Room> filteredRooms = rooms.Where(r =>
                    r.id.ToString().Contains(searchText) ||
                    r.name.ToLower().Contains(searchText)
                ).ToList();
                RoomsGrid.ItemsSource = filteredRooms;
            }

        }

        private async void Export_Click(object sender, RoutedEventArgs e)
        {
           
            string apiUrl = "https://localhost:7247/api/Categories/Export";

            try
            {
                var request = new HttpRequestMessage(HttpMethod.Get, apiUrl);
                request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                var response = await _httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();
                // Excel fájl letöltése
                byte[] excelData = await response.Content.ReadAsByteArrayAsync();

                //fájl mentése
                string filePath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "szobak.xlsx");
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

        private async void NewShop_Click(object sender, RoutedEventArgs e)
        {
            var addCateg = new AddCateg();
            addCateg.RoomAdded += async (s, ev) => LoadData();
            addCateg.ShowDialog();
        }
        private async void Delete_Click(object sender, RoutedEventArgs e)
        {
            
            Button button = sender as Button;
            if (button != null)
            {
                // Az id kinyerése a gomb Tag tulajdonságából
                int romId = Convert.ToInt32(button.Tag);

                var result = MessageBox.Show($"Biztosan törlöd a(z) {romId} szobát ?", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    var request = new HttpRequestMessage(HttpMethod.Delete,$"https://localhost:7247/api/Categories/{romId}");
                    request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _token);
                    var response = await _httpClient.SendAsync(request);
                    response.EnsureSuccessStatusCode();
                    if (response.IsSuccessStatusCode)
                    {
                        MessageBox.Show("Helység sikeresen törölve!");

                        // Keresés az elem után
                        var ToRemove = rooms.FirstOrDefault(p => p.id == romId);
                        if (ToRemove != null)
                        {
                            rooms.Remove(ToRemove);
                        }

                        // Refresh a DataGrid nézetben
                        RoomsGrid.ItemsSource = null;
                        RoomsGrid.ItemsSource = rooms;
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
