using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Lakberendezes.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
namespace Lakberendezes.Data
{
    public class AppDbContext: DbContext
    {
        //információ átadás
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
        
        
        //Leképzik a modelleket az adatbázis tábláira
        public DbSet<Product> products {  get; set; }
        public DbSet<Shops> shops { get; set; }
        public DbSet<Achievement> achievements { get; set; }
        public DbSet<ProductType> producttype { get; set; }
        public DbSet<Categories> kategories { get; set; }

        public DbSet<User> users {  get; set; }
        public DbSet<Roles> role { get; set; }
        public DbSet<UserRole> userroles { get; set; }
        public DbSet<UserPlans> userplan { get; set; }
        public DbSet<PlanProduct> planproducts { get; set; }



        protected override void OnModelCreating(ModelBuilder modelBuilder)
            //adatbázis kapcsolatok
        {
            base.OnModelCreating(modelBuilder);

            
            modelBuilder.Entity<Product>()
                .HasOne(u => u.Shops)
                .WithMany(up => up.products_ibfk_1)
                .HasForeignKey(up => up.shopid)
                .OnDelete(DeleteBehavior.Cascade);


            
            modelBuilder.Entity<Product>()
                .HasOne(c => c.ProductType)
                .WithMany(pt => pt.products_ibfk_2)
                .HasForeignKey(pt => pt.product_type_id)
                .OnDelete(DeleteBehavior.Cascade);


            
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
                .HasPrincipalKey(hm => hm.Id)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<PlanProduct>()
                .HasOne(mn=>mn.Userplans)
                .WithMany(bn=>bn.Products)
                .HasForeignKey(bn=>bn.userplanid)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserRole>()
                .HasKey(ur => new { ur.Userid, ur.Roleid });
            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.User)
                .WithMany(u => u.roles)
                .HasForeignKey(ur => ur.Userid);

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.Role)
                .WithMany(r => r.roles)
                .HasForeignKey(ur => ur.Roleid);





        }




    }
}
