FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Lakberendezes.csproj", "./"]
RUN dotnet restore "Lakberendezes.csproj"
COPY . .
RUN dotnet publish "Lakberendezes.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Lakberendezes.dll"]
