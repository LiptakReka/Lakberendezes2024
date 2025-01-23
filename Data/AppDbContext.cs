using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Lakberendezes.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
namespace Lakberendezes.Data
{
    public class AppDbContext : IdentityDbContext<User>
    {
        //információ átadás
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
        
        
        //Leképzik a modelleket az adatbázis tábláira
        public DbSet<Product> products {  get; set; }
        public DbSet<Shops> shops { get; set; }
        public DbSet<ProductType> producttype { get; set; }
        public DbSet<Categories> kategories { get; set; }
        public DbSet<User> users {  get; set; }
        public DbSet<UserPlans> userplan { get; set; }
        public DbSet<PlanProduct> planproducts { get; set; }



        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Kapcsolat a User és UserPlans között
            modelBuilder.Entity<Product>()
                .HasOne(u => u.Shops)
                .WithMany(up => up.products_ibfk_1)
                .HasForeignKey(up => up.shopid)
                .OnDelete(DeleteBehavior.Cascade);


            // Kapcsolat a Categories és ProductTypes között
            modelBuilder.Entity<Product>()
                .HasOne(c => c.ProductType)
                .WithMany(pt => pt.products_ibfk_2)
                .HasForeignKey(pt => pt.product_type_id)
                .OnDelete(DeleteBehavior.Cascade);


            // Kapcsolat a ProductType és Products között
            modelBuilder.Entity<Product>()
                .HasOne(pt => pt.Categories)
                .WithMany(p => p.products_ibfk_3)
                .HasForeignKey(p => p.roomid)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ProductType>()
                .HasOne(op => op.Categories)
                .WithMany(pl => pl.producttype_ibfk_1)
                .HasForeignKey(pl => pl.categoryid)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<PlanProduct>()
                .HasOne(ki => ki.Product)
                .WithMany(kj => kj.products)
                .HasForeignKey(kj => kj.productid)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserPlans>()
                .HasOne(hm => hm.User)
                .WithMany(él => él.plans)
                .HasForeignKey(él => él.userid)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<PlanProduct>()
                .HasOne(mn=>mn.Userplans)
                .WithMany(bn=>bn.Products)
                .HasForeignKey(bn=>bn.userplanid)
                .OnDelete(DeleteBehavior.Cascade);
            
        


        }




    }
}
