USE tp4_ejercicio3;

/*
Banda = (codigoB, nombreBanda, genero_musical, anio_creacion)  
Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))  
Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)  
Recital = (fecha, hora, nroEscenario (fk), codigoB (fk)) 
*/

/*1. Listar DNI, nombre, apellido,dirección y email de integrantes nacidos entre 1980 y 1990 y que 
hayan realizado algún recital durante 2023. */

SELECT i.DNI, i.nombre, i.apellido, i.direccion, i.email
FROM Integrante i INNER JOIN Banda b ON (i.codigoB = b.codigoB)
WHERE (i.fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31')
AND i.DNI IN (
    SELECT i.DNI
    FROM Recital r
    INNER JOIN Banda b ON (r.codigoB = b.codigoB)
    INNER JOIN Integrante i ON (i.codigoB = b.codigoB)
    WHERE r.codigoB = b.codigoB AND fecha BETWEEN '2023-01-01' AND '2023-12-31'
);

/*Alternativa*/
SELECT i.DNI, i.nombre, i.apellido, i.direccion, i.email
FROM Integrante i INNER JOIN Banda b ON (i.codigoB = b.codigoB)
WHERE (i.fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31')
AND EXISTS(
    SELECT * FROM Recital r
    WHERE r.codigoB = b.codigoB AND fecha BETWEEN '2023-01-01' AND '2023-12-31'
);

/*2. Reportar  nombre, género musical y año de creación de bandas que hayan realizado recitales 
durante 2023, pero no hayan tocado durante 2022.*/

SELECT DISTINCT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE (r.fecha BETWEEN '2023-01-01' AND '2023-12-31') AND b.codigoB NOT IN(
    SELECT b.codigoB
    FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
    WHERE r.fecha BETWEEN '2022-01-01' AND '2022-12-31'
)

/*Alternativa*/

SELECT DISTINCT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE (r.fecha BETWEEN '2023-01-01' AND '2023-12-31')
AND NOT EXISTS(
    SELECT *
    FROM Recital r
    WHERE r.codigoB = b.codigoB AND fecha BETWEEN '2022-01-01' AND '2022-12-31'
)

/*3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que 
ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente.*/

SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario, e.ubicacion
FROM Banda b
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE r.fecha = '2023-12-04'

/*4. Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con nombre 
‘Gustavo Cerati’ y en el escenario  con nombre ‘Carlos Gardel’. */

SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Recital r
INNER JOIN Integrante i ON (r.codigoB = i.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE (e.nombre_escenario = "Gustavo Cerati") AND i.DNI IN (
    SELECT i.DNI
    FROM Recital r
    INNER JOIN Integrante i ON (r.codigoB = i.codigoB)
    INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
    WHERE e.nombre_escenario = "Carlos Gardel"
) 

/*5. Reportar nombre, género musical y año de creación de bandas que tengan más de 5 integrantes. */

SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
INNER JOIN Integrante i ON (i.codigoB = b.codigoB)
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.anio_creacion
HAVING COUNT(*) > 5

/*6. Listar  nombre  de escenario, ubicación y descripción de escenarios que solo tuvieron recitales 
con el género musical rock and roll. Ordenar por nombre de escenario */

SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM Escenario e
INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
INNER JOIN Banda b ON (r.codigoB = b.codigoB)
WHERE (b.genero_musical = 'Rock') AND e.nroEscenario NOT IN(
    SELECT e.nroEscenario
    FROM Escenario e
    INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
    INNER JOIN Banda b ON (r.codigoB = b.codigoB)
    WHERE (b.genero_musical <> 'Rock')
)

/*7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en 
escenarios cubiertos durante 2023.// cubierto es true, false según corresponda*/

SELECT DISTINCT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE (e.cubierto = TRUE) AND (r.fecha BETWEEN '2023-01-01' AND '2023-12-31')

/*8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024. */

SELECT e.nombre_escenario, COUNT(*) AS cantidad_recitales
FROM Escenario e
INNER JOIN Recital r ON (r.nroEscenario = e.nroEscenario)
WHERE r.fecha BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY e.nroEscenario, e.nombre_escenario

/*9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’.  */

UPDATE Banda SET nombreBanda='Memphis la Blusera' WHERE nombreBanda='Mempis la Blusera'