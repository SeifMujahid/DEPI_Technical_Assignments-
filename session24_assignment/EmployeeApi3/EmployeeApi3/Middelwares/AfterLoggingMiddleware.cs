namespace EmployeeApi3.Middelwares
{
    public class AfterLoggingMiddleware
    {
        private readonly RequestDelegate _next;

        public AfterLoggingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            await _next(context);
            Console.WriteLine("[AfterLoggingMiddleware] Logging completed.");
        }
    }
}
