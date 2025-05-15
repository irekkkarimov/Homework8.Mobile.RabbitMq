FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Homework8.Mobile.RabbitMq/Homework8.Mobile.RabbitMq.csproj", "Homework8.Mobile.RabbitMq/"]
RUN dotnet restore "Homework8.Mobile.RabbitMq/Homework8.Mobile.RabbitMq.csproj"
COPY . .
WORKDIR "/src/Homework8.Mobile.RabbitMq"
RUN dotnet build "Homework8.Mobile.RabbitMq.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Homework8.Mobile.RabbitMq.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Homework8.Mobile.RabbitMq.dll"]
