# ===== Build Stage =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# Copy csproj and restore dependencies
COPY BulkyWeb/*.csproj .
RUN dotnet restore

# Copy the rest of the source code
COPY BulkyWeb/. .
RUN dotnet publish -c Release -o /app

# ===== Runtime Stage =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app .

# Render uses port 8080
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Run your app
ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]
