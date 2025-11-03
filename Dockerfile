# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files first
COPY Bulky.sln ./
COPY BulkyWeb/BulkyWeb.csproj BulkyWeb/
COPY Bulky.Models/Bulky.Models.csproj Bulky.Models/
COPY Bulky.Utility/Bulky.Utility.csproj Bulky.Utility/
COPY Bulky.DataAccess/Bulky.DataAccess.csproj Bulky.DataAccess/

# Restore dependencies
RUN dotnet restore BulkyWeb/BulkyWeb.csproj

# Copy everything else
COPY . ./

# Publish the app
RUN dotnet publish BulkyWeb/BulkyWeb.csproj -c Release -o /app/out

# Use the ASP.NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expose port for Render
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "BulkyWeb.dll"]
