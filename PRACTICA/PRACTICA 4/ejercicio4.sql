USE tp4_ejercicio4;

/*
Persona = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero) 
Alumno = (DNI (fk), Legajo, Anio_Ingreso) 
Profesor = (DNI (fk), Matricula, Nro_Expediente) 
Titulo = (Cod_Titulo, Nombre, Descripcion) 
Titulo-Profesor = (Cod_Titulo (fk), DNI (fk), Fecha) 
Curso = (Cod_Curso, Nombre, Descripcion, Fecha_Creacion, Duracion) 
Alumno-Curso = (DNI (fk), Cod_Curso (fk), Anio, Desempenio, Calificacion) 
Profesor-Curso = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta?)
*/

/*1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a 
2014 */

SELECT p.DNI, a.legajo, p.apellido, p.nombre
FROM Persona p
INNER JOIN Alumno a ON (p.DNI = a.DNI)
WHERE (a.Anio_Ingreso < 2014)

/*2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de 
100 horas de duración. Ordenar por DNI. */

SELECT DISTINCT p.DNI, pro.matricula, p.apellido, p.nombre
FROM Persona p
INNER JOIN Profesor pro ON (p.DNI = pro.DNI)
INNER JOIN Profesor_Curso pc ON (pro.DNI = pc.DNI)
INNER JOIN Curso c ON (pc.cod_curso = c.cod_curso)
WHERE c.duracion > 100
ORDER BY p.DNI

/*3. Listar  el  DNI,  Apellido,  Nombre,  Género  y  Fecha  de  nacimiento  de los alumnos inscriptos al 
curso con nombre “Diseño de Bases de Datos” en 2023. */

SELECT p.DNI, p.apellido, p.nombre, p.genero, p.fecha_nacimiento
FROM Persona p
INNER JOIN Alumno a ON (p.DNI = a.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.cod_curso = c.cod_curso)
WHERE c.nombre = 'Diseño de Bases de Datos' AND ac.anio = 2023

/*4. Listar  el  DNI,  Apellido,  Nombre  y  Calificación  de  aquellos  alumnos  que  obtuvieron  una 
calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá 
estar ordenado por Apellido y nombre. */

SELECT p.DNI, p.apellido, p.nombre, ac.calificacion
FROM Persona p
INNER JOIN Alumno a ON (p.DNI = a.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.cod_curso = c.cod_curso)
WHERE ac.calificacion > 8 AND a.DNI IN (
    SELECT a.DNI
    FROM Alumno a
    INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
    INNER JOIN Curso c ON (ac.cod_curso = c.cod_curso)
    INNER JOIN Profesor_Curso pc ON (c.cod_curso = pc.cod_curso)
    INNER JOIN Persona per ON (pc.DNI = per.DNI)
    WHERE per.nombre = 'Juan' AND per.apellido = 'Garcia'
)
ORDER BY p.apellido, p.nombre

/*Alternativa mejor */

SELECT p.DNI, p.apellido, p.nombre, ac.calificacion
FROM Persona p
INNER JOIN Alumno a ON (p.DNI = a.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.cod_curso = c.cod_curso)
INNER JOIN Profesor_Curso pc ON (c.cod_curso = pc.cod_curso)
INNER JOIN Persona pro ON (pc.DNI = pro.DNI)
WHERE (ac.calificacion > 8) AND (pro.nombre = 'Juan') AND (pro.apellido = 'Garcia')
ORDER BY p.apellido, p.nombre

/*5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos. 
Dicho listado deberá estar ordenado por Apellido y Nombre. */

SELECT p.DNI, p.apellido, p.nombre, pro.matricula, COUNT(*)
FROM Persona p
INNER JOIN Profesor pro ON (p.DNI = pro.DNI)
INNER JOIN Titulo_Profesor tp ON (pro.DNI = tp.DNI)
GROUP BY p.DNI, p.apellido, p.nombre, pro.matricula
HAVING COUNT(*) > 3
ORDER BY p.apellido, p.nombre

/*6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor. 
La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta. */

SELECT p.DNI, p.apellido, p.nombre, SUM(c.duracion), AVG(c.duracion)
FROM Persona p
LEFT JOIN Profesor_Curso pc ON (p.DNI = pc.DNI)
LEFT JOIN Curso c ON (pc.cod_curso = c.cod_curso)
GROUP BY p.DNI, p.apellido, p.nombre

/*7. Listar  Nombre  y  Descripción  del  curso  que  posea  más  alumnos  inscriptos  y  del  que  posea 
menos alumnos inscriptos durante 2024. */

SELECT c.nombre, c.descripcion
FROM Curso c
INNER JOIN Alumno_Curso ac ON (c.cod_curso = ac.cod_curso)
WHERE ac.anio = 2024
GROUP BY c.cod_curso, c.nombre, c.descripcion
HAVING COUNT (*) >= ALL (
    SELECT COUNT(*)
    FROM Alumno_Curso ac
    WHERE ac.anio = 2024
    GROUP BY c.cod_curso
)
UNION
SELECT c.nombre, c.descripcion
FROM Curso c
INNER JOIN Alumno_Curso ac ON (c.cod_curso = ac.cod_curso)
WHERE ac.anio = 2024
GROUP BY c.cod_curso, c.nombre, c.descripcion
HAVING COUNT (*) <= ALL (
    SELECT COUNT(*)
    FROM Alumno_Curso ac
    WHERE ac.anio = 2024
    GROUP BY c.cod_curso
)

/*8. Listar  el  DNI,  Apellido,  Nombre  y  Legajo  de  alumnos  que  realizaron  cursos  con  nombre 
conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023. */

SELECT p.DNI, p.apellido, p.nombre, a.legajo
FROM Persona p
INNER JOIN Alumno a ON (p.DNI = a.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.cod_curso = c.cod_curso)
WHERE (c.nombre LIKE '%BD%') AND (ac.anio = 2022) AND a.DNI NOT IN(
    SELECT ac.DNI
    FROM Alumno_Curso ac
    WHERE ac.anio = 2023
)

/*9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25. */


INSERT INTO Persona (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero) VALUES (31313131, 'Perez', 'Carlos', '1980-05-15', 'Soltero', 'M');
INSERT INTO Profesor (DNI, Matricula, Nro_Expediente) VALUES (31313131, 'MAT-400', 5004);
INSERT INTO Titulo_Profesor (Cod_Titulo, DNI, Fecha) VALUES (25, 31313131, '2026-11-01');

/*10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado. */

UPDATE Persona SET Estado_Civil = 'Divorciado' WHERE DNI IN (SELECT a.DNI FROM Alumno a WHERE a.legajo = '2020/09');

/*11. Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el 
conjunto de relaciones en un estado inconsistente. */

DELETE FROM Alumno_Curso WHERE DNI = 30568989;
DELETE FROM Alumno WHERE DNI = 30568989;
DELETE FROM Persona WHERE DNI = 30568989;
