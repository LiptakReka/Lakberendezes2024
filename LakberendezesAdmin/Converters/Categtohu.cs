using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace LakberendezesAdmin.Converters
{
    public class Categtohu : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value == null)
            {
                return "Nincs megadva";
            }

            string categname = value.ToString();
            switch (categname)
            {
                case "Livingroom": return "Nappali";
                case "Bedroom": return "Hálószoba";
                case "Bathroom": return "Fürdőszoba";
                case "Lunchroom": return "Étkező";
                default: return "Nincs megadva";
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
