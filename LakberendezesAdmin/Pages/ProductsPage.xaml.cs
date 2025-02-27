using LakberendezesAdmin.Pages.Models;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
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
<<<<<<< HEAD
    /// <summary>
    /// Interaction logic for ProductsPage.xaml
    /// </summary>
=======
  
>>>>>>> 3dd1804 (Export)
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

        private async void Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string searchText = SearchTextBox.Text.Trim();
                if (string.IsNullOrWhiteSpace(searchText))
                {
                    MessageBox.Show("Kérlek, add meg a keresett termék nevét!");
                    return;
                }

                HttpResponseMessage response = await _httpClient.GetAsync($"https://localhost:7247/api/Products/search/{searchText}");
                if (response.IsSuccessStatusCode)
                {
                    string jsonResponse = await response.Content.ReadAsStringAsync();
                    var products = JsonSerializer.Deserialize<List<Product>>(jsonResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

                    PorductsListBox.ItemsSource = products;
                }
                else if (response.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    MessageBox.Show("Nem található ilyen nevű termék.");
                    PorductsListBox.ItemsSource = null;
                }
                else
                {
                    MessageBox.Show($"Hiba: {response.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hiba történt: {ex.Message}");
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
            if (PorductsListBox.SelectedItems.Count == 1)
            {
                var selectedProduct = PorductsListBox.SelectedItem as Product;
                if (selectedProduct != null)
                {
                    var result = MessageBox.Show($"Biztosan törlöd a(z) {selectedProduct.name} terméket?", "Megerősítés", MessageBoxButton.YesNo);
                    if (result == MessageBoxResult.Yes)
                    {
                        HttpResponseMessage response = await _httpClient.DeleteAsync($"https://localhost:7247/api/Products/deleteByName{selectedProduct.name}");
                        if (response.IsSuccessStatusCode)
                        {
                            MessageBox.Show("Termék sikeresen törölve!");
                            _allproducts.Remove(selectedProduct);
                        }
                        else
                        {
                            MessageBox.Show("Hiba történt a törlés során.");
                        }
                    }
                }
            }
            else
            {
                MessageBox.Show("Válassz ki egy terméket a listából!");
            }
        }

        private async void Button_Click_2(object sender, RoutedEventArgs e)
        {
<<<<<<< HEAD
            using(HttpClient client=new HttpClient())
            {
                try
                {
                    var response = await client.GetAsync("https://localhost:7247/api/Products/Export");
                    if (response.IsSuccessStatusCode)
                    {
                        var data = await response.Content.ReadAsByteArrayAsync();
                        SaveFileDialog saveFileDialog = new SaveFileDialog
                        {
                            FileName = "termekek.csv",
                            Filter = "CSV fájl (*.csv)|*.csv",
                            Title = "Mentés"
                        };
                        if (saveFileDialog.ShowDialog()==true)
                        {
                            File.WriteAllBytes(saveFileDialog.FileName, data);
                            MessageBox.Show("Exportálás sikeres!", "Export", MessageBoxButton.OK, MessageBoxImage.Information);

                        }
                        else
                        {
                            MessageBox.Show("Hiba történt");
                        }
                    }
                }catch(Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
=======
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
>>>>>>> 3dd1804 (Export)
            }
        }
    }
}
<<<<<<< HEAD
=======

>>>>>>> 3dd1804 (Export)
