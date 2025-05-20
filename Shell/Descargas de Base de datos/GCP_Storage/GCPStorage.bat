@echo off
setlocal enabledelayedexpansion

:: Ruta del archivo .env
set "ENV_FILE=%LOCAL_DIR%\config\config.env2"

:: Verificar si el archivo .env existe
if not exist "%ENV_FILE%" (
    echo ERROR: El archivo de configuración no se encuentra en %ENV_FILE%
    pause
    exit /b
)

:: Cargar variables desde el archivo .env
for /f "tokens=1,2 delims==" %%a in ('type "%ENV_FILE%"') do set "%%a=%%b"

:: Mostrar variables cargadas (para verificación)
echo BUCKET_NAME=%BUCKET_NAME%

:: Definir variables con valores del .env
set "GCS_PATH_1=gs://%BUCKET_NAME%/REPORTE_000000000000.txt"
set "LOCAL_PATH=%LOCAL_DIR%\REPORTE"


:: Descargar archivo(s) desde Google Cloud Storage POSTPAGO
echo Ejecutando: gsutil cp "%GCS_PATH_1%" "%LOCAL_PATH%"
call gsutil cp "%GCS_PATH_1%" "%LOCAL_PATH%"
if errorlevel 1 (
    echo ERROR: Falló la descarga del archivo.
    pause
    exit /b
)

echo ARCHIVO DESCARGADO


set "REPORTE_ENCABEZADO=%LOCAL_DIR%\Encabezados.txt"
set "REPORTE_GCS=%LOCAL_DIR%\REPORTE_000000000000.txt"
set "REPORTE_SALIDA=%LOCAL_DIR%\REPORTE.txt"

copy /b "%REPORTE_ENCABEZADO%" + "%REPORTE_GCS%" "%REPORTE_SALIDA%"
echo Archivos combinados en "%REPORTE_SALIDA%"

endlocal