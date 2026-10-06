@echo off

:: 1. Configurar DNS Local
SET DOMAIN=inventory.uru.local
find /i "%DOMAIN%" "%WINDIR%\System32\drivers\etc\hosts" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo 127.0.0.1 %DOMAIN% >> "%WINDIR%\System32\drivers\etc\hosts"
)

:: 2. Crear la red (silenciosamente)
docker network create uru_network >nul 2>&1

:: 3. Desplegar Backend (ya estamos en web-2-backend)
git pull origin main >nul 2>&1
docker compose -f docker-compose.prod.yml up -d --build >nul 2>&1

:: 4. Movernos al Frontend y desplegar
cd ..\web-2-frontend
git pull origin main >nul 2>&1
docker compose up -d --build >nul 2>&1
cd ..\web-2-backend

:: 5. Limpiar imagenes residuales
docker image prune -f >nul 2>&1
