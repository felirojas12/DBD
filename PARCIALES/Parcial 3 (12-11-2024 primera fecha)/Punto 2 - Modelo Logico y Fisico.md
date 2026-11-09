# Ejercicio 2

## Modelo Conceptual

![Modelo conceptual del ejercicio 2](./Imagenes/Punto%202%20-%20Modelo%20Conceptual.jpg)

## Modelo Lógico

![Modelo lógico del ejercicio 2](./Imagenes/Punto%202%20-%20Modelo%20Logico.jpg)

## Modelo Físico

Las claves están en *itálica*

**Persona** = (*dni*, nombre, apellido)  
**TelefonoPersona** = (*dni(fk), telefono*)  
**Empleado** = (*dni(fk)*, cuit, codigoArea(fk), calle, nro, piso?, depto?)  
**Area** = (*codigo*, nombre)  
**Sueldo** = (*id*, categoría)  
**EmpleadoSueldo** = (*dni(fk), idSueldo(fk)*, fecha, monto)
