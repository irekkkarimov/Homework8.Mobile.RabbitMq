namespace Homework8.Mobile.RabbitMq.Services.SessionStore;

public class SessionStore : ISessionStore
{
    private readonly Dictionary<string, string> _sessions = new();
    
    public void AddAsync(string username, string token)
    {
        _sessions[username] = token;
    }

    public string? GetTokenAsync(string username)
    {
        return _sessions.TryGetValue(username, out var token) ? token : null;
    }

    public void RemoveAsync(string username)
    {
        _sessions.Remove(username);
    }

    public IEnumerable<string> GetAll()
    {
        return _sessions.Keys.ToList();
    }
}