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
        public Rooms()
        {
            InitializeComponent();
            LoadData();
        }
        private void Authorize()
        {
            string token = GetToken();
            if (!string.IsNullOrEmpty(token))
            {
                _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(token);
            }
        }

        private string GetToken()
        {
            return LoginW.Token;
        }
        private async void LoadData()
        {
            Authorize();
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
            Authorize();
            var response = await _httpClient.GetAsync("https://localhost:7247/api/Categories");
            
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
            Authorize();
            string apiUrl = "https://localhost:7247/api/Categories/Export";

            try
            {
                // Excel fájl letöltése
                byte[] excelData = await _httpClient.GetByteArrayAsync(apiUrl);

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
            Authorize();
            Button button = sender as Button;
            if (button != null)
            {
                // Az id kinyerése a gomb Tag tulajdonságából
                int romId = Convert.ToInt32(button.Tag);

                var result = MessageBox.Show($"Biztosan törlöd a(z) {romId} szobát ?", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    HttpResponseMessage response = await _httpClient.DeleteAsync($"https://localhost:7247/api/Categories/{romId}");
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
