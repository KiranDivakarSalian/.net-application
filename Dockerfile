# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY Bulky.sln ./
COPY Bulky.DataAccess/BulkyBook.DataAccess.csproj Bulky.DataAccess/
COPY Bulky.Models/BulkyBook.Models.csproj Bulky.Models/
COPY Bulky.Utility/BulkyBook.Utility.csproj Bulky.Utility/
COPY BulkyWeb/BulkyBookWeb.csproj BulkyWeb/

# Restore dependencies
RUN dotnet restore BulkyWeb/BulkyBookWeb.csproj

# Copy all source code
COPY . .

# Build and publish the app
WORKDIR /src/BulkyWeb
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Render expects the app to listen on port 8080
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Entry point (main project)
ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]
