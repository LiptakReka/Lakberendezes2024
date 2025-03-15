using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace LakberendezesAdmin.Converters
{
    public class ProductTypeToName : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value == null)
            {
                return "Nincs megadva";
            }
            if (int.TryParse(value.ToString(), out int productTypeId))
            {
                switch (productTypeId)
                {
                    case 1: return "Kanapé";
                    case 3: return "Dohányzóasztal";
                    case 5: return "Tv állvány";
                    case 11: return "Ágy";
                    case 13: return "Éjjeli szekrény";
                    case 14: return "Ruhásszekrény";
                    case 16: return "Tükör";
                    case 21: return "Étkező asztal";
                    case 22: return "Polc és szekrény";
                    case 23: return "Szék";
                    case 34: return "Zuhanyzó";
                    case 35: return "Fürdőszobai szekrény";
                    case 36: return "Mosókonyhai eszközök";
                    default: return value.ToString();
                }
            }
            return value.ToString();
        }
        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value == null)
            {
                return null;
            }
            string productTypeName = value.ToString();
            switch (productTypeName)
            {
                case "Kanapé": return 1;
                case "Dohányzóasztal": return 3;
                case "TV állvány": return 5;
                case "Ágy": return 11;
                case "Éjjeli szekrény": return 13;
                case "Ruhásszekrény": return 14;
                case "Tükör": return 16;
                case "Étkező asztal": return 21;
                case "Polc és szekrény": return 22;
                case "Szék": return 23;
                case "Zuhanyzó": return 34;
                case "Fürdőszobai szekrény": return 35;
                case "Mosókonyhai eszközök": return 36;
                default: return value.ToString();
            }
        }
    }
}
