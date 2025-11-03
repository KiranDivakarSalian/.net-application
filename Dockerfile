# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution file
COPY ../Bulky.sln ./

# Copy project files
COPY ../Bulky.DataAccess/Bulky.DataAccess.csproj Bulky.DataAccess/
COPY ../Bulky.Models/Bulky.Models.csproj Bulky.Models/
COPY ../Bulky.Utility/Bulky.Utility.csproj Bulky.Utility/
COPY ./BulkyBookWeb.csproj BulkyWeb/

# Restore dependencies
RUN dotnet restore BulkyWeb/BulkyBookWeb.csproj

# Copy the rest of the source code
COPY ../ ./
WORKDIR /src/BulkyWeb
RUN dotnet publish -c Release -o /app

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app ./

# Configure the app to listen on port 8080 (Render requirement)
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]
