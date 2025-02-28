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
        public ProductsPage()
        {
            InitializeComponent();
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
            var response = await _httpClient.GetAsync("https://localhost:7247/api/Products");
            response.EnsureSuccessStatusCode();

            var jsonString = await response.Content.ReadAsStringAsync();
            var products = JsonSerializer.Deserialize<List<Product>>(jsonString, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });
            return products;
        }

        // ...

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

                var result = MessageBox.Show($"Biztosan törlöd a(z) {PrId} tervet?", "Megerősítés", MessageBoxButton.YesNo);
                if (result == MessageBoxResult.Yes)
                {
                    HttpResponseMessage response = await _httpClient.DeleteAsync($"https://localhost:7247/api/Products/{PrId}");
                    if (response.IsSuccessStatusCode)
                    {
                        MessageBox.Show("Termék sikeresen törölve!");

                        // Keresés az elem után
                        var ToRemove = _allproducts.FirstOrDefault(p => p.id == PrId);
                        if (ToRemove != null)
                        {
                            _allproducts.Remove(ToRemove);
                        }

                        // Refresh a DataGrid nézetben
                        ProductsGrid.ItemsSource = null;
                        ProductsGrid.ItemsSource = _allproducts;
                    }
                    else
                    {
                        MessageBox.Show("Hiba történt a törlés során.");
                    }
                }
            }
        }

        private async void Button_Click_2(object sender, RoutedEventArgs e)
        {
            string apiUrl = "https://localhost:7247/api/Products/Export";

            try
            {
                // Excel fájl letöltése
                byte[] excelData = await _httpClient.GetByteArrayAsync(apiUrl);

                //fájl mentése
                string filePath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "termekek.xlsx");
                using(var fs=new FileStream(filePath,FileMode.Create, FileAccess.Write, FileShare.Read))
                {
                    await fs.WriteAsync(excelData,0,excelData.Length);
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

