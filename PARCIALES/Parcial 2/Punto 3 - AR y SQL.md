# Ejercicio 3

## Modelo Físico

**Cliente** (*dni*, nombre, apellido, contacto)  
**Mascota** (*id_mascota*, nombre, especie, raza, f_nac, dni_cliente (fk))  
**Consulta** (*id_mascota(fk), fecha*, diagnostico, tratamiento?, monto)  
**Vacuna** (*nombreV*, descripcion, precio)  
**Aplicacion_Vacuna** (*id_mascota(fk), nombreV(fk), fecha_aplicacion*, precio)

## AR

### Punto 1.AR

Lista las mascotas que recibieron la vacuna "Triple Felina" con costo menor a $10.000 al momento de la aplicación.

π id_mascota (σ nombreV = ‘Triple Felina’ and precio < 10000 (Aplicación_Vacuna))

### Punto 2.AR

Listar los datos de las mascotas que no se atendieron durante el año actual.

Consulta2026 <= π id_mascota, nombre, especie, raza, f_nac, dni, cliente (σ fecha >= ‘2026-01-01’ and fecha <= ‘2026-12-31’(Mascota |x| Consulta))

Consulta <= π id_mascota, nombre, especie, raza, f_nac, dni, cliente (Mascota |x| Consulta)

Consulta – Consulta2026

## SQL

### Punto 1.SQL

Lista las mascotas que recibieron la vacuna "Triple Felina" con costo menor a $10.000 al momento de la aplicación.

``` sql
SELECT av.id_mascota
FROM Aplicacion_Vacuna av
WHERE av.nombreV = 'Triple Felina' AND av.precio < 10000
```

### Punto 2.SQL

Listar los datos de las mascotas que no se atendieron durante el año actual.

``` sql
SELECT m.id_mascota, m.nombre, m.especie, m.raza, m.f_nac, m.dni_cliente
FROM Mascota m
WHERE NOT EXISTS(
    SELECT *
    FROM Consulta c
    WHERE (c.id_mascota = m.id_mascota) AND (c.fecha BETWEEN '2026-01-01' AND '2026-12-31')
);
```

### Punto 3

Listar nombre, apellido, teléfono y cantidad de mascotas de los clientes que tienen más de 2 mascotas registradas. Ordenar por cantidad de mascotas descendientes.

``` sql
SELECT c.nombre, c.apellido, c.telefono, COUNT(*) AS cantidadMascotas
FROM Cliente c
INNER JOIN Mascota m ON (c.dni = m.dni_cliente)
GROUP BY c.dni, c.nombre, c.apellido, c.telefono
HAVING COUNT(*) > 2
ORDER BY COUNT(*) DESC;
```

### Punto 4

Listar los datos de las mascotas que obtuvieron el diagnóstico "rabia" y además nunca se aplicó la vacuna con nombre "Antirrábica".

``` sql
SELECT m.id_mascota, m.nombre, m.especie, m.raza, m.f_nac, m.dni_cliente
FROM Mascota m
INNER JOIN Consulta c ON (m.id_mascota = c.id_mascota)
WHERE (c.diagnostico = 'rabia') AND NOT EXISTS(
    SELECT *
    FROM Aplicacion_Vacuna av
    WHERE (av.id_mascota = m.id_mascota) AND (av.nombreV = 'Antirrábica')
);
```

### Punto 5

Insertar una nueva mascota con los datos que quiera.

``` sql
INSERT INTO Mascota (id_mascota, nombre, especie, raza, f_nac, dni_cliente) VALUES (12345, 'Firulais', 'Perro', 'Golden Retriever', '2024-05-12', 21212121);
```
