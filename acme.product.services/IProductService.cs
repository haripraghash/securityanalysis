using System.Collections.Generic;
using System.Threading.Tasks;
using acme.product.dto;

namespace acme.product.services
{
    public interface IProductService
    {
        Task<ProductDto> Create(ProductDto productDto);

        Task<List<ProductDto>> GetAll();
    }
}