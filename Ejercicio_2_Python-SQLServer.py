#-------------------------------------------------------
# BASE DE DATOS 2
# GRUPO: 5
# INTEGRANTES: Mateo Tipán, Luis Vasquez, Martín Ochoa
# NRC: 5480
#-------------------------------------------------------

import pyodbc
import json

# --CREACION DE LA CLASE GESTIONCANCIONES -------------------------------------------------------
class GestionCanciones:
    # Constructor de la clase
    def __init__(self):
        try:
            # Apertura del archivo config.json en modo lectura
            with open('config.json', 'r') as archivo_config:
                # Lectura de los datos JSON y acceso a la sección "sql_server"
                config = json.load(archivo_config)['sql_server']
                # Obtención de los parámetros de conexión desde el JSON
                name_server = config['name_server']
                database = config['database']
                username = config['username']
                password = config['password']
                controlador_odbc = config['controlador_odbc']
                
            # Creación de la cadena de conexión a SQL Server
            self.connection_string = f'DRIVER={controlador_odbc};SERVER={name_server};DATABASE={database};UID={username};PWD={password}'
            
            self.conexion = pyodbc.connect(self.connection_string)
                
        except Exception as e:
            print("Error:", e)

# --CREACION DEL METODO PARA CONSULTAR LOS REGISTROS DE CANCIONES -------------------------------------------------------          
    def consultar_canciones(self):
        try:
            cursor = self.conexion.cursor()
            # Consulta SQL para mostrar todas las canciones desde la vista
            SENTENCIA_SQL = "SELECT * FROM vListadoDeCanciones"
            cursor.execute(SENTENCIA_SQL)
            rows = cursor.fetchall()
            
            print("-----------------------------------LISTADO DE CANCIONES---------------------------------------------")
            print("-" * 100)
            print(f"{'ID':<12} {'CANCION':<30} {'DURACION':<12} {'FECHA':<15} {'CALIDAD':<15} {'ESTADO':<10}")
            print("-" * 100)
            for row in rows:
                print(f"{row.IdCancion:<12} "
                    f"{row.Cancion:<30} "
                    f"{row.Duracion:<12} "
                    f"{str(row.FechaDeLanzamiento):<15} "
                    f"{row.CalidadDeAudio:<15} "
                    f"{row.Estado:<10}")
                        
            print("\nOk ... Proceso Culminado con Exito: \n")
        except Exception as e:
            print("Error:", e)

# --CREACION DEL METODO PARA INSERTAR REGISTROS DE CANCIONES -------------------------------------------------------  
    def insertar_canciones(self):
        try:
            ID_CANCION = input("Ingrese el ID de la canción: \t")
            
            NOMBRE_CANCION = input("Ingrese el nombre de la canción: \t")
            
            DURACION_CANCION = int(input("Ingrese la duración de la cacnión: \t"))
            
            FECHA_CANCION = input("Ingrese la fecha de lanza1miento (año-mes-dia): \t")
            
            CALIDAD_CANCION = input("Seleccione la calidad de la canción (Alta o Estándar): \t")
            while CALIDAD_CANCION != "Alta" and CALIDAD_CANCION != "Estándar":
                CALIDAD_CANCION = input("Seleccione la calidad de la canción (Alta o Estándar): \t")
                 
            ESTADO_CANCION = input("Ingrese el estado de la canción (Activo o Inactivo): \t")
            while ESTADO_CANCION  != "Activo" and ESTADO_CANCION != "Inactivo":
                ESTADO_CANCION = input("Ingrese el estado de la canción (Activo o Inactivo): \t")
                 
            NOMBRE_ALBUM = input("Ingrese el nombre del Album al que pertenece la canción: ")
            
            cursor = self.conexion.cursor()
            SENTENCIA_SQL = "{CALL SP_InsertarCancion (?,?,?,?,?,?,?)}"
            cursor.execute(SENTENCIA_SQL,(ID_CANCION),(NOMBRE_CANCION),(DURACION_CANCION),(FECHA_CANCION),(CALIDAD_CANCION),(ESTADO_CANCION), (NOMBRE_ALBUM))

            cursor.commit()
            print("\nOk ... Insercion Exitosa: \n") 
           
        except Exception as e:
            print("Error:", e)

