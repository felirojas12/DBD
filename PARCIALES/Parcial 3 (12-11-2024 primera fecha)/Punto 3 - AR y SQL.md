# Ejercicio 3

## Modelo Físico

**Cliente** = (*idCliente*, nombre, apellido, DNI, telefono, direccion)  
**Venta** = (*nroVenta*, total, fecha, hora, idCliente(fk))  
**DetalleVenta** = (*nroVenta(fk), idLibro(fk)*, cantidad, precioUnitario)  
**Libro** = (*idLibro*, titulo, autor, precio, stock)

## Algebra Relacional

### Punto 1.AR

Listar todos los libros cuyo precio es mayor a $2300

![Punto 1 en Algebra Relacional del Ejercicio 3](./Imagenes/Punto%203_1_AR.png)

### Punto 2.AR

Listar todas las ventas realizadas en agosto del 2023

![Punto 2 en Algebra Relacional del Ejercicio 3](./Imagenes/Punto%203_2_AR.png)

### Punto 3.AR

Listar nombre, apellido, DNI, telefono y direccion de clientes que realizaron compras solamente durante el año 2022.

![Punto 3 en Algebra Relacional del Ejercicio 3](./Imagenes/Punto%203_3_AR.png)

## SQL

### Punto 1

Listar todos los libros cuyo precio es mayor a $2300

``` sql
SELECT *
FROM Libro l
WHERE (l.precio > 2300);
```

### Punto 2

Listar todas las ventas realizadas en agosto del 2023

``` sql
SELECT *
FROM Venta v
WHERE v.fecha BETWEEN '2023-08-01' AND '2023-08-31'
```

### Punto 3

Listar nombre, apellido, DNI, telefono y direccion de clientes que realizaron compras solamente durante el año 2022.

``` sql
SELECT DISTINCT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Venta v ON (c.idCliente = v.idCliente)
WHERE (v.fecha BETWEEN '2022-01-01' AND '2022-12-31') AND NOT EXISTS(
    SELECT *
    FROM Venta v2
    WHERE (v2.idCliente = c.idCliente) AND NOT(v2.fecha BETWEEN '2022-01-01' AND '2022-12-31')
);
```

### Punto 4

Listar para cada libro el título, autor, precio y la cantidad total de veces que fue vendido. Tener en cuenta que puede haber libros que no se vendieron.

``` sql
SELECT l.titulo, l.autor, l.precio, SUM(dv.cantidad) AS cantidadVentas
FROM Libro l
LEFT JOIN DetalleVenta dv ON (l.idLibro = dv.idLibro)
GROUP BY l.idLibro, l.titulo, l.autor, l.precio;
);
```

### Punto 5

Listar nroVenta, total, fecha, hora y DNI del cliente de aquellas ventas donde se haya vendido al menos un libro con precio mayor a 1000.

``` sql
SELECT DISTINCT v.nroVenta, v.total, v.fecha, v.hora, c.DNI
FROM Venta v
INNER JOIN Cliente c ON (v.idCliente = c.idCliente)
INNER JOIN DetalleVenta dv ON (v.nroVenta = dv.nroVenta)
INNER JOIN Libro l ON (dv.idLibro = l.idLibro)
WHERE l.precio > 1000
```
