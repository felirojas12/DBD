USE tp4_ejercicio2;

/*
Localidad = (codigoPostal, nombreL, descripcion, nroHabitantes) 
Arbol = (nroArbol, especie, anios, calle, nro, codigoPostal(fk)) 
Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk)) 
Poda = (codPoda, fecha, DNI(fk), nroArbol(fk))
*/

/*1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por 
el podador ‘Jose Garcia’.*/

SELECT DISTINCT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
INNER JOIN Poda pod ON (a.nroArbol = pod.nroArbol)
INNER JOIN Podador p ON (pod.DNI = p.DNI)
WHERE (p.nombre = 'Juan' AND p.apellido = 'Perez') AND a.nroArbol IN (
    SELECT a.nroArbol
    FROM Arbol a
    INNER JOIN Poda pod ON (a.nroArbol = pod.nroArbol)
    INNER JOIN Podador p ON (pod.DNI = p.DNI)
    WHERE p.nombre = 'Jose' AND p.apellido = 'Garcia'
)

/*2. Reportar  DNI,  nombre,  apellido,  fecha  de  nacimiento  y  localidad  donde  viven  de  aquellos 
podadores que tengan podas realizadas durante 2023.*/

SELECT DISTINCT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM Podador p
INNER JOIN Localidad l ON (p.codigoPostalVive = l.codigoPostal)
INNER JOIN Poda pod ON (p.DNI = pod.DNI)
WHERE pod.fecha BETWEEN '2023-01-01' AND '2023-12-31'

/*3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca. */

SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE a.nroArbol NOT IN(
    SELECT a.nroArbol
    FROM Arbol a
    INNER JOIN Poda pod ON (a.nroArbol = pod.nroArbol)
)

/*4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y  no 
fueron podados durante 2023. */

SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
INNER JOIN Poda pod ON (a.nroArbol = pod.nroArbol)
WHERE (pod.fecha BETWEEN '2022-01-01' AND '2022-12-31') AND a.nroArbol NOT IN(
    SELECT a.nroArbol
    FROM Arbol a
    INNER JOIN Poda pod ON (a.nroArbol = pod.nroArbol)
    WHERE pod.fecha BETWEEN '2023-01-01' AND '2023-12-31'
)

/*5. Reportar  DNI,  nombre,  apellido,  fecha  de  nacimiento  y  localidad  donde  viven  de  aquellos 
podadores con apellido terminado con el string ‘ata’  y que tengan al menos una poda durante 
2024. Ordenar por apellido y nombre. */

SELECT DISTINCT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM Podador p
INNER JOIN Localidad l ON (p.codigoPostalVive = l.codigoPostal)
INNER JOIN Poda pod ON (p.DNI = pod.DNI)
WHERE (p.apellido LIKE '%ata') AND p.DNI IN (
    SELECT p.DNI
    FROM Podador p
    INNER JOIN Poda pod ON (p.DNI = pod.DNI)
    WHERE pod.fecha BETWEEN '2024-01-01' AND '2024-12-31'
)
ORDER BY p.apellido, p.nombre

/*6. Listar  DNI,  apellido,  nombre,  teléfono  y  fecha  de nacimiento de podadores que solo podaron 
árboles de especie ‘Coníferas’. */

SELECT p.DNI, p.apellido, p.nombre, p.telefono, p.fnac
FROM Podador p
INNER JOIN Poda pod ON (p.DNI = pod.DNI)
INNER JOIN Arbol a ON (pod.nroArbol = a.nroArbol)
WHERE a.especie = 'Conífera' AND p.DNI NOT IN (
    SELECT p.DNI
    FROM Podador p
    INNER JOIN Poda pod ON (p.DNI = pod.DNI)
    INNER JOIN Arbol a ON (pod.nroArbol = a.nroArbol)
    WHERE a.especie <> 'Conífera'
)

/*7. Listar  especies  de  árboles  que  se  encuentren  en  la  localidad  de  ‘La  Plata’  y  también  en  la 
localidad de ‘Salta’.*/

SELECT a.especie
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE (l.nombreL = 'La Plata') AND a.especie IN (
    SELECT a.especie
    FROM Arbol a
    INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
    WHERE (l.nombreL = 'Salta')
)

/*8. Eliminar el podador con DNI 22234566.*/
DELETE FROM Poda WHERE DNI=22234566;
DELETE FROM Podador WHERE DNI=22234566;

/*9. Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 5 
árboles. */

SELECT l.nombreL, l.descripcion, l.nroHabitantes
FROM Localidad l
INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
GROUP BY l.nombreL, l.descripcion, l.nroHabitantes
HAVING COUNT(*) < 5