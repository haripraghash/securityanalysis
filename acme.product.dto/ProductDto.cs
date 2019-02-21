using System;
using System.Collections.Generic;

namespace acme.product.dto
{
    public class ProductDto
    {
        public int? Id { get; set; }
        public string Name { get; set; }

        public List<VariantDto> Variants { get; set; }
    }
}
