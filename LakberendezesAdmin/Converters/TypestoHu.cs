using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace LakberendezesAdmin.Converters
{
    internal class TypestoHu:IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value == null)
                return null;
            string type = value.ToString();
            switch (type)
            {
                case "Sofa":
                    return "Kanapé";
                case "cofeetable":
                    return "Dohányzóasztal";
                case "TvBench":
                    return "TV állvány";
                case "Bed":
                    return "Ágy";
                case "Bedside table":
                    return "Éjjeli szekrény";
                case "Wardrobe":
                    return "Szekrény";
                case "Mirror":
                    return "Tükör";
                case "Towel":
                    return "Törölköző";
                case "Accessories":
                    return "Kiegészítők";
                case "Dining Table":
                    return "Étkező asztal";
                case "Shelf":
                    return "Polc";
                case "Chair":
                    return "Szék";
                default:
                    return value.ToString();
            }
        }
        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}

