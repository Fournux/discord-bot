FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
RUN apt-get update && apt-get install -y clang zlib1g-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /src

COPY discord-bot.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish discord-bot.csproj -c Release -r linux-x64 -o /app

FROM mcr.microsoft.com/dotnet/runtime-deps:10.0
WORKDIR /app

COPY --from=build /app/discord-bot .

ENTRYPOINT ["./discord-bot"]
