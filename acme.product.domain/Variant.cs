using System;
using System.Collections.Generic;
using System.Text;

namespace acme.product.domain
{
    public class Variant
    {
        public string Color { get; set; }

        public string Size { get; set; }

        public int Id { get; set; }

        public Product Product { get; set; }
    }
}
