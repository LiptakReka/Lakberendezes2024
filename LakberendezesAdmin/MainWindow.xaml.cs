using LakberendezesAdmin.Pages;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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

namespace LakberendezesAdmin
{
  
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            var loginW=new LoginW();
            if(loginW.ShowDialog() != true )
            {
                Application.Current.Shutdown();
            }
        }

        private void Users_Click(object sender, RoutedEventArgs e)
        {
            MainFrame.NavigationService.Navigate(new Pages.UsersPage());
        }

        private void Products_Click(object sender, RoutedEventArgs e)
        {
            MainFrame.NavigationService.Navigate(new Pages.ProductsPage());
        }

        private void Plans_Click(object sender, RoutedEventArgs e)
        {
            MainFrame.NavigationService.Navigate(new Pages.SavedPlans());
        }
    }
}
