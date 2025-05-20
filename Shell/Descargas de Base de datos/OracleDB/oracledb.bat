##########################################################################
#                                                                        #
#             Descarga de datos desde una base de datos Oracle           #
#                                                                        #
##########################################################################


@echo off
setlocal
REM PASO 1.1: Cargar variables de entorno desde config.env
for /f "usebackq delims=" %%A in ("config.env2") do (
    set "line=%%A"
    if not defined line (
        REM línea vacía, saltar
    ) else (
        echo !line! | findstr /b /r "[ ]*#" >nul
        if errorlevel 1 (
            for /f "tokens=1,* delims==" %%B in ("!line!") do (
                set "%%B=%%C"
            )
        )
    )
)
setlocal enabledelayedexpansion

REM PASO 1.2: Construir el string de conexión usando las variables cargadas del archivo env
set "CONN_STR=%ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST%:%ORACLE_PORT%/%ORACLE_SID%"

REM PASO 1.3: Configurar el archivo SQL a ejecutar
set "SQL_FILE=script.sql"

REM PASO 2: EJECUTAR EL SCRIPT SQL
echo Ejecutando consulta SQL...
sqlplus -S "%CONN_STR%" @"%SQL_FILE%"


