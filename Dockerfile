FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY discord-bot.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -r linux-x64 --self-contained -o /app

FROM mcr.microsoft.com/dotnet/runtime-deps:10.0
WORKDIR /app

COPY --from=build /app/discord-bot .

VOLUME ["/app/logs"]

ENTRYPOINT ["./discord-bot"]
