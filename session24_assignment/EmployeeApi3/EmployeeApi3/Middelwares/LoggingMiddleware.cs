namespace EmployeeApi3.Middelwares
{
    public class LoggingMiddleware:IMiddleware
    {
        public async Task InvokeAsync(HttpContext context, RequestDelegate next)
        {
            Console.WriteLine($"[LoggingMiddleware] Request Method: {context.Request.Method}");
            await next(context);
            Console.WriteLine($"[LoggingMiddleware] Response Code: {context.Response.StatusCode}");
        }
    }
}
