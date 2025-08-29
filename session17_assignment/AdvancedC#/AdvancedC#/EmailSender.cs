using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class EmailSender
    {
        public async Task SendEmailsAsync(IEnumerable<string> emails)
        {
            var tasks = emails.Select(async email =>
            {
                int retries = 3;
                while (retries-- > 0)
                {
                    try
                    {
                        await Task.Delay(200); // simulate send
                        Console.WriteLine($"Email sent to {email}");
                        return;
                    }
                    catch { if (retries == 0) Console.WriteLine($"Failed to send {email}"); }
                }
            });
            await Task.WhenAll(tasks);
        }
    }
}
