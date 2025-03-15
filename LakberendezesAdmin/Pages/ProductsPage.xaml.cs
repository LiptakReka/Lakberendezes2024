using LakberendezesAdmin.Pages.Models;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
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

    public partial class ProductsPage : Page
    {
        private static readonly HttpClient _httpClient = new HttpClient();
        private List<Product> _allproducts = new List<Product>();
        private string _token;
        public ProductsPage()
        {
            InitializeComponent();
            _token = TokenStorage.token;
            if (!string.IsNullOrEmpty(_token))
            {
                _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
            }
           
            LoadProducts();
        }
        private async void LoadProducts()
        {
            try
            {
                _allproducts = await GetProductsAsync();
                ProductsGrid.ItemsSource = _allproducts;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private async Task<List<Product>> GetProductsAsync()
        {
            var request = new HttpRequestMessage(HttpMethod.Get, "https://localhost:7247/api/Products");
            var response = await _httpClient.SendAsync(request);
            response.EnsureSuccessStatusCode();

            var jsonString = await response.Content.ReadAsStringAsync();
            var products = JsonSerializer.Deserialize<List<Product>>(jsonString, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });
            return products;
        }

        

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            string searchText = SearchTextBox.Text.Trim().ToLower();

            if (string.IsNullOrEmpty(searchText))
            {
                ProductsGrid.ItemsSource = _allproducts;
            }
            else
            {
                List<Product> filteredProducts = _allproducts.Where(product =>
                    product.id.ToString().Contains(searchText) ||
                    product.name.ToLower().Contains(searchText)
                ).ToList();
                ProductsGrid.ItemsSource = filteredProducts;
            }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            var AddProductWindow = new AddProductWindow();
            if (AddProductWindow.ShowDialog() == true)
            {
                LoadProducts();
            }
        }

        private async void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            Button button = sender as Button;
            if (button != null)
            {
                // Az id kinyerése a gomb Tag tulajdonságából
                int PrId = Convert.ToInt32(button.Tag);

                var result = MessageBox.Show($"Biztosan törlöd a(z) {PrId} üzletet?", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    try
                    {
                        var request = new HttpRequestMessage(HttpMethod.Delete, $"https://localhost:7247/api/Products/{PrId}");
                        request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
                        var response = await _httpClient.SendAsync(request);
                        response.EnsureSuccessStatusCode();

                        MessageBox.Show("Sikeres törlés", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                        _allproducts.RemoveAll(p => p.id == PrId);
                        ProductsGrid.ItemsSource = null;
                        ProductsGrid.ItemsSource = _allproducts;
                    }
                    catch (Exception)
                    {

                        MessageBox.Show("Hiba történt a törlés során", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
            }
        }

        private async void Button_Click_2(object sender, RoutedEventArgs e)
        {
            string apiUrl = "https://localhost:7247/api/Products/Export";

            try
            {
                var request = new HttpRequestMessage(HttpMethod.Get, apiUrl);
                request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue(_token);
                var response = await _httpClient.SendAsync(request);
                response.EnsureSuccessStatusCode();

                byte[] excelData = await response.Content.ReadAsByteArrayAsync();
                string filepath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "termekek.xlsx");
                File.WriteAllBytes(filepath, excelData);

                MessageBox.Show("Sikeres exportálás", "Siker", MessageBoxButton.OK, MessageBoxImage.Information);
                System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo(filepath) { UseShellExecute = true });
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}", "Hiba", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}

