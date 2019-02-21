using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using acme.product.dataaccess;
using acme.product.domain;
using acme.product.dto;
using Microsoft.EntityFrameworkCore;

namespace acme.product.services
{
    public class ProductService : IProductService
    {
        private readonly ProductContext _productContext;

        public ProductService(ProductContext productContext)
        {
            _productContext = productContext;
        }

        public async Task<ProductDto> Create(ProductDto productDto)
        {
            var productDomain = new Product()
            {
                Name = productDto.Name
            };

            _productContext.Products.Add(productDomain);
            await _productContext.SaveChangesAsync();

            return new ProductDto()
            {
                Id = productDomain.Id,
                Name = productDomain.Name
            };
        }

        public async Task<List<ProductDto>> GetAll()
        {
            var existingProducts = await _productContext.Products.Include(x => x.Variants).ToListAsync();

            return existingProducts.Select(x => new ProductDto()
            {
                Id = x.Id,
                Name = x.Name,
                Variants = x.Variants.Select(y => new VariantDto()
                {
                    Id = y.Id,
                    Size = y.Size,
                    Color = y.Color
                }).ToList()
            }).ToList();
        }
    }
}
