namespace EmployeeApi3.Middelwares
{
    public static class MiddlewareExtensions
    {
        public static IApplicationBuilder UseLogging(this IApplicationBuilder app)
        {
            return app.UseMiddleware<LoggingMiddleware>();
        }
        public static IApplicationBuilder UseAfterLogging(this IApplicationBuilder app)
        {
            return app.UseMiddleware<AfterLoggingMiddleware>();
        }
    }
}