# --CREACION DEL METODO PARA ACTUALIZAR REGISTROS DE CANCIONES -------------------------------------------------------   
    def actualizar_canciones(self):
        try:
            ID_CANCION = input("Ingrese el ID de la canción que desea actualizar: \t")
            
            ACTUALIZAR_NOMBRE = input("¿Desea actualizar el nombre de la canción? (S/N): ")
            if ACTUALIZAR_NOMBRE == "S":
                NOMBRE_CANCION = input("Ingrese el nombre de la canción: \t")
            else:
                NOMBRE_CANCION = None
            
            ACTUALIZAR_DURACION = input("¿Desea actualizar la duración de la canción? (S/N): ")
            if ACTUALIZAR_DURACION == "S":
                DURACION_CANCION = int(input("Ingrese la duración de la cacnión: \t"))
            else:
                DURACION_CANCION = None
            
            ACTUALIZAR_FECHA = input("¿Desea actualizar la fecha de lanzamiento de la canción? (S/N): ")
            if ACTUALIZAR_FECHA == "S":
                FECHA_CANCION = input("Ingrese la fecha de lanza1miento (año-mes-dia): \t")
            else:
                FECHA_CANCION = None
            
            ACTUALIZAR_CALIDAD= input("¿Desea actualizar la calidad de la canción? (S/N): ")
            if ACTUALIZAR_CALIDAD == "S":
                CALIDAD_CANCION = input("Seleccione la calidad de la canción (Alta o Estándar): \t")
                while CALIDAD_CANCION != "Alta" and CALIDAD_CANCION != "Estándar":
                    CALIDAD_CANCION = input("Seleccione la calidad de la canción (Alta o Estándar): \t")
            else:
                CALIDAD_CANCION = None
            
            ACTUALIZAR_ESTADO = input("¿Desea actualizar el estado de la canción? (S/N): ")
            if ACTUALIZAR_ESTADO == "S":
                ESTADO_CANCION = input("Ingrese el estado de la canción (Activo o Inactivo): \t")
                while ESTADO_CANCION  != "Activo" and ESTADO_CANCION != "Inactivo":
                    ESTADO_CANCION = input("Ingrese el estado de la canción (Activo o Inactivo): \t")
            else:
                ESTADO_CANCION = None
            
            ACTUALIZAR_ALBUM = input("¿Desea actualizar el album de la canción? (S/N): ")
            if ACTUALIZAR_ALBUM == "S":
                NOMBRE_ALBUM = input("Ingrese el nombre del Album al que pertenece la canción: ")
            else:
                NOMBRE_ALBUM = None
                
            cursor = self.conexion.cursor()
            SENTENCIA_SQL = "{CALL SP_ActualizarCancion (?,?,?,?,?,?,?)}"
            cursor.execute(SENTENCIA_SQL,(ID_CANCION),(NOMBRE_CANCION),(DURACION_CANCION),(FECHA_CANCION),(CALIDAD_CANCION),(ESTADO_CANCION), (NOMBRE_ALBUM))

            cursor.commit()
            print("\nOk ... Actualización Exitosa. \n") 
           
        except Exception as e:
            print("Error:", e)

# --CREACION DEL METODO PARA ELIMINAR REGISTROS DE CANCIONES ------------------------------------------------------   
    def eliminar_canciones(self):
        try:
            ID_CANCION = input("Ingrese el ID de la canción que desea eliminar: \t")      
            cursor = self.conexion.cursor()
            SENTENCIA_SQL = "{CALL SP_EliminarCancion (?)}"
            cursor.execute(SENTENCIA_SQL,(ID_CANCION))
            
            cursor.commit()
            print("\nOk ... Eliminación Exitosa. \n") 
            
        except Exception as e:
            print("Error:", e)


# -- FUNCION PARA MOSTRAR LAS OPCIONES CRUD Y EJECUTAR EL PROGRAMA ---------------------------------------------          
def mostrar_opciones_crud():
    C = GestionCanciones()
    while True:
        print("\t****************************")  
        print("\t** SISTEMA CRUD VIVEEC **")  
        print("\t****************************")  
        print("\tOpciones CRUD:\n")
        print("\t1. Crear registro")
        print("\t2. Consultar registros")
        print("\t3. Actualizar registro")
        print("\t4. Eliminar registro")
        print("\t5. Salir\n\n") 
        opcion = input("Seleccione una opción 1-5:\t")
        
        if opcion == '1':
            C.insertar_canciones()
        elif opcion == '2':
            C.consultar_canciones()
        elif opcion == '3':
            C.actualizar_canciones()
        elif opcion == '4':
            C.eliminar_canciones()
        elif opcion == '5':
            print("\nSaliendo del programa..\n\n.")
            break
        else:
            print("\nOpción no válida.\n")   
        
# -- EJECUCIÓN DEL PROGRAMA ---------------------------------------------
mostrar_opciones_crud()        		
