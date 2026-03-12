using Microsoft.Extensions.Logging;
using NetCord;
using NetCord.Gateway;

using var loggerFactory = LoggerFactory.Create(builder => builder.AddConsole());
var logger = loggerFactory.CreateLogger("DiscordBot");

var token =
    Environment.GetEnvironmentVariable("DISCORD_TOKEN")
    ?? throw new InvalidOperationException("Missing environment variable: DISCORD_TOKEN.");

var channelId = ulong.Parse(
    Environment.GetEnvironmentVariable("DISCORD_CHANNEL_ID")
        ?? throw new InvalidOperationException("Missing environment variable: DISCORD_CHANNEL_ID.")
);

var client = new GatewayClient(
    new BotToken(token),
    new GatewayClientConfiguration { Intents = GatewayIntents.Guilds | GatewayIntents.GuildUsers }
);

client.GuildUserAdd += async args =>
{
    logger.LogInformation("User {UserId} joined guild {GuildId}", args.Id, args.GuildId);
    if (await client.Rest.GetChannelAsync(channelId) is TextChannel channel)
        await channel.SendMessageAsync($"Bienvenue sur le serveur, <@{args.Id}> !");
};

client.GuildUserRemove += async args =>
{
    logger.LogInformation(
        "User {Username} ({UserId}) left guild {GuildId}",
        args.User.Username,
        args.User.Id,
        args.GuildId
    );
    if (await client.Rest.GetChannelAsync(channelId) is TextChannel channel)
        await channel.SendMessageAsync($"<@{args.User.Id}> a quitté le serveur.");
};

logger.LogInformation("Starting bot...");
await client.StartAsync();
logger.LogInformation("Bot connected and ready");
await Task.Delay(Timeout.Infinite);
