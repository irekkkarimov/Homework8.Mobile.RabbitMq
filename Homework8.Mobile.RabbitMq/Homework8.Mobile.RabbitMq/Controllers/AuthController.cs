using Homework8.Mobile.RabbitMq.Models;
using Homework8.Mobile.RabbitMq.Services.SessionStore;
using MassTransit;
using Microsoft.AspNetCore.Mvc;

namespace Homework8.Mobile.RabbitMq.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController(ISessionStore store, IBus bus) : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> Login([FromBody] AuthRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Username)) return BadRequest();

        var oldToken = store.GetTokenAsync(request.Username);
        if (oldToken != null)
        {
            await bus.Publish(new LogoutMessage { Username = request.Username });
            store.RemoveAsync(request.Username);
        }

        var newToken = Guid.NewGuid().ToString();
        store.AddAsync(request.Username, newToken);
        return Ok(new { token = newToken });
    }

    [HttpGet("/{username}")]
    public async Task<IActionResult> IsAuth(string username)
    {
        var oldToken = store.GetTokenAsync(username);
        if (oldToken != null)
        {
            return Ok();
        }

        return BadRequest();
    }
}