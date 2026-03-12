# Discord Bot

Discord bot written in C# using [NetCord](https://github.com/NetCordDev/NetCord), targeting .NET 10 with AOT compilation.

## Prerequisites

- .NET SDK 10.0+

## Deployment

The deploy script expects a `.env` file at `/opt/discord-bot.env` on the VPS with the following variables:

```env
DISCORD_TOKEN=...
DISCORD_CHANNEL_ID=...
```

## Build

### Common issue: missing workload manifests

After a .NET SDK update (e.g. via the system package manager), there can be a version conflict between the installed SDK and the workload manifests. If `dotnet build` fails with a `Workload set version X.X.X has missing manifests` error, run:

```bash
sudo dotnet workload update
```

Then build normally:

```bash
dotnet build
```
