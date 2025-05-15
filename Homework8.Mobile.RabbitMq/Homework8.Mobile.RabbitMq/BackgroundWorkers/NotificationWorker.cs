using Homework8.Mobile.RabbitMq.Models;
using Homework8.Mobile.RabbitMq.Services.SessionStore;
using MassTransit;

namespace Homework8.Mobile.RabbitMq.BackgroundWorkers;

public class NotificationWorker(IServiceProvider services) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        using var scope = services.CreateScope();
        var store = scope.ServiceProvider.GetRequiredService<ISessionStore>();
        var bus = scope.ServiceProvider.GetRequiredService<IBus>();

        while (!stoppingToken.IsCancellationRequested)
        {
            foreach (var user in store.GetAll())
            {
                Console.WriteLine(1);
                await bus.Publish(new NotificationMessage()
                {
                    Username = user,
                    Message = $"It is notification"
                }, stoppingToken);
            }

            await Task.Delay(5000, stoppingToken);
        }
    }
}