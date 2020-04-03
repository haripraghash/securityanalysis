using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using acme.product.dto;
using acme.product.services;
using Microsoft.AspNetCore.Mvc;

namespace acme.product.web.api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly IProductService productService;

        public ProductsController(IProductService productService)
        {
            this.productService = productService;
        }

        // GET api/values
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProductDto>>> Get()
        {
            var products = await productService.GetAll();
            return products;
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public ActionResult<string> Get(int id)
        {
            return "value";
        }

        // POST api/values
        [HttpPost]
        public async Task<ActionResult<ProductDto>> Post([FromBody] ProductDto productDto)
        {
            var product = await productService.Create(productDto);
            return Created("", product);
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
