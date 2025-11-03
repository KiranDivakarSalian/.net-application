# Use the .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY Bulky.sln ./Bulky.sln
COPY Bulky.DataAccess/Bulky.DataAccess.csproj Bulky.DataAccess/
COPY Bulky.Models/BulkyBook.Models.csproj Bulky.Models/
COPY Bulky.Utility/BulkyBook.Utility.csproj Bulky.Utility/
COPY BulkyWeb/BulkyBookWeb.csproj BulkyWeb/

# Restore dependencies
RUN dotnet restore BulkyWeb/BulkyBookWeb.csproj

# Copy the rest of the code
COPY . .

# Publish the project
WORKDIR /src/BulkyWeb
RUN dotnet publish -c Release -o /app

# Use the ASP.NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app ./

# Expose Render’s required port
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]
