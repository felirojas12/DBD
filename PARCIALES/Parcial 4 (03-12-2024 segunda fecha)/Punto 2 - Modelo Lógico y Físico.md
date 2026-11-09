# Ejercicio 2

## Modelo Conceptual

![Modelo Conceptual de Ejercicio 2](./Imagenes/Punto%202%20-%20Modelo%20Conceptual.jpg)

## Modelo Lógico

![Modelo Lógico de Ejercicio 2](./Imagenes/Punto%202%20-%20Modelo%20Lógico.jpg)

## Modelo Físico

**Persona** = (*dni*, nombre, apellido, genero, email, telefono, calle, nro, piso?, depto?)  
**Alumno** = (*dni(fk)*, legajo, fechaDeNacimiento)  
**Foro** = (*idForo*, nombre, descripcion, dni(fk), nombreTipo(fk))  
**Tipo** = (*nombreTipo*)  
**Alergia** = (*nombreAlergia*)  
**AlumnoForo** = (*dni(fk), idForo(fk)*, fecha)  
**AlumnoAlergia** = (*dni(fk), nombreAlergia(fk)*)
