## 🎵 Proyecto 2: Music Stream - GRUPO 1 - STELLA APIS ✨
Por Gema Antón, Elena Jiménez, María Nicolás e Irina Ostojic 

## 🌐 Descripción del proyecto
Este proyecto ha sido desarrollado en equipo como práctica dentro del Bootcamp de Data Analytics de Adalab.

Consiste en la extracción y análisis de datos musicales con Python a través de las APIs de Spotify y Last.fm, con el objetivo de almacenarlos en una base de datos relacional y aplicar consultas en MySQL para descubrir patrones de consumo y preferencias del público.

## 🕯️ Storytelling
 Ambientado en un storytelling original: cuatro hermanas de un convento deciden formar su propio grupo musical. Para lograrlo, se embarcan en una misión analítica para entender a su audiencia, estudiar sus hábitos de escucha y diseñar una estrategia que les permita triunfar en el mundo del musical espiritual.

## 🧰 Tecnologías utilizadas
- Python: Requests, Pandas, MySQL Connector, SQL Alchemy
- SQL: joins, subconsultas, funciones agregadas
- Herramientas: Jupyter Notebook, Drive, GitHub
- Visuales: Canvas e IA

## 📃 Pasos a dar
1. Para asegurar una óptima extracción de datos, se recomienda ejecutar celda a celda los 2 primeros archivos del Jupyter según el orden establecido. Primero:`1-Spotify` y segundo: `2-Last_FM`. 
Nota: El primer método de extracción de Spotify puede tardar unos 5-10 minutos en completarse. Paciencia!
2. # IMPORTANTE!  
Antes de ejecutar el documento `3-Conexion_Pyhton-SQL` hay que abrir en MySQL el documento `BBDD_STELLA_APIS_final` y ejecutar la primera línea de código: `CREATE SCHEMA IF NOT EXISTS STELLA_APIS_BBDD;`
3. Una vez creada nuestra BBDD, ahora sí, nos vamos al archivo `3-Conexión_Pyhton-SQL` y ejecutamos las celdas. Otra vez, una a una.
4. Nos vamos de nuevo a SQL y actualizamos nuestras BBDD. Veremos que en `STELLA_APIS_BBDD` se han creado tres columnas: `albums_v2`, `canciones_v2` y `bio_artistas_v2`. Será a través de las cuales haremos las consultas.
5. Ejecutamos todas las primeras líneas de código para normalizar, limpiar y unificar tipos de datos. Esto va desde `USE BBDD_STELLA_APIS_bbdd;`
hasta la línea 50 del código, donde ya empezamos a realizar las consultas.

## 📦 Contenido del repositorio
📁 1-Spotify.ipynb                  → Consultas y extracción de 1000 álbumes y 1000 canciones  
📁 2-Last_FM.ipynb                  → Consulta y extracción de información sobre el artista en relación a lo extraido en Spotify
📁 3-Conexion_Python-SQL.ipynb      → Documento de conexión para traspasar información de Python a la BBDD de MySQL  
📁 BBDD_STELLA_APIS_final.sql       → Base de datos donde realizaremos las consultas 
🗄 albums_v2.csv                     → CSVs extraídos de la API de Spotify
🗄 artistas_v2.csv                   → CSVs extraídos de la API de Spotify
🗄 bio_artistas_v2.csv               → CSVs extraídos de la API de LastFM
🗄 canciones_v2.csv                  → CSVs extraídos de la API de Spotify 
📸 diagrama.png                     → Captura del diagrama de nuestra BBDD
📊 diagrama.mysql                   → Diagrama de nuestra BBDD
📄 README.md                        → Este documento  

## 🔍 Proceso técnico
- Extracción de las APIs
    Se extrajeron datos de artistas, canciones y géneros.
    Se documentaron desfases y errores comunes (timeouts, duplicados).

- Limpieza y carga
    Transformación a CSV y carga en SQL.
    Limpieza y normalización de nombres.

- Consultas SQL
    Algunas consultas destacadas: 
    1. Cinco con mayor valoración
    2. Cinco artistas con más oyentes
    3. Más escuchado de cada género
    4. Qué artista ha lanzado más álbumes por género
    5. ¿Cuál es el género predominante entre los artistas más populares?
    6. Cuál es el álbum más valorado de los años
    7. ¿En qué año se lanzaron más álbumes?
    8. Cuál es el artista con más canciones por género

## 📚 Aprendizajes y reflexiones
- Los errores de extracción se convirtieron en oportunidades de repaso y aprendizaje.
- La lógica relacional permite descubrir conexiones culturales inesperadas.
- Las consultas SQL se convirtieron en herramientas de exploración cultural, no solo técnica.

## 📝 Próximos pasos
- Automatizar la extracción creando funciones que incluyan también el control de errores o tiempos de espera.
- Integrar visualizaciones con Matplotlib.
- Integrar scraping de redes sociales para cruzar fandom y consumo musical.
- Ampliar nuestras búsquedas a un mercado internacional
- Cruzar datos de popularidad con variables culturales (por ejemplo, qué géneros triunfan en países con fuerte tradición religiosa?).
- Simular una gira musical con ciudades seleccionadas según el volumen de escuchas por región.
- Explorar en las APIs otros géneros emergentes (trap japonés, flamenco urbano) o años más actuales.
- Añadir más fuentes de datos (otras APIs, otras BBDD existentes).

## 📑 Enlace a la presentación
https://www.canva.com/design/DAGyOhtN9zs/ES3TeyiN22Rcu_s62qlaqA/edit?utm_content=DAGyOhtN9zs&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton