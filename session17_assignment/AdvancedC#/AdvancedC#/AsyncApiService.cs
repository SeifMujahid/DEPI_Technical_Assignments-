using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{

    public class AsyncApiService
    {
        private HttpClient _client = new HttpClient();

        public async Task<string> FetchMultipleAsync(params string[] urls)
        {
            var tasks = urls.Select(url => _client.GetStringAsync(url));
            var results = await Task.WhenAll(tasks);
            return string.Join("\n", results);
        }
    }
}
