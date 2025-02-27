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

        private void dataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (dataGrid.SelectedItem is User selectedUser)
            {
                MessageBox.Show($"Felhasználó neve: {selectedUser.UserName}", "Felhasználó információ", MessageBoxButton.OK, MessageBoxImage.Information);
            }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            string searchText = SearchTextBox.Text.Trim().ToLower();


            if (string.IsNullOrEmpty(searchText))
            {
                dataGrid.ItemsSource = null;
                dataGrid.ItemsSource = _planList;
            }
            else
            {
                List<Plan> filteredPlans = _planList.Where(plan =>
                    plan.id.ToString().Contains(searchText) == true ||
                    plan.createdat.ToString().Contains(searchText) == true
                ).ToList();
                dataGrid.ItemsSource = null;
                dataGrid.ItemsSource = filteredPlans;
            }
        }

        private void Delete_Click_1(object sender, RoutedEventArgs e)
        {

        }

        private void Modify_Click_2(object sender, RoutedEventArgs e)
        {

        }
    }
}
