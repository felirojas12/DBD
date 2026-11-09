# Ejercicio 3

## Modelo Físico

Jugador = (*idJugador*, nombre, apellido, fecha_nacimiento, altura, peso, posición).  
Equipo = (*idEquipo*, nombre, ciudad, conferencia).  
Contrato = (*idJugador(fk), idEquipo(fk), fecha_desde*, fecha_hasta).  
Partido = (*idPartido*, fecha, idEquipoLocal(fk), idEquipoVisitante(fk), puntosLocal, puntosVisitante)

## Álgebra Relacional

### Punto 1.AR

Reportar nombre y ciudad de equipos que hayan jugado partidos durante 2023 pero no durante 2024.

![Punto 1 en Algebra Relacional del Ejercicio 3](./Punto%203_1_AR.png)

### Punto 2.AR

Listar jugadores que jugaron en todos los equipos de la conferencia Este.

![Punto 2 en Algebra Relacional del Ejercicio 3](./Punto%203_2_AR.png)

### Punto 3.AR

Modificar la ciudad del equipo con idEquipo 5 a "San Francisco"

![Punto 3 en Algebra Relacional del Ejercicio 3](./Punto%203_3_AR.png)

## SQL

### Punto 1.SQL

Reportar nombre y ciudad de equipos que hayan jugado partidos durante 2023 pero no durante 2024.

``` sql
SELECT e.nombre, e.ciudad
FROM Equipo e1
WHERE EXISTS(
    SELECT *
    From Partido p
    WHERE (e.idEquipo = p.idEquipoLocal or e.idEquipo = p.idEquipoVisitante) AND
    (p.fecha BETWEEN '2023-01-01' AND '2023-12-31')
) AND NOT EXISTS(
    SELECT *
    From Partido p
    WHERE (e.idEquipo = p.idEquipoLocal or e.idEquipo = p.idEquipoVisitante) AND
    (p.fecha BETWEEN '2024-01-01' AND '2024-12-31')
)
```

### Punto 2.SQL

Listar jugadores que jugaron en todos los equipos de la conferencia Este.

``` sql
SELECT j.nombre, j.apellido
FROM Jugador j
WHERE NOT EXISTS(
    SELECT *
    FROM Equipo e
    WHERE (e.conferencia = 'Este') AND NOT EXISTS(
        SELECT *
        FROM Contrato c
        WHERE (c.idJugador = j.idJugador) AND (c.idEquipo = e.idEquipo)
    )
)
```

### Punto 3.SQL

Modificar la ciudad del equipo con idEquipo 5 a "San Francisco"

``` sql
UPDATE Equipo SET ciudad = 'San Francisco' WHERE idEquipo = 5;
```

### Punto 4

Listar nombre, apellido, altura y posición de jugadores que midan más de 2,10 metros y que se encuentren jugando actualmente en algún equipo de la ciudad de Nueva York. Ordenar por apellido de manera descendente.

``` sql
SELECT j.nombre, j.apellido, j.altura, j.posicion
FROM Jugador j
WHERE j.altura > 2,10 AND EXISTS(
    SELECT *
    FROM Equipo e
    WHERE (e.ciudad = 'Nueva York') AND EXISTS(
        SELECT *
        FROM Contrato c
        WHERE c.idEquipo = e.idEquipo AND c.idJugador = j.idJugador AND c.fecha_hasta => '2026-11-05'
    )
)
ORDER BY j.apellido DESC;
```

### Punto 5

Listar idPartido, fecha y nombre de los equipos donde ambos equipos (local y visitante) sean de la conferencia Oeste.

``` sql
SELECT p.idPartido, p.fecha, eLocal.nombre, eVisitante.nombre
FROM Partido p
INNER JOIN Equipo eLocal ON (p.idEquipoLocal = eLocal.idEquipo)
INNER JOIN Equipo eVisitante ON (p.idEquipoVisitante = eVisitante.idEquipo)
WHERE eLocal.conferencia = 'Oeste' AND eVisitante.conferencia = 'Oeste'
```
