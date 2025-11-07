# PowerShell Script để tải ảnh poster phim từ TMDB
# Chạy: .\download_movie_posters.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Download Movie Posters from TMDB" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Tạo thư mục images/movies nếu chưa có
$moviesDir = "images\movies"
if (-not (Test-Path $moviesDir)) {
    New-Item -ItemType Directory -Path $moviesDir -Force | Out-Null
    Write-Host "Created directory: $moviesDir" -ForegroundColor Green
}

# Danh sách phim và poster_path từ TMDB
$movies = @(
    @{
        Name = "avatar-way-of-water"
        Title = "Avatar: The Way of Water"
        PosterPath = "t6HIqrRAclMCA60NsSmeqe9RmNV.jpg"
    },
    @{
        Name = "black-panther-wakanda-forever"
        Title = "Black Panther: Wakanda Forever"
        PosterPath = "sv1xJUazXeYqALzczL3wBP5Qy7Q.jpg"
    },
    @{
        Name = "top-gun-maverick"
        Title = "Top Gun: Maverick"
        PosterPath = "62HCnUTziyWcpDaBO2i1DX17ljH.jpg"
    },
    @{
        Name = "spider-man-no-way-home"
        Title = "Spider-Man: No Way Home"
        PosterPath = "1g0dhYtq4irTY1GPXvft6k4YLjm.jpg"
    },
    @{
        Name = "the-batman"
        Title = "The Batman"
        PosterPath = "b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg"
    },
    @{
        Name = "avengers-endgame"
        Title = "Avengers: Endgame"
        PosterPath = "or06FN3Dka5tukK1e9sl16pB3iy.jpg"
    },
    @{
        Name = "dune"
        Title = "Dune"
        PosterPath = "d5NXSklXo0qyIYkgV94XAgMIckC.jpg"
    },
    @{
        Name = "no-time-to-die"
        Title = "No Time to Die"
        PosterPath = "iUZgBfTZ4VjZvqH7nPG3d3x2q5L.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/1U3pRCP1tGk2m6v5s7z7z7z7z7z7.jpg"
    },
    @{
        Name = "fast-furious-9"
        Title = "Fast & Furious 9"
        PosterPath = "bOFaAXmWWXC3Rbv4CB4x9FbWT4Y.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/bOFaAXmWWXC3Rbv4CB4x9FbWT4Y.jpg"
    },
    @{
        Name = "shang-chi-legend-ten-rings"
        Title = "Shang-Chi and the Legend of the Ten Rings"
        PosterPath = "1BIoJGKbXjdFDAqkHZ0ZLcuqJAV.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/1BIoJGKbXjdFDAqkHZ0ZLcuqJAV.jpg"
    },
    @{
        Name = "doctor-strange-multiverse-madness"
        Title = "Doctor Strange in the Multiverse of Madness"
        PosterPath = "9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg"
    },
    @{
        Name = "jurassic-world-dominion"
        Title = "Jurassic World Dominion"
        PosterPath = "kAVRgd7ZtGvZyniAXxZJTNph2HO.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/kAVRgd7ZtGvZyniAXxZJTNph2HO.jpg"
    },
    @{
        Name = "minions-rise-of-gru"
        Title = "Minions: The Rise of Gru"
        PosterPath = "wKiOkZTN9lUUUNZLmtnwubZYONg.jpg"
    },
    @{
        Name = "everything-everywhere-all-at-once"
        Title = "Everything Everywhere All at Once"
        PosterPath = "w3LxiVYdWWRvEVl5oL8AbPx4rSb.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/w3LxiVYdWWRvEVl5oL8AbPx4rSb.jpg"
    },
    @{
        Name = "matrix-resurrections"
        Title = "The Matrix Resurrections"
        PosterPath = "8c4a8kE3P8o8KyE4W44k6iTjnLp.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/8c4a8kE3P8o8KyE4W44k6iTjnLp.jpg"
    },
    @{
        Name = "encanto"
        Title = "Encanto"
        PosterPath = "4j0PNHkMr5ax3IA8tjtxcmPU3QT.jpg"
    },
    @{
        Name = "free-guy"
        Title = "Free Guy"
        PosterPath = "xmbU4JTUm8rsdtn7Y3Fcm30GpeT.jpg"
    },
    @{
        Name = "cruella"
        Title = "Cruella"
        PosterPath = "rTh4K5uw9Hyp8gxVcUIULehfioV.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/rTh4K5uw9Hyp8gxVcUIULehfioV.jpg"
    },
    @{
        Name = "luca"
        Title = "Luca"
        PosterPath = "jTswp6KyD3tv8W5UEX8hw0HlAh8.jpg"
        DirectUrl = "https://image.tmdb.org/t/p/w500/jTswp6KyD3tv8W5UEX8hw0HlAh8.jpg"
    }
)

# Base URL TMDB (w500 = width 500px)
$baseUrl = "https://image.tmdb.org/t/p/w500"

# Tải từng ảnh
$successCount = 0
$failCount = 0

Write-Host "Starting download..." -ForegroundColor Yellow
Write-Host ""

foreach ($movie in $movies) {
    # Sử dụng DirectUrl nếu có, nếu không thì dùng baseUrl + PosterPath
    if ($movie.DirectUrl) {
        $imageUrl = $movie.DirectUrl
    } else {
        $imageUrl = "$baseUrl/$($movie.PosterPath)"
    }
    
    $outputFile = "$moviesDir\$($movie.Name).jpg"
    
    Write-Host "[$($successCount + $failCount + 1)/$($movies.Count)] Downloading: $($movie.Title)..." -ForegroundColor Yellow
    
    try {
        # Kiểm tra file đã tồn tại chưa
        if (Test-Path $outputFile) {
            Write-Host "  [SKIP] File already exists, skipping..." -ForegroundColor Gray
            $successCount++
            continue
        }
        
        Invoke-WebRequest -Uri $imageUrl -OutFile $outputFile -ErrorAction Stop
        $fileSize = (Get-Item $outputFile).Length / 1KB
        $fileSizeRounded = [math]::Round($fileSize, 2)
        Write-Host "  [OK] Saved: $outputFile ($fileSizeRounded KB)" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "  [ERROR] Failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "  [INFO] Try downloading manually from: $imageUrl" -ForegroundColor Yellow
        $failCount++
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Download Complete!" -ForegroundColor Cyan
Write-Host "  [SUCCESS] $successCount" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "  [FAILED]  $failCount" -ForegroundColor Red
}
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if ($successCount -eq $movies.Count) {
    Write-Host "All movie posters downloaded successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Download cinema images manually from Google Images" -ForegroundColor White
    Write-Host "2. Upload all images to Cloudinary:" -ForegroundColor White
    Write-Host "   - Upload to: movie_ticket_app/movies/" -ForegroundColor Gray
    Write-Host "   - Upload to: movie_ticket_app/cinemas/" -ForegroundColor Gray
    Write-Host "3. Copy URLs from Cloudinary" -ForegroundColor White
    Write-Host "4. Update URLs in data.sql" -ForegroundColor White
    Write-Host ""
    
    # Mở thư mục ảnh
    if (Test-Path $moviesDir) {
        Write-Host "Opening images folder..." -ForegroundColor Cyan
        Start-Process explorer.exe -ArgumentList (Resolve-Path $moviesDir)
    }
} else {
    Write-Host "Some downloads failed. Please check the errors above." -ForegroundColor Yellow
}

