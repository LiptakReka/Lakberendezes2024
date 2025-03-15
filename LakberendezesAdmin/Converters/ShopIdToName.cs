using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace LakberendezesAdmin.Converters
{
    public  class ShopIdToName :IValueConverter
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
                    case 1: return "Jysk";
                    case 2: return "Möbelix";
                    case 4:return "BRW bútorház";
                    case 3: return "RS BÚTOR";
                    case 5: return "Megfizethető bútor";
                    case 6: return "XXXLutz";
                    case 7: return "Butlers";
                    case 8: return "Magyar bútorbolt";
                    case 9: return "Alaba";
                    case 10: return "Bogart bútor";
                    case 11: return "Bútor7";
                    case 12: return "Zondo.hu";
                    case 13: return "Bútorline";
                    case 14: return "Soma bútor";
                    default: return "Nincs megadva";


                }
            }
            return value.ToString();
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value==null)
            {
                return null;
            }
            string shopName = value.ToString();
            switch (shopName)
            {
                case "Jysk": return 1;
                case "Möbelix": return 2;
                case "RS BÚTOR": return 3;
                case "BRW bútorház": return 4;
                case "Megfizethető bútor": return 5;
                case "XXXLutz": return 6;
                case "Butlers": return 7;
                case "Magyar bútorbolt": return 8;
                case "Alaba": return 9;
                case "Bogart bútor": return 10;
                case "Bútor 7": return 11;
                case "Zondo.hu": return 12;
                case "Bútorline": return 13;
                case "Soma bútor": return 14;
                default: return "Nincs megadva";
            }
        }
    }
}
