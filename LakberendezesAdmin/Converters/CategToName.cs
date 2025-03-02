using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace LakberendezesAdmin.Converters
{
    public class CategToName : IValueConverter
    {
        public object Convert(object value, Type type, object parameter, CultureInfo culture)
        {
            if (value == null)
            {
                return "Nincs megadva";
            }
            if (int.TryParse(value.ToString(), out int shopid))
            {
                switch (shopid)
                {
                    case 1: return "Nappali";
                    case 3: return "Hálószoba";
                    case 4: return "Fürdőszoba";
                    case 5: return "Étkező";
                    default: return value.ToString();


                }
            }
            return value.ToString();
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
            {
                return null;
            }
            string shopName = value.ToString();
            switch (shopName)
            {
                case "Nappali": return 1;
                case "Hálószoba": return 3;
                case "Fürdőszoba": return 4;
                case "Étkező": return 5;
                default: return value.ToString();
            }
        }
    }
}
