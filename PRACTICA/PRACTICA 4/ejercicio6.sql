USE tp4_ejercicio6;
/*
Técnico = (codTec, nombre, especialidad) // técnicos 
Repuesto = (codRep, nombre, stock, precio) // repuestos 
RepuestoReparacion  =  (nroReparac  (fk),  codRep  (fk),  cantidad,  precio) //  repuestos  utilizados  en 
reparaciones. 
Reparación = (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas.
*/

/*1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio.*/

SELECT nombre, stock, precio
FROM Repuesto
ORDER BY precio

/*2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no 
se usaron en reparaciones del técnico ‘José Gonzalez’. */

SELECT DISTINCT r.nombre, r.stock, r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
WHERE repa.fecha BETWEEN '2023-01-01' AND '2023-12-31' AND r.codRep NOT IN (
    SELECT r.codRep
    FROM Repuesto r INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
    INNER JOIN Tecnico tec ON (repa.codTec = tec.codTec)
    WHERE tec.nombre = "José Gonzalez"
)

/*3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar 
por nombre ascendentemente.*/

SELECT t.nombre, t.especialidad
FROM Tecnico t
WHERE NOT EXISTS(
    SELECT *
    FROM Reparacion r
    WHERE (r.codTec = t.codTec)
)
ORDER BY t.nombre

/*4. Listar  el  nombre  y  especialidad  de  los  técnicos  que  solamente  participaron  en  reparaciones 
durante  2022. */

SELECT DISTINCT t.nombre, t.especialidad
FROM Tecnico t
INNER JOIN Reparacion r ON (t.codTec = r.codTec)
WHERE (r.fecha BETWEEN '2022-01-01' AND '2022-12-31') AND NOT EXISTS(
    SELECT *
    FROM Reparacion r
    WHERE (r.codTec = t.codTec) AND NOT(r.fecha BETWEEN '2022-01-01' AND '2022-12-31')
)

/*5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un 
repuesto no participó en alguna reparación igual debe aparecer en dicho listado. */

SELECT repu.nombre, repu.stock, COUNT(DISTINCT rep.codTec) AS cantidadTecnicosDistintos
FROM Repuesto repu
LEFT JOIN RepuestoReparacion rr ON (repu.codRep = rr.codRep)
LEFT JOIN Reparacion rep ON (rr.nroReparac = rep.nroReparac)
GROUP BY repu.codRep, repu.nombre, repu.stock

/*6. Listar  nombre  y  especialidad  del  técnico  con  mayor cantidad de reparaciones realizadas y el 
técnico con menor cantidad de reparaciones.*/

SELECT t.nombre, t.especialidad
FROM Tecnico t
INNER JOIN Reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Reparacion r
    GROUP BY r.codTec
)
UNION
SELECT t.nombre, t.especialidad
FROM Tecnico t
INNER JOIN Reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) <= ALL (
    SELECT COUNT(*)
    FROM Reparacion r
    GROUP BY r.codTec
)

/*7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto 
no haya estado en reparaciones con un precio total superior a $10000.*/

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE r.stock > 0 AND NOT EXISTS(
    SELECT *
    FROM RepuestoReparacion rr
    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
    WHERE (rr.codRep = r.codRep) AND (repa.precio_total > 10000)   
)

/*8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto 
con precio en el momento de la reparación mayor a $10000 y menor a $15000.*/

SELECT DISTINCT repa.nroReparac, repa.fecha, repa.precio_total
FROM Reparacion repa
INNER JOIN RepuestoReparacion rr ON (repa.nroReparac = rr.nroReparac)
INNER JOIN Repuesto r ON (rr.codRep = r.codRep)
WHERE r.precio > 10000 AND r.precio < 15000

/*9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos.*/

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE NOT EXISTS(
    SELECT *
    FROM Tecnico t
    WHERE NOT EXISTS(
        SELECT *
        FROM RepuestoReparacion rr
        INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
        WHERE (rr.codRep = r.codRep) AND (repa.codTec = t.codTec)
    )
)

/*10. Listar  fecha,  técnico  y  precio  total  de  aquellas  reparaciones  que  necesitaron  al  menos  4 
repuestos distintos. */

SELECT repa.fecha, t.nombre, repa.precio_total, COUNT(*)
FROM Reparacion repa
INNER JOIN Tecnico t ON (repa.codTec = t.codTec)
INNER JOIN RepuestoReparacion rr ON (repa.nroReparac = rr.nroReparac)
GROUP BY repa.nroReparac, repa.fecha, t.nombre, repa.precio_total
HAVING COUNT(*) >= 4