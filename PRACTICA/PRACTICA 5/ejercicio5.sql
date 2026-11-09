USE tp4_ejercicio5;
/*
Agencia = (razon_social, dirección, telef, email) 
Ciudad = (codigo_postal, nombreCiudad, anioCreacion) 
Cliente = (dni, nombre, apellido, telefono, direccion) 
Viaje  =  (fecha,  hora,  dni  (fk),  cpOrigen(fk),  cpDestino(fk),  razon_social(fk),  descripcion)  //cpOrigen  y 
cpDestino corresponden a la ciudades origen y destino del viaje
*/

/*1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La 
Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por 
teléfono. */

SELECT a.razon_social, a.direccion, a.telef
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
INNER JOIN Cliente c ON (v.dni = c.dni)
INNER JOIN Ciudad ciu ON (v.cpOrigen = ciu.codigo_postal)
WHERE (ciu.nombreCiudad = 'La Plata') AND (c.apellido = 'Roma')
ORDER BY a.razon_social, a.telef;

/*2. Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y destino de viajes 
realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’. */

SELECT v.fecha, v.hora, c.dni, c.nombre, c.apellido, c.telefono, c.direccion, ciuO.nombreCiudad AS ciudad_origen, ciuD.nombreCiudad AS ciudad_destino
FROM Viaje v
INNER JOIN Cliente c ON (v.DNI = c.DNI)
INNER JOIN Ciudad ciuO ON (v.cpOrigen = ciuO.codigo_postal)
INNER JOIN Ciudad ciuD ON (v.cpDestino = ciuD.codigo_postal)
WHERE (v.fecha BETWEEN '2019-01-01' AND '2019-01-31') AND (v.descripcion LIKE '%demorado%')

/*3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de 
mail que termine con  ‘@jmail.com’. */

SELECT DISTINCT a.razon_social, a.direccion, a.telef, a.email
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
WHERE (v.fecha BETWEEN '2019-01-01' AND '2019-12-31') OR (a.email LIKE '%@jmail.com')

/*4. Listar  datos  personales  de  clientes  que  viajaron  solo  con  destino  a  la  ciudad  de  ‘Coronel 
Brandsen’. */

SELECT DISTINCT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Viaje v ON (v.dni = c.dni)
INNER JOIN Ciudad ciuD ON (v.cpDestino = ciuD.codigo_postal)
WHERE (ciuD.nombreCiudad = 'Coronel Brandsen') AND c.dni NOT IN (
    SELECT c.DNI
    FROM Cliente c
    INNER JOIN Viaje v ON (v.dni = c.dni)
    INNER JOIN Ciudad ciuD ON (v.cpDestino = ciuD.codigo_postal)
    WHERE (ciuD.nombreCiudad <> 'Coronel Brandsen')
)

/*5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’. */

SELECT COUNT(*) AS cantidad_viajes
FROM Viaje v
INNER JOIN Ciudad ciuD ON (v.cpDestino = ciuD.codigo_postal)
WHERE (v.razon_social = 'TAXI Y') AND (ciuD.nombreCiudad = 'Coronel Brandsen')

/*6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias. */

SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c
WHERE NOT EXISTS (
    SELECT a.razon_social
    FROM Agencia a
    WHERE NOT EXISTS (
        SELECT v.razon_social
        FROM Viaje v
        WHERE (v.dni = c.dni) AND (v.razon_social = a.razon_social)
    )
)

/*7. Modificar el cliente con DNI 38495444  actualizando el teléfono a ‘221-4400897’. */

UPDATE Cliente SET telefono = '221-4400897' WHERE dni = 38495444;

/*8. Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes 
realizados. */

SELECT a.razon_social, a.direccion, a.telef
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
GROUP BY a.razon_social, a.direccion, a.telef
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM Viaje v
    GROUP BY v.razon_social
)

/*9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 5 viajes.  */

SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c
INNER JOIN Viaje v ON (c.dni = v.dni)
GROUP BY c.dni, c.nombre, c.apellido, c.direccion, c.telefono
HAVING COUNT(*) >= 5

/*10. Borrar al cliente con DNI 40325692.*/

DELETE FROM Viaje WHERE DNI = 40325692;
DELETE FROM Cliente WHERE DNI = 40325692;