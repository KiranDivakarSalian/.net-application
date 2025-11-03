# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution file and restore dependencies
COPY Bulky.sln ./
COPY Bulky.DataAccess/Bulky.DataAccess.csproj Bulky.DataAccess/
COPY Bulky.Models/Bulky.Models.csproj Bulky.Models/
COPY Bulky.Utility/BulkyBook.Utility.csproj/
COPY BulkyWeb/BulkyBookWeb.csproj BulkyWeb/

RUN dotnet restore BulkyWeb/BulkyBookWeb.csproj

# Copy the entire project and build
COPY . .
WORKDIR /src/BulkyWeb
RUN dotnet publish -c Release -o /app

# Use ASP.NET runtime to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app ./

# Render requires port 8080
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]
