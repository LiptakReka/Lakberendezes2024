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
using System.Windows.Navigation;
using System.Windows.Shapes;
using LakberendezesAdmin.Pages.Models;

namespace LakberendezesAdmin.Pages
{

    public partial class SavedPlans : Page
    {
        private static readonly HttpClient httpClient = new HttpClient();
        private List<Plan> _planList=new List<Plan>();
        
        public SavedPlans()
        {
            InitializeComponent();
            LoadData();
        }
        private async void LoadData()
        {
            try
            {
                _planList = await GetProductsAsync();
                dataGrid.ItemsSource = _planList;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async Task<List<Plan>> GetProductsAsync()
        {
            var response = await httpClient.GetAsync("https://localhost:7247/api/UserPlans");
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
                dataGrid.ItemsSource = _planList;
            }
            else
            {
                List<Plan> filteredPlans = _planList.Where(plan =>
                    plan.id.ToString().Contains(searchText) == true
                ).ToList();
                dataGrid.ItemsSource = filteredPlans;
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
                    HttpResponseMessage response = await httpClient.DeleteAsync($"https://localhost:7247/api/UserPlans/{planId}");
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
                        dataGrid.ItemsSource = null;
                        dataGrid.ItemsSource = _planList;
                    }
                    else
                    {
                        MessageBox.Show("Hiba történt a törlés során.");
                    }
                }
            }
        }


        private void Export_Click_2(object sender, RoutedEventArgs e)
        {

        }
    }
}
