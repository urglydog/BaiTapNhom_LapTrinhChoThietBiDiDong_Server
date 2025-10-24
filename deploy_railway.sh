#!/bin/bash

# =============================================
# Railway Deployment Script
# Tự động deploy database và application
# =============================================

echo "🚀 Starting Railway deployment..."

# 1. Kiểm tra Railway CLI
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
fi

# 2. Login Railway
echo "🔐 Logging into Railway..."
railway login

# 3. Tạo project (nếu chưa có)
echo "📁 Creating Railway project..."
railway init

# 4. Thêm SQL Server database
echo "🗄️ Adding SQL Server database..."
echo "Please add SQL Server database manually from Railway dashboard:"
echo "1. Go to Railway dashboard"
echo "2. Click 'New' → 'Database' → 'Add SQL Server'"
echo "3. Wait for database to be created"
echo "Press Enter when database is ready..."
read

# 5. Lấy database connection info
echo "📋 Getting database connection info..."
railway variables

# 6. Chạy SQL script
echo "📝 Running SQL script..."
railway run sqlcmd -i railway_database_setup.sql

# 7. Deploy application
echo "🚀 Deploying application..."
railway up

# 8. Kiểm tra deployment
echo "✅ Checking deployment status..."
railway status

# 9. Xem logs
echo "📊 Viewing logs..."
railway logs

echo "🎉 Deployment completed!"
echo "Your app is available at: https://your-app.railway.app"
echo "API endpoints:"
echo "- GET https://your-app.railway.app/api/movies"
echo "- GET https://your-app.railway.app/api/cinemas"
