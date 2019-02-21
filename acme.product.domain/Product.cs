using System;
using System.Collections.Generic;

namespace acme.product.domain
{
    public class Product
    {
        public string Name { get; set; }

        public int Id { get; set; }

        public List<Variant> Variants { get; set; }
    }
}
