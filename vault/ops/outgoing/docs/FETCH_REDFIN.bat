@echo off
REM Batch file to fetch Redfin property value and update Supabase
REM
REM Prerequisites:
REM   1. Python 3.10+ installed
REM   2. Required packages: pip install requests beautifulsoup4 supabase
REM   3. SUPABASE_URL and SUPABASE_KEY environment variables set
REM   4. REDFIN_COOKIE environment variable set (optional, for owner dashboard)
REM
REM Usage: Double-click this file or run from command prompt

echo ========================================
echo Redfin Property Value Fetcher
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.10+ from python.org
    pause
    exit /b 1
)

REM Check if SUPABASE_URL is set
if "%SUPABASE_URL%"=="" (
    echo ERROR: SUPABASE_URL and SUPABASE_KEY environment variables not set
    echo.
    echo Set them with:
    echo   setx SUPABASE_URL "https://uuvsvtpfcexhqojlrsxy.supabase.co"
    echo   setx SUPABASE_KEY "your_key_here"
    echo.
    pause
    exit /b 1
)

REM Navigate to script directory
cd /d "%~dp0"

REM Run the Python script
python fetch_redfin_property_value.py

REM Check exit code
if errorlevel 1 (
    echo.
    echo Script failed with errors.
) else (
    echo.
    echo Script completed successfully!
)

echo.
pause
