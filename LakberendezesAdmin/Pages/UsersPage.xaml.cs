using LakberendezesAdmin.Pages.Models;
using System;
using System.Collections.Generic;
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

        public UsersPage()
        {
            InitializeComponent();
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
                var response = await _httpClient.GetAsync("https://localhost:7247/api/Users");
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

        private void DataGridRow_MouseLeave(object sender, MouseEventArgs e)
        {
            if (sender is DataGridRow row)
            {
                row.Background = new SolidColorBrush(Colors.White);
            }
        }

        private void DataGridColumnHeader_MouseEnter(object sender, MouseEventArgs e)
        {
            if (sender is DataGridColumnHeader columnHeader)
            {
                columnHeader.Background = new SolidColorBrush(Color.FromRgb(220, 220, 220));
            }
        }

        private void DataGridColumnHeader_MouseLeave(object sender, MouseEventArgs e)
        {
            if (sender is DataGridColumnHeader columnHeader)
            {
                columnHeader.Background = Brushes.Transparent;
            }
        }

 

        private void btnKeres_Click(object sender, RoutedEventArgs e)
        {
            string searchText = SearchTextBox.Text.Trim().ToLower();


            if (string.IsNullOrEmpty(searchText))
            {
                UsersGrid.ItemsSource = null;
                UsersGrid.ItemsSource = _allUsers;
            }
            else
            {
                List<User> filteredUsers = _allUsers.Where(user =>
                    user.UserName?.ToLower().Contains(searchText) == true ||
                    user.Email?.ToLower().Contains(searchText) == true ||
                    user.fullname?.ToLower().Contains(searchText) == true
                ).ToList();
                UsersGrid.ItemsSource = null;
                UsersGrid.ItemsSource = filteredUsers;
            }

        }
    }
}