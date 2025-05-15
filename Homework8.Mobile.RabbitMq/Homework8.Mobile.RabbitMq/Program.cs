using Homework8.Mobile.RabbitMq.BackgroundWorkers;
using Homework8.Mobile.RabbitMq.Services.SessionStore;
using MassTransit;

var builder = WebApplication.CreateBuilder(args);

builder.WebHost.UseUrls("http://0.0.0.0:5182");

builder.Services.AddMassTransit(x => {
    x.UsingRabbitMq((context, cfg) =>
    {
        cfg.ConfigureEndpoints(context);
        cfg.Host("localhost");
    });
});

builder.Services.AddDistributedMemoryCache();

builder.Services.AddSingleton<ISessionStore, SessionStore>();
builder.Services.AddHostedService<NotificationWorker>();
builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapControllers();

app.Run();
