# Ejercicio 3

## Modelo Físico

**Persona** = (*dni*, nombre, apellido, genero, telefono, email)  
**Medico** = (*matricula*, dni(fk), fechaIngreso)  
**Paciente** = (*dni(fk)*, fechaNacimiento, antecedentes)  
**Especialidad** = (*idEspecialidad*, nombreE, descripcion)  
**MedicoEspecialidad** = (*matricula(fk),idEspecialidad(fk)*)  
**Atencion** = (*nroAtencion*, matricula(fk), dni(fk), fecha, hora, motivo, diagnostico?, tratamiento?)

## Algebra Relacional

### Punto 1.AR

Listar matrícula, dni, nombre, apellido, telefono y email de los médicos cuyo apellido sea "Garcia".

![Punto 1 en Algebra Relaciona del Ejercicio 3](./Imagenes/Punto%203_1_AR.png)

### Punto 2.AR

Listar dni, nombre y apellido de aquellos pacientes que no recibieron atenciones durante 2024.

![Punto 2 en Algebra Relaciona del Ejercicio 3](./Imagenes/Punto%203_2_AR.png)

### Punto 3.AR

Listar dni, nombre y apellido de los pacientes atendidos por todos los médicos especializados en "Cardiología".

![Punto 3 en Algebra Relaciona del Ejercicio 3](./Imagenes/Punto%203_3_AR.png)

## SQL

### Punto 1

Listar matrícula, dni, nombre, apellido, telefono y email de los médicos cuyo apellido sea "Garcia".

``` sql
SELECT m.matricula, p.dni, p.nombre, p.apellido, p.telefono, p.email
FROM Medico m
INNER JOIN Persona p ON (m.dni = p.dni)
WHERE p.apellido = 'García';
```

### Punto 2

Listar dni, nombre y apellido de aquellos pacientes que no recibieron atenciones durante 2024.

``` sql
SELECT p.dni, p.nombre, p.apellido
FROM Paciente pa
INNER JOIN Persona p ON (pa.dni = p.dni)
WHERE NOT EXISTS(
    SELECT *
    FROM Atencion a
    WHERE (a.dni = p.dni) AND (a.fecha BETWEEN '2024-01-01' AND '2024-12-31')
);
```

### Punto 3

Listar dni, nombre y apellido de los pacientes atendidos por todos los médicos especializados en "Cardiología".

``` sql
SELECT p.dni, p.nombre, p.apellido
FROM Paciente pa
INNER JOIN Persona p ON (pa.dni = p.dni)
WHERE NOT EXISTS(
    SELECT *
    FROM Medico m
    INNER JOIN MedicoEspecialidad me ON (m.matricula = me.matricula)
    INNER JOIN Especialidad e ON (me.idEspecialidad = e.idEspecialidad)
    WHERE (e.nombre = "Cardiologia") AND NOT EXISTS(
        SELECT *
        FROM Atencion a
        WHERE (a.dni = p.dni) AND (a.matricula = m.matricula)
    )
);
```

### Punto 4

Listar para cada especialidad nombre y cantidad de médicos que se especializan en ella. Tenga en cuenta que puede haber especialidades que no tienen médicos especialistas.

``` sql
SELECT e.nombreE, COUNT(me.matricula) AS cantidadDeMedicos
FROM Especialidad e
LEFT JOIN MedicoEspecialidad me ON (e.idEspecialidad = me.idEspecialidad)
GROUP BY e.idEspecialidad, e.nombreE;
```

### Punto 5

Listar matrícula, dni, nombre y apellido del médico (o de los médicos) con más atenciones realizadas.

``` sql
SELECT m.matricula, p.dni, p.nombre, p.apellido
FROM Medico m
INNER JOIN Persona p ON (m.dni = p.dni)
INNER JOIN Atencion a ON (m.matricula = a.matricula)
GROUP BY m.matricula, p.dni, p.nombre, p.apellido
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Atencion a
    GROUP BY a.matricula
);
```
