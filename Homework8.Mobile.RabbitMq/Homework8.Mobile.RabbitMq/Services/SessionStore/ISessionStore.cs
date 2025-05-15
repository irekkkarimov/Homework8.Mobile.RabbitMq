namespace Homework8.Mobile.RabbitMq.Services.SessionStore;

public interface ISessionStore
{
    void AddAsync(string username, string token);
    string? GetTokenAsync(string username);
    void RemoveAsync(string username);
    IEnumerable<string> GetAll();
}