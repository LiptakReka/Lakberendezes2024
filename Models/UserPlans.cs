using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Lakberendezes.Models
{
    public class UserPlans
    {
        [Key] //Automatikusan generálódik
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }
        public int userid { get; set; }
        public  User? User { get; set; }
        public  required string plandata { get; set; }
        public DateTime createdat { get; set; }

        //kapcsolat
        public  ICollection<PlanProduct>? Products { get; set; }
        
        
     
    }
}
