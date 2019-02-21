using System;
using acme.product.domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Debug;
using DeleteBehavior = Microsoft.EntityFrameworkCore.DeleteBehavior;

namespace acme.product.dataaccess
{
    public class ProductContext : DbContext
    {
        public virtual DbSet<Product> Products { get; set; }

        public virtual DbSet<Variant> Variants { get; set; }

        private static readonly LoggerFactory Loggerfactory = new LoggerFactory(new[] { new DebugLoggerProvider() });

        public ProductContext()
        {

        }

        public ProductContext(DbContextOptions options) : base(options)
        {
            

        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseLoggerFactory(Loggerfactory);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Product>()
                .Property(x => x.Id)
                .ValueGeneratedOnAdd();
            modelBuilder.Entity<Product>()
                .HasMany(x => x.Variants)
                .WithOne(x => x.Product)
                .OnDelete(deleteBehavior: DeleteBehavior.Cascade);

            modelBuilder.Entity<Variant>()
                .Property(x => x.Id)
                .ValueGeneratedOnAdd();
        }
    }
}
