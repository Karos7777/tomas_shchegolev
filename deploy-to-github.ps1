# PowerShell скрипт для автоматической загрузки сайта на GitHub Pages
param(
    [string]$RepoUrl = "https://github.com/Karos7777/tomas_shchegolev.git"
)

Write-Host "=== Загрузка портфолио на GitHub Pages ===" -ForegroundColor Cyan

$CurrentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $CurrentDir

# Проверка git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Ошибка: Git не установлен или не найден в PATH." -ForegroundColor Red
    exit 1
}

# Инициализация git если ещё не инициализирован
if (-not (Test-Path ".git")) {
    Write-Host "Инициализируем локальный Git репозиторий..." -ForegroundColor Yellow
    git init -b main
    git remote add origin $RepoUrl
} else {
    Write-Host "Проверяем remote origin..." -ForegroundColor Yellow
    $existingRemote = git remote get-url origin 2>$null
    if (-not $existingRemote) {
        git remote add origin $RepoUrl
    }
}

Write-Host "Добавляем файлы..." -ForegroundColor Yellow
git add .nojekyll favicon.svg index.html README.md assets/

$status = git status --porcelain
if ($status) {
    Write-Host "Создаём коммит..." -ForegroundColor Yellow
    git commit -m "Update portfolio with full visual effects, animations and assets"
    
    Write-Host "Отправляем на GitHub (main branch)..." -ForegroundColor Yellow
    git push -u origin main --force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nГотово! Файлы успешно выгружены на GitHub." -ForegroundColor Green
        Write-Host "Теперь проверь в настройках репозитория: Settings -> Pages -> Deploy from a branch -> main / (root)." -ForegroundColor Cyan
    } else {
        Write-Host "`nНе удалось отправить. Возможно требуется авторизация в GitHub (git login или Personal Access Token)." -ForegroundColor Red
    }
} else {
    Write-Host "Нет изменений для коммита. Все файлы уже актуальны." -ForegroundColor Green
}
