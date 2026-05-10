
-- CREACION DE LA BASE DE DATOS -------------------------------------------------------------------------------------------------------------------

USE master
GO

CREATE DATABASE ViveEC
GO

USE ViveEC
GO
------------------------------------------------------------------------------------------------------------------------------------------------
--                                                            ESQUEMAS                                                                        --
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- ESQUEMA: MUSICA
-- - Artista
-- - Discográficas
-- - Albumes
-- - Canciones
-- - Géneros
-- - CancionGenero
------------------------------------------------------------------------------------------
CREATE SCHEMA Musica
GO

------------------------------------------------------------------------------------------
-- ESQUEMA: USUARIOS
-- - Usuario
-- - SeguimientoArtista
-- - LikeCancion
-- - AlbumGuardado
-- - Playlist
-- - PlaylistUsuarioColaborador
-- - PlaylistCancion
------------------------------------------------------------------------------------------
CREATE SCHEMA Usuarios
GO

------------------------------------------------------------------------------------------
-- ESQUEMA: OPERACIONES
-- - Suscripción 
-- - Pago
-- - ReproduccionCancion
-- - Reglia
------------------------------------------------------------------------------------------
CREATE SCHEMA Operaciones
GO

------------------------------------------------------------------------------------------------------------------------------------------------
--                                                      CREACION TABLAS                                                                       --
------------------------------------------------------------------------------------------------------------------------------------------------

-- TABLA USUARIO
CREATE TABLE Usuarios.Usuario (
IdUsuario CHAR(4) PRIMARY KEY,
correoUsuario NVARCHAR(100) UNIQUE NOT NULL CHECK (correoUsuario LIKE '%_@__%.%'),
contraseñaUsuario NVARCHAR(8) NOT NULL,
nombreUsuario NVARCHAR(100) NOT NULL
)
GO

-- TABLA DISCOGRAFICA
CREATE TABLE Musica.Discografica(
idDiscografica CHAR(4) PRIMARY KEY,
nombreDiscografica NVARCHAR(100) UNIQUE NOT NULL
)
GO

-- TABLA ARTISTA
CREATE TABLE Musica.Artista(
idArtista CHAR(4) PRIMARY KEY,
nombreArtista NVARCHAR(100) NOT NULL,
idDiscografica CHAR(4), --FK
FOREIGN KEY (idDiscografica) REFERENCES Musica.Discografica (idDiscografica)
)
GO

-- TABLA REGALIA
CREATE TABLE Operaciones.Regalia(
idRegalia CHAR(4) PRIMARY KEY,
fechaInicio DATE NOT NULL,
fechaFin DATE NOT NULL,
totalReproducciones INT NOT NULL CHECK (totalReproducciones >= 0) DEFAULT 0 ,
montoTotal DECIMAL(10,2) NOT NULL CHECK (montoTotal >= 0.00) DEFAULT 0.00,
fechaPago DATE NOT NULL,
idArtista CHAR(4) NOT NULL, --FK
FOREIGN KEY (idArtista) REFERENCES Musica.Artista (idArtista),
CHECK (fechaFin >= fechaInicio)
)
GO

-- TABLA ALBUM
CREATE TABLE Musica.Album(
idAlbum CHAR(4) PRIMARY KEY,
nombreAlbum NVARCHAR(100) NOT NULL,
fechaLanzamientoAlbum DATE NOT NULL,
idArtista CHAR(4) NOT NULL, --FK
FOREIGN KEY (idArtista) REFERENCES Musica.Artista (idArtista)
)
GO

-- TABLA CANCION
CREATE TABLE Musica.Cancion(
idCancion CHAR(4) PRIMARY KEY,
nombreCancion NVARCHAR(100) NOT NULL,
duracionCancion INTEGER NOT NULL CHECK (duracionCancion > 0),
fechaLanzamientoCancion DATE NOT NULL,
calidadAudio NVARCHAR(100) CHECK (calidadAudio IN ('Estándar','Alta')) DEFAULT 'Estándar',
estadoCancion NVARCHAR(15) CHECK (estadoCancion IN ('Activo','Inactivo')) DEFAULT 'Activo',
idAlbum char(4) NOT NULL, --FK
FOREIGN KEY (idAlbum) REFERENCES Musica.Album (idAlbum)
)
GO

-- TABLA GENERO
CREATE TABLE Musica.Genero(
idGenero CHAR(4) PRIMARY KEY,
nombreGenero NVARCHAR(100) NOT NULL,
)
GO

-- TABLA CANCION_GENERO
CREATE TABLE Musica.CancionGenero(
idCancion CHAR(4) NOT NULL, --FK
idGenero CHAR(4) NOT NULL, --FK
PRIMARY KEY (idCancion, idGenero),
FOREIGN KEY (idCancion) REFERENCES Musica.Cancion(idCancion),
FOREIGN KEY (idGenero) REFERENCES Musica.Genero(idGenero)
)
GO

-- TABLA LIKE_CANCION
CREATE TABLE Usuarios.LikeCancion(
idCancion CHAR(4) NOT NULL, --FK
IdUsuario CHAR(4) NOT NULL, --FK
PRIMARY KEY (idCancion, IdUsuario),
FOREIGN KEY (idCancion) REFERENCES Musica.Cancion(idCancion),
FOREIGN KEY (IdUsuario) REFERENCES Usuarios.Usuario(IdUsuario)
)
GO

-- TABLA ALBUM_USUARIO
CREATE TABLE Usuarios.AlbumGuardado(
idAlbum CHAR(4) NOT NULL, --FK
IdUsuario CHAR(4) NOT NULL, --FK
PRIMARY KEY (idAlbum, IdUsuario),
FOREIGN KEY (idAlbum) REFERENCES Musica.Album(idAlbum),
FOREIGN KEY (IdUsuario) REFERENCES Usuarios.Usuario(IdUsuario)
)
GO

-- TABLA ARTISTA_USUARIO
CREATE TABLE Usuarios.SeguimientoArtistas(
idArtista CHAR(4) NOT NULL, --FK
IdUsuario CHAR(4) NOT NULL, --FK
PRIMARY KEY (idArtista, IdUsuario),
FOREIGN KEY (idArtista) REFERENCES Musica.Artista(idArtista),
FOREIGN KEY (IdUsuario) REFERENCES Usuarios.Usuario(IdUsuario)
)
GO

-- TABLA REPRODUCCION CANCION
CREATE TABLE Operaciones.ReproduccionCancion(
idReproduccion INT IDENTITY(1,1) PRIMARY KEY,
idCancion CHAR(4) NOT NULL, --FK
IdUsuario CHAR(4) NOT NULL, --FK
paisReproduccion NVARCHAR(50) NOT NULL,
fechaReproduccion DATETIME NOT NULL,
duracionReproduccion INT NOT NULL CHECK (duracionReproduccion > 0),
FOREIGN KEY (idCancion) REFERENCES Musica.Cancion(idCancion),
FOREIGN KEY (IdUsuario) REFERENCES Usuarios.Usuario(IdUsuario)
)
GO

-- TABLA PLAYLIST
CREATE TABLE Usuarios.Playlist(
idPlaylist CHAR(4) PRIMARY KEY,
nombrePlaylist NVARCHAR(100) NOT NULL,
descripcionPlaylist NVARCHAR(500),
visibilidad NVARCHAR(10) CHECK(visibilidad IN('Pública','Privada')) DEFAULT 'Privada',
idUsuarioPropietario CHAR(4) NOT NULL, --FK
FOREIGN KEY (idUsuarioPropietario) REFERENCES Usuarios.Usuario(IdUsuario)
)
GO

-- TABLA PLAYLIST_USUARIOS COLABORADORES
CREATE TABLE Usuarios.PlaylistUsuarioColaborador(
idPlaylist CHAR(4) NOT NULL, --FK
IdUsuarioColaborador CHAR(4) NOT NULL, --FK
PRIMARY KEY (idPlaylist, IdUsuarioColaborador),
FOREIGN KEY (idPlaylist) REFERENCES Usuarios.Playlist(idPlaylist),
FOREIGN KEY (IdUsuarioColaborador) REFERENCES Usuarios.Usuario(IdUsuario)

)
GO

-- TABLA PLAYLIST_CANCION
CREATE TABLE Usuarios.PlaylistCancion(
idPlaylist CHAR(4) NOT NULL, --FK
idCancion CHAR(4) NOT NULL, --FK
PRIMARY KEY (idPlaylist, idCancion),
FOREIGN KEY (idPlaylist) REFERENCES Usuarios.Playlist(idPlaylist),
FOREIGN KEY (idCancion) REFERENCES Musica.Cancion(idCancion)
)
GO

-- TABLA SUSCRIPCION
CREATE TABLE Operaciones.Suscripcion(
idSuscripcion CHAR(4) PRIMARY KEY,
tipoSuscripcion NVARCHAR(15) NOT NULL CHECK(tipoSuscripcion IN ('Individual', 'Estudiante', 'Familiar')),
fechaInicioSuscripcion DATE NOT NULL,
fechaFinSuscripcion DATE NOT NULL,
estadoSuscripcion NVARCHAR(15) NOT NULL CHECK(estadoSuscripcion IN ('Activa', 'Cancelada', 'Vencida')),
idUsuario CHAR(4) NOT NULL, --FK
FOREIGN KEY (IdUsuario) REFERENCES Usuarios.Usuario (IdUsuario),
CHECK (fechaFinSuscripcion >= fechaInicioSuscripcion)
)
GO

-- TABLA PAGO
CREATE TABLE Operaciones.Pago(
idPago CHAR(4) PRIMARY KEY,
monto DECIMAL(10,2) NOT NULL CHECK(monto > 0),
fechaPago DATE NOT NULL,
metodoPago NVARCHAR(50) NOT NULL,
resultadoPago NVARCHAR(15) CHECK (resultadoPago IN ('Aprobado', 'Fallido')) NOT NULL,
idSuscripcion CHAR(4) NOT NULL, --FK
FOREIGN KEY (idSuscripcion) REFERENCES Operaciones.Suscripcion(idSuscripcion)
)
GO

-- INSERCION DE OBJETOS ---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
--                                                 CARGA MASIVA DE INFORMACION                                                                --
------------------------------------------------------------------------------------------------------------------------------------------------
-- CARGA DE DISCOGRÁFICAS (5 Reales)
INSERT INTO Musica.Discografica (idDiscografica, nombreDiscografica) VALUES
('D001', 'Sony Music Entertainment'),
('D002', 'Universal Music Group'),
('D003', 'Warner Music Group'),
('D004', 'XL Recordings'),
('D005', 'EMI Records');
GO

-- CARGA DE GÉNEROS (10 Variados)
INSERT INTO Musica.Genero (idGenero, nombreGenero) VALUES
('G001', 'Rock'),
('G002', 'Pop'),
('G003', 'Reggaeton'),
('G004', 'Jazz'),
('G005', 'Indie'),
('G006', 'Metal'),
('G007', 'Trap'),
('G008', 'Lo-fi'),
('G009', 'Salsa'),
('G010', 'Techno');
GO

-- CARGA DE USUARIOS (10 Iniciales)
-- El formato de correo cumple con: %_@__%.%
INSERT INTO Usuarios.Usuario (IdUsuario, correoUsuario, contraseñaUsuario, nombreUsuario) VALUES
('U001', 'mateo_dev@mail.com', 'Pass123*', 'Mateo'),
('U002', 'ma.garcia@test.ec', 'Magi2026', 'Maria Garcia'),
('U003', 'juan.perez@web.net', 'JPerez1!', 'Juan Perez'),
('U004', 'elena.ro@mail.org', 'Elenita9', 'Elena Rodriguez'),
('U005', 'admin_sys@vive.ec', 'Root4321', 'Admin ViveEC'),
('U006', 'carla_m@music.com', 'Carla88*', 'Carla Mendoza'),
('U007', 'luis.t@serv.net', 'Lucho123', 'Luis Torres'),
('U008', 'sofia.b@web.com', 'Sofi_202', 'Sofia Benitez'),
('U009', 'diego.a@mail.ec', 'Dieg_555', 'Diego Aguirre'),
('U010', 'vale.v@test.com', 'ValeV_21', 'Valeria Vargas');
GO

-- CARGA DE ARTISTAS 
-- Vinculados a las discográficas: D001 (Sony), D002 (Universal), D003 (Warner), D004 (XL)
INSERT INTO Musica.Artista (idArtista, nombreArtista, idDiscografica) VALUES
('A001', 'Taylor Swift', 'D002'),
('A002', 'Bad Bunny', 'D001'),
('A003', 'Arctic Monkeys', 'D004'),
('A004', 'Dua Lipa', 'D003'),
('A005', 'Metallica', 'D002'),
('A006', 'The Weeknd', 'D002'),
('A007', 'Shakira', 'D001'),
('A008', 'Soda Stereo', 'D001'),
('A009', 'Bruno Mars', 'D003'),
('A010', 'Karol G', 'D002'),
('A011', 'Julio Jaramillo', 'D005'),
('A012', 'Juan Fernando Velasco', 'D001'),
('A013', 'Fausto Miño', 'D002'),
('A014', 'Daniel Betancourt', 'D002'),
('A015', 'Pancho Teran', 'D003'),
('A016', 'Gerardo Moran', 'D005'),
('A017', 'Paulina Tamayo', 'D005'),
('A018', 'Verde 70', 'D001'),
('A019', 'Guardarraya', 'D004'),
('A020', 'Swing Original Monks', 'D004'),
('A021', 'Papá Changó', 'D003'),
('A022', 'Tierra Canela', 'D005'),
('A023', 'Jombriel', 'D002'),
('A024', 'Machaka', 'D002'),
('A025', 'AU-D', 'D001'),
('A026', 'La Toquilla', 'D004'),
('A027', 'Mateo Kingman', 'D004'),
('A028', 'Nicola Cruz', 'D004'),
('A029', 'Mirella Cesa', 'D002'),
('A030', 'Marques', 'D002'),
('A031', 'Los Intrépidos', 'D005'),
('A032', 'Widinson', 'D002'),
('A033', 'Dayanara', 'D002'),
('A034', 'Jorge Luis del Hierro', 'D003'),
('A035', 'Rocko y Blasty', 'D001');
GO

-- CARGA DE ÁLBUMES 
-- Fechas reales para que el reporte de "Lanzamientos" se vea bien.
INSERT INTO Musica.Album (idAlbum, nombreAlbum, fechaLanzamientoAlbum, idArtista) VALUES
('AL01', 'Midnights', '2022-10-21', 'A001'),
('AL02', 'Folklore', '2020-07-24', 'A001'),
('AL03', 'Un Verano Sin Ti', '2022-05-06', 'A002'),
('AL04', 'YHLQMDLG', '2020-02-29', 'A002'),
('AL05', 'AM', '2013-09-09', 'A003'),
('AL06', 'Future Nostalgia', '2020-03-27', 'A004'),
('AL07', 'Master of Puppets', '1986-03-03', 'A005'),
('AL08', 'After Hours', '2020-03-20', 'A006'),
('AL09', 'Starboy', '2016-11-25', 'A006'),
('AL10', 'El Dorado', '2017-05-26', 'A007'),
('AL11', 'Laundry Service', '2001-11-13', 'A007'),
('AL12', 'Comfort y Música para Volar', '1996-09-25', 'A008'),
('AL13', 'Canción Animal', '1990-08-07', 'A008'),
('AL14', '24K Magic', '2016-11-18', 'A009'),
('AL15', 'Mañana Será Bonito', '2023-02-24', 'A010'),
('AL16','Nuestro Juramento','1965-05-10','A011'),
('AL17','El Ruiseñor de América','1970-03-20','A011'),
('AL18','El Más Querido','2005-06-01','A012'),
('AL19','Ídolo del Pueblo','2010-09-15','A012'),
('AL20','Seductor','2008-07-12','A013'),
('AL21','De Cantina','2013-04-05','A013'),
('AL22','A Mil','2011-08-10','A014'),
('AL23','Instinto Natural','2016-10-22','A014'),
('AL24','Vida','2009-02-14','A015'),
('AL25','Tu Amor','2014-05-30','A015'),
('AL26','El Dueño del Swing','2001-01-01','A016'),
('AL27','Escándalo','2004-03-18','A016'),
('AL28','A Contraluz','2000-11-11','A017'),
('AL29','Frenesí','2006-06-06','A017'),
('AL30','Hijos del Dolor','1999-09-09','A018'),
('AL31','Despierta','2003-08-20','A018'),
('AL32','Guardarraya','2002-07-07','A019'),
('AL33','Entre el Barro','2008-12-12','A019'),
('AL34','La Santa Fanesca','2014-03-03','A020'),
('AL35','Somos','2018-04-21','A020'),
('AL36','Raíces','2010-05-05','A021'),
('AL37','Somos Uno','2015-09-09','A021'),
('AL38','Ciudad Gris','2012-02-02','A022'),
('AL39','Resistencia','2017-07-07','A022'),
('AL40','Verano en Coma','2015-11-11','A023'),
('AL41','Sol','2020-01-20','A023'),
('AL42','Cumbia del Ecuador','2003-03-03','A024'),
('AL43','Fiesta Tropical','2008-08-08','A024'),
('AL44','Nueva Ola','2022-06-01','A025'),
('AL45','Flow Ecuatoriano','2024-02-15','A025'),
('AL46','Canto Mestizo','2016-03-10','A026'),
('AL47','Origen','2021-09-05','A026'),
('AL48','Respira','2017-04-14','A027'),
('AL49','Astro','2020-10-10','A027'),
('AL50','Prender el Alma','2015-09-25','A028'),
('AL51','Siku','2019-06-21','A028'),
('AL52','La Corriente','2013-11-11','A029'),
('AL53','Dejé','2018-02-02','A029'),
('AL54','Romance Urbano','2019-08-08','A030'),
('AL55','Historias','2023-01-15','A030'),
('AL56','Rock del Barrio','2007-07-07','A031'),
('AL57','Generación','2012-12-12','A031'),
('AL58','Trap Latino','2021-03-03','A032'),
('AL59','Modo Calle','2024-01-01','A032'),
('AL60','El Inicio','2018-05-05','A033'),
('AL61','Renacer','2023-03-03','A033'),
('AL62','Agradecido','2006-06-06','A034'),
('AL63','Evolución','2011-11-11','A034'),
('AL64','La Unión','2010-10-10','A035'),
('AL65','Movimiento','2016-06-16','A035');
GO

-- CARGA DE CANCIONES 
INSERT INTO Musica.Cancion 
(idCancion, nombreCancion, duracionCancion, fechaLanzamientoCancion, calidadAudio, estadoCancion, idAlbum) 
VALUES
('C001', 'Anti-Hero', 200, '2022-10-21', 'Alta', 'Activo', 'AL01'),
('C002', 'Lavender Haze', 202, '2022-10-21', 'Alta', 'Activo', 'AL01'),
('C003', 'Cardigan', 239, '2020-07-24', 'Alta', 'Activo', 'AL02'),
('C004', 'Exile', 285, '2020-07-24', 'Alta', 'Activo', 'AL02'),
('C005', 'Titi Me Pregunto', 243, '2022-05-06', 'Alta', 'Activo', 'AL03'),
('C006', 'Me Porto Bonito', 178, '2022-05-06', 'Alta', 'Activo', 'AL03'),
('C007', 'Safaera', 295, '2020-02-29', 'Estándar', 'Activo', 'AL04'),
('C008', 'La Santa', 206, '2020-02-29', 'Estándar', 'Activo', 'AL04'),
('C009', 'Do I Wanna Know?', 272, '2013-09-09', 'Alta', 'Activo', 'AL05'),
('C010', 'R U Mine?', 200, '2013-09-09', 'Alta', 'Activo', 'AL05'),
('C011', 'Levitating', 203, '2020-03-27', 'Alta', 'Activo', 'AL06'),
('C012', 'Dont Start Now', 183, '2020-03-27', 'Alta', 'Activo', 'AL06'),
('C013', 'Master of Puppets', 515, '1986-03-03', 'Estándar', 'Activo', 'AL07'),
('C014', 'Battery', 312, '1986-03-03', 'Estándar', 'Activo', 'AL07'),
('C015', 'Blinding Lights', 200, '2020-03-20', 'Alta', 'Activo', 'AL08'),
('C016', 'Save Your Tears', 215, '2020-03-20', 'Alta', 'Activo', 'AL08'),
('C017', 'Starboy', 230, '2016-11-25', 'Alta', 'Activo', 'AL09'),
('C018', 'I Feel It Coming', 269, '2016-11-25', 'Alta', 'Activo', 'AL09'),
('C019', 'Chantaje', 195, '2017-05-26', 'Estándar', 'Activo', 'AL10'),
('C020', 'Me Enamore', 186, '2017-05-26', 'Estándar', 'Activo', 'AL10'),
('C021', 'Whenever Wherever', 196, '2001-11-13', 'Estándar', 'Inactivo', 'AL11'),
('C022', 'Underneath Your Clothes', 224, '2001-11-13', 'Estándar', 'Activo', 'AL11'),
('C023', 'En la Ciudad de la Furia', 510, '1996-09-25', 'Estándar', 'Activo', 'AL12'),
('C024', 'Te para Tres', 233, '1996-09-25', 'Estándar', 'Activo', 'AL12'),
('C025', 'De Musica Ligera', 213, '1990-08-07', 'Estándar', 'Activo', 'AL13'),
('C026', 'Entre Canibales', 246, '1990-08-07', 'Estándar', 'Activo', 'AL13'),
('C027', '24K Magic', 226, '2016-11-18', 'Alta', 'Activo', 'AL14'),
('C028', 'That is What I Like', 206, '2016-11-18', 'Alta', 'Activo', 'AL14'),
('C029', 'Provenza', 210, '2023-02-24', 'Alta', 'Activo', 'AL15'),
('C030', 'TQG', 199, '2023-02-24', 'Alta', 'Activo', 'AL15'),
('C031','Nuestro Juramento',210,'1965-05-10','Estándar','Activo','AL16'),
('C032','Fatalidad',195,'1965-05-10','Estándar','Activo','AL16'),
('C033','Cinco Centavitos',205,'1970-03-20','Estándar','Activo','AL17'),
('C034','Rondando tu Esquina',200,'1970-03-20','Estándar','Activo','AL17'),
('C035','El Provinciano',230,'2005-06-01','Alta','Activo','AL18'),
('C036','Amor de Pobre',215,'2005-06-01','Alta','Activo','AL18'),
('C037','Lágrimas de Amor',225,'2010-09-15','Alta','Activo','AL19'),
('C038','Nunca Te Olvidaré',210,'2010-09-15','Alta','Activo','AL19'),
('C039','Seductor',200,'2008-07-12','Alta','Activo','AL20'),
('C040','Amarte Así',205,'2008-07-12','Alta','Activo','AL20'),
('C041','De Cantina',215,'2013-04-05','Alta','Activo','AL21'),
('C042','Entre Copas',220,'2013-04-05','Alta','Activo','AL21'),
('C043','A Mil',198,'2011-08-10','Alta','Activo','AL22'),
('C044','Baila Conmigo',205,'2011-08-10','Alta','Activo','AL22'),
('C045','Instinto Natural',210,'2016-10-22','Alta','Activo','AL23'),
('C046','Corazón Abierto',215,'2016-10-22','Alta','Activo','AL23'),
('C047','Vida',190,'2009-02-14','Alta','Activo','AL24'),
('C048','Te Amaré',200,'2009-02-14','Alta','Activo','AL24'),
('C049','Tu Amor',210,'2014-05-30','Alta','Activo','AL25'),
('C050','Eres Tú',205,'2014-05-30','Alta','Activo','AL25'),
('C051','El Dueño del Swing',210,'2001-01-01','Estándar','Activo','AL26'),
('C052','Latino Caliente',200,'2001-01-01','Estándar','Activo','AL26'),
('C053','Escándalo',215,'2004-03-18','Estándar','Activo','AL27'),
('C054','Fiesta Total',220,'2004-03-18','Estándar','Activo','AL27'),
('C055','En Otros Mundos',240,'2000-11-11','Alta','Activo','AL28'),
('C056','Si No Es Contigo',230,'2000-11-11','Alta','Activo','AL28'),
('C057','Frenesí',235,'2006-06-06','Alta','Activo','AL29'),
('C058','Irremediablemente Tarde',225,'2006-06-06','Alta','Activo','AL29'),
('C059','Hijos del Dolor',300,'1999-09-09','Estándar','Activo','AL30'),
('C060','Guerreros',290,'1999-09-09','Estándar','Activo','AL30'),
('C061','Despierta',280,'2003-08-20','Estándar','Activo','AL31'),
('C062','Metal Andino',295,'2003-08-20','Estándar','Activo','AL31'),
('C063','Guardarraya',240,'2002-07-07','Alta','Activo','AL32'),
('C064','Camino',230,'2002-07-07','Alta','Activo','AL32'),
('C065','Entre el Barro',235,'2008-12-12','Alta','Activo','AL33'),
('C066','Ciudad',220,'2008-12-12','Alta','Activo','AL33'),
('C067','La Santa Fanesca',250,'2014-03-03','Alta','Activo','AL34'),
('C068','Ritual',245,'2014-03-03','Alta','Activo','AL34'),
('C069','Somos',230,'2018-04-21','Alta','Activo','AL35'),
('C070','Raíz',225,'2018-04-21','Alta','Activo','AL35');
GO

-- CARGA DE CANCION_GENERO (Relación de las canciones con sus géneros)
-- Usando los géneros: G001(Rock), G002(Pop), G003(Reggaeton), G006(Metal), etc.
INSERT INTO Musica.CancionGenero (idCancion, idGenero) VALUES
('C001', 'G002'), ('C002', 'G002'), -- Taylor (Pop)
('C003', 'G005'), ('C004', 'G005'), -- Taylor (Indie)
('C005', 'G003'), ('C006', 'G003'), -- Bad Bunny (Reggaeton)
('C007', 'G003'), ('C008', 'G007'), -- Bad Bunny (Reggaeton/Trap)
('C009', 'G001'), ('C010', 'G001'), -- Arctic Monkeys (Rock)
('C011', 'G002'), ('C012', 'G002'), -- Dua Lipa (Pop)
('C013', 'G006'), ('C014', 'G006'), -- Metallica (Metal)
('C015', 'G002'), ('C016', 'G010'), -- Weeknd (Pop/Techno)
('C017', 'G002'), ('C018', 'G002'), -- Weeknd (Pop)
('C019', 'G003'), ('C020', 'G002'), -- Shakira (Reggaeton/Pop)
('C021', 'G002'), ('C022', 'G002'), -- Shakira (Pop)
('C023', 'G001'), ('C024', 'G001'), -- Soda Stereo (Rock)
('C025', 'G001'), ('C026', 'G001'), -- Soda Stereo (Rock)
('C027', 'G002'), ('C028', 'G002'), -- Bruno Mars (Pop)
('C029', 'G003'), ('C030', 'G003'), -- Karol G (Reggaeton)
('C031','G009'),('C032','G009'),('C033','G009'),('C034','G009'),-- Julio Jaramillo (adaptado a catálogo moderno)
('C035','G002'),('C036','G002'),('C037','G002'),('C038','G002'),-- Daniel Betancourt (Pop)
('C039','G002'),('C039','G009'),('C040','G002'),('C041','G009'),('C042','G009'),-- Gerardo Morán (Pop / Salsa)
('C043','G002'),('C043','G005'),('C044','G002'),('C045','G005'),('C046','G002'),-- Fausto Miño (Pop / Indie)
('C047','G001'),('C048','G001'),('C049','G001'),('C050','G001'),-- Pancho Terán (Rock)
('C051','G003'),('C051','G007'),('C052','G003'),('C053','G007'),('C054','G003'),-- AU-D (Urbano ? Reggaeton / Trap)
('C055','G001'),('C055','G005'),('C056','G001'),('C057','G005'),('C058','G001'),-- Verde70 (Rock / Indie)
('C059','G006'),('C060','G006'),('C061','G006'),('C062','G006'),-- Basca (Metal)
('C063','G005'),('C063','G004'),('C064','G005'),('C065','G004'),('C066','G005'),-- Swing Original Monks (Indie / Jazz fusión)
('C067','G008'),('C067','G010'),('C068','G010'),('C069','G008'),('C070','G010');-- Nicola Cruz (Lo-fi / Techno)SSSS
GO

-- 1. CARGA DE SUSCRIPCIONES (Una para cada usuario)
-- Tipos: 'Individual', 'Estudiante', 'Familiar' | Estados: 'Activa', 'Cancelada', 'Vencida'
INSERT INTO Operaciones.Suscripcion (idSuscripcion, tipoSuscripcion, fechaInicioSuscripcion, fechaFinSuscripcion, estadoSuscripcion, idUsuario) VALUES
('S001', 'Individual', '2026-04-20', '2026-05-20', 'Activa', 'U001'),
('S002', 'Estudiante', '2026-04-20', '2026-05-20', 'Activa', 'U002'),
('S003', 'Familiar',   '2026-04-21', '2026-05-21', 'Activa', 'U003'),
('S004', 'Individual', '2026-04-22', '2026-05-21', 'Activa', 'U004'),
('S005', 'Individual', '2026-04-22', '2026-05-22', 'Activa', 'U005'),
('S006', 'Estudiante', '2026-04-20', '2026-05-20', 'Activa', 'U006'),
('S007', 'Familiar',   '2026-04-23', '2026-05-23', 'Activa', 'U007'),
('S008', 'Individual', '2025-04-20', '2025-05-20', 'Vencida', 'U008'),
('S009', 'Individual', '2026-04-20', '2026-05-20', 'Cancelada', 'U009'),
('S010', 'Estudiante', '2026-04-24', '2026-05-24', 'Activa', 'U010');
GO

-- CARGA DE LIKES (Interacción de usuarios con canciones)
-- Esto alimenta el reporte de "Canciones con Like"
INSERT INTO Usuarios.LikeCancion (idCancion, IdUsuario) VALUES
('C001', 'U001'), ('C009', 'U001'), ('C023', 'U001'), -- Mateo prefiere Pop y Rock
('C005', 'U002'), ('C029', 'U002'), ('C030', 'U002'), -- Maria prefiere Reggaeton
('C013', 'U003'), ('C014', 'U003'), ('C009', 'U003'), -- Juan prefiere Rock/Metal
('C011', 'U004'), ('C015', 'U004'), ('C027', 'U004'); -- Elena prefiere Pop
GO

-- CARGA DE PLAYLISTS
INSERT INTO Usuarios.Playlist (idPlaylist, nombrePlaylist, descripcionPlaylist, visibilidad, idUsuarioPropietario) VALUES
('P001', 'Rock Argentino', 'Lo mejor de Soda y más', 'Pública', 'U001'),
('P002', 'Perreo 2026', 'Para el fin de semana', 'Pública', 'U002'),
('P003', 'Focus Coding', 'Música para programar en .NET', 'Privada', 'U001'),
('P004', 'Gym Hits', 'Energía pura', 'Pública', 'U004'),
('P005', 'Colab Metal', 'Playlist compartida de clásicos', 'Pública', 'U003');
GO

-- VINCULAR CANCIONES A PLAYLISTS
INSERT INTO Usuarios.PlaylistCancion (idPlaylist, idCancion) VALUES
('P001', 'C023'), ('P001', 'C024'), ('P001', 'C025'),
('P002', 'C005'), ('P002', 'C006'), ('P002', 'C030'),
('P003', 'C015'), ('P003', 'C017'), ('P003', 'C018'),
('P005', 'C013'), ('P005', 'C014'), ('P005', 'C009');
GO

-- COLABORADORES EN PLAYLIST (Probando la lógica del Profe)
-- El dueño de P005 es Juan (U003), pero Mateo (U001) es colaborador.
INSERT INTO Usuarios.PlaylistUsuarioColaborador (idPlaylist, IdUsuarioColaborador) VALUES
('P005', 'U001'),
('P005', 'U004');
GO

-- CARGA DE PAGOS (Relacionados a las suscripciones activas)
-- Precios sugeridos: Individual $9.99, Estudiante $5.99, Familiar $14.99
INSERT INTO Operaciones.Pago (idPago, monto, fechaPago, metodoPago, resultadoPago, idSuscripcion) VALUES
('P001', 9.99, '2026-04-20', 'Tarjeta de Crédito', 'Aprobado', 'S001'),
('P002', 5.99, '2026-04-20', 'PayPal', 'Aprobado', 'S002'),
('P003', 14.99, '2026-04-21', 'Tarjeta de Débito', 'Aprobado', 'S003'),
('P004', 9.99, '2026-04-22', 'Tarjeta de Crédito', 'Aprobado', 'S004'),
('P005', 9.99, '2026-04-22', 'Transferencia', 'Aprobado', 'S005'),
('P006', 5.99, '2026-04-20', 'PayPal', 'Aprobado', 'S006'),
('P007', 14.99, '2026-04-23', 'Tarjeta de Crédito', 'Aprobado', 'S007'),
('P008', 9.99, '2025-04-20', 'Tarjeta de Crédito', 'Aprobado', 'S008'),
('P009', 5.99, '2026-04-20', 'Efectivo', 'Aprobado', 'S010'),
('P010', 9.99, '2026-04-24', 'Tarjeta de Crédito', 'Fallido', 'S001'); -- Un pago fallido para probar
GO

-- CARGA DE REPRODUCCIONES (Volumen para reportes)
-- Formato: idCancion, IdUsuario, Pais, Fecha, Duración (seg)
INSERT INTO Operaciones.ReproduccionCancion (idCancion, IdUsuario, paisReproduccion, fechaReproduccion, duracionReproduccion) VALUES
-- Taylor Swift (A001) - Muy escuchada en USA y Ecuador
('C001', 'U001', 'Ecuador', '2026-04-20 10:30:00', 200),
('C001', 'U004', 'USA', '2026-04-21 14:20:00', 200),
('C001', 'U006', 'USA', '2026-04-22 08:15:00', 150),
('C003', 'U001', 'Ecuador', '2026-04-20 11:00:00', 239),

-- Bad Bunny (A002) - Dominando en México y Colombia
('C005', 'U002', 'Mexico', '2026-04-23 22:00:00', 243),
('C005', 'U007', 'Colombia', '2026-04-23 23:15:00', 243),
('C006', 'U002', 'Mexico', '2026-04-24 01:00:00', 178),
('C006', 'U010', 'Ecuador', '2026-04-24 09:00:00', 178),

-- Arctic Monkeys (A003) - Popular en Argentina y UK (simulado)
('C009', 'U001', 'Argentina', '2026-04-15 18:00:00', 272),
('C009', 'U003', 'Argentina', '2026-04-16 19:30:00', 272),
('C010', 'U003', 'Argentina', '2026-04-16 20:00:00', 200),

-- The Weeknd (A006) - Global
('C015', 'U004', 'USA', '2026-04-10 12:00:00', 200),
('C015', 'U005', 'Ecuador', '2026-04-11 13:00:00', 200),
('C016', 'U008', 'España', '2026-04-12 15:45:00', 215),

-- Soda Stereo (A008) - Leyendas en Latam
('C023', 'U001', 'Ecuador', '2026-04-05 09:00:00', 510),
('C025', 'U001', 'Argentina', '2026-04-06 10:00:00', 213),
('C025', 'U007', 'Colombia', '2026-04-07 11:00:00', 213),
('C023', 'U009', 'Mexico', '2026-04-08 12:00:00', 400); -- Escucha parcial
GO

-- CARGA DE SEGUIMIENTO DE ARTISTAS (Quién sigue a quién)
-- Esto alimenta el reporte "Artistas seguidos"
INSERT INTO Usuarios.SeguimientoArtistas (idArtista, IdUsuario) VALUES
('A001', 'U001'), ('A008', 'U001'), ('A003', 'U001'), -- Mateo sigue a Taylor, Soda y Arctic
('A002', 'U002'), ('A010', 'U002'), ('A007', 'U002'), -- Maria sigue al bloque urbano
('A005', 'U003'), ('A008', 'U003'), ('A003', 'U003'), -- Juan sigue Rock/Metal
('A001', 'U004'), ('A004', 'U004'), ('A006', 'U004'), -- Elena sigue Pop/Indie
('A002', 'U010'), ('A010', 'U010');
GO

-- CARGA DE ÁLBUMES GUARDADOS (Biblioteca personal)
-- Esto alimenta el reporte "Álbumes guardados"
INSERT INTO Usuarios.AlbumGuardado (idAlbum, IdUsuario) VALUES
('AL01', 'U001'), ('AL12', 'U001'), ('AL13', 'U001'), -- Mateo guardó Midnights y Soda Stereo
('AL03', 'U002'), ('AL15', 'U002'),                  -- Maria guardó Bad Bunny y Karol G
('AL07', 'U003'), ('AL05', 'U003'),                  -- Juan guardó Metallica y Arctic Monkeys
('AL01', 'U004'), ('AL06', 'U004'), ('AL08', 'U004'); -- Elena guardó Taylor, Dua Lipa y Weeknd
GO

-- CARGA DE REGALÍAS (Pago por reproducciones)
-- Basado en un promedio de $0.004 por reproducción (como Spotify real)
INSERT INTO Operaciones.Regalia (idRegalia, fechaInicio, fechaFin, totalReproducciones, montoTotal, fechaPago, idArtista) VALUES
-- Taylor Swift: 500k repros (simuladas para el registro)
('R001', '2026-03-01', '2026-03-31', 500000, 2000.00, '2026-04-10', 'A001'),
-- Bad Bunny: 750k repros
('R002', '2026-03-01', '2026-03-31', 750000, 3000.00, '2026-04-10', 'A002'),
-- Soda Stereo: 100k repros
('R003', '2026-03-01', '2026-03-31', 100000, 400.00, '2026-04-10', 'A008'),
-- Metallica: 200k repros
('R004', '2026-03-01', '2026-03-31', 200000, 800.00, '2026-04-10', 'A005'),
-- Karol G: 400k repros
('R005', '2026-03-01', '2026-03-31', 400000, 1600.00, '2026-04-10', 'A010');
GO

-- OBJETOS PROGRAMABLES PARA LA TABLA MUSICA.CANCION ------------------------------------------------------------------------------------------------

-- INSERT
-- OBJETO: STORE PROCEDURE PARA LA INSERCIÓN DE REGISTROS
CREATE PROCEDURE SP_InsertarCancion
@IdCancion CHAR(4),
@nombre NVARCHAR(100),
@duracion INT,
@fechaLanzamiento DATE,
@calidad NVARCHAR(100),
@estado NVARCHAR(15),
@Album NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @idAlbum CHAR(4)

        IF EXISTS (
            SELECT 1 
            FROM Musica.Cancion
            WHERE idCancion = @IdCancion
        )
        BEGIN
            THROW 50031, 'La cancion ya existe.', 1;
        END

        IF @duracion <= 0
        BEGIN
            THROW 50032, 'La duracion debe ser mayor a 0.', 1;
        END

       IF @calidad NOT IN ('Estándar', 'Alta')
        BEGIN
            THROW 50033, 'Calidad Inválida', 1;
        END

       IF @estado NOT IN ('Activo', 'Inactivo')
        BEGIN
            THROW 50034, 'Estado Inválido', 1;
        END

        IF NOT EXISTS (
            SELECT 1 
            FROM Musica.Album
            WHERE nombreAlbum = @Album
        )
        BEGIN
            THROW 50035, 'El Album no existe.', 1;
        END
        
        SELECT @idAlbum = MA.idAlbum
        FROM  Musica.Album AS MA
        WHERE MA.nombreAlbum = @Album;

        INSERT INTO Musica.Cancion(idCancion, nombreCancion, duracionCancion, fechaLanzamientoCancion, calidadAudio, estadoCancion, idAlbum)
        VALUES(@IdCancion, @nombre, @duracion, @fechaLanzamiento,@calidad, @estado, @idAlbum)

    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_LINE() AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure;
    END CATCH
END
GO

-- SELECT
-- OBJETO: VIEW PARA CONSULTA DE LISTADO DE REGISTROS
CREATE VIEW vListadoDeCanciones
AS
SELECT MC.idCancion AS IdCancion,MC.nombreCancion AS Cancion, MC.duracionCancion AS Duracion, MC.fechaLanzamientoCancion AS FechaDeLanzamiento,
MC.calidadAudio AS CalidadDeAudio, MC.estadoCancion AS Estado
FROM Musica.Cancion AS MC
GO			

-- UPDATE
-- OBJETO: STORE PROCEDURE PARA ACTUALIZAR REGISTROS
CREATE PROCEDURE SP_ActualizarCancion
@IdCancion CHAR(4),
@nombre NVARCHAR(100) = NULL,
@duracion INT = NULL,
@fechaLanzamiento DATE = NULL,
@calidad NVARCHAR(100) = NULL,
@estado NVARCHAR(15) = NULL,
@Album NVARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        DECLARE @idAlbum CHAR(4)

        IF NOT EXISTS (
            SELECT 1 
            FROM Musica.Cancion
            WHERE idCancion = @IdCancion
        )
        BEGIN
            THROW 50035, 'La cancion no existe.', 1;
        END

        IF @duracion <= 0
        BEGIN
            THROW 50032, 'La duracion debe ser mayor a 0.', 1;
        END

       IF @calidad NOT IN ('Estándar', 'Alta')
        BEGIN
            THROW 50033, 'Calidad Inválida', 1;
        END

       IF @estado NOT IN ('Activo', 'Inactivo')
        BEGIN
            THROW 50034, 'Estado Inválido', 1;
        END

        IF @Album IS NOT NULL
        BEGIN
            IF NOT EXISTS (
                SELECT 1 
                FROM Musica.Album
                WHERE nombreAlbum = @Album
            )
            BEGIN
                THROW 50035, 'El Album no existe.', 1;
            END
        
            SELECT @idAlbum = MA.idAlbum
            FROM  Musica.Album AS MA
            WHERE MA.nombreAlbum = @Album;
        END

        UPDATE Musica.Cancion
        SET
            nombreCancion = ISNULL(@nombre, nombreCancion),
            duracionCancion = ISNULL(@duracion, duracionCancion),
            fechaLanzamientoCancion = ISNULL(@fechaLanzamiento, fechaLanzamientoCancion),
            calidadAudio = ISNULL(@calidad, calidadAudio),
            estadoCancion = ISNULL(@estado, estadoCancion),
            idAlbum = ISNULL(@idAlbum, idAlbum)

        WHERE idCancion = @IdCancion

    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_LINE() AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure;
    END CATCH
END
GO

-- DELETE
--OBJETO: STORE PROCEDURE PARA LA ELIMINACIÓN DE REGISTROS
CREATE PROCEDURE SP_EliminarCancion
@IdCancion CHAR(4)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (
            SELECT 1 
            FROM Musica.Cancion
            WHERE idCancion = @IdCancion
        )
        BEGIN
            THROW 50035, 'La cancion no existe.', 1;
        END

        DELETE FROM Musica.Cancion
        WHERE idCancion = @IdCancion

    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_LINE() AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure;
    END CATCH
END
GO

-- CREACION DE LOGIN-USER PARA LA BASE DE DATOS VIVEEC-TABLA MUSICA.CANCION----------------------------------------------------------------------------

-- 1. Crear Login
USE MASTER
GO
CREATE LOGIN [pythonconsultorViveEC] WITH PASSWORD='VIVEEC',
DEFAULT_DATABASE=ViveEC
GO
-- 2. Conceder permiso de Conexion
use [master]
GO
GRANT CONNECT SQL TO [pythonconsultorViveEC]
GO
-- 3. Asignar o Crear Usuario de Base de Datos
USE ViveEC
GO
CREATE USER pythonconsultorViveEC FOR LOGIN pythonconsultorViveEC
GO
-- 4. Conceder permisos al usuario para hacer operacion DML y ejecutar Objetos Porgramables
GRANT SELECT ON Musica.Cancion TO pythonconsultorViveEC
GO
GRANT INSERT,UPDATE,DELETE ON Musica.Cancion TO pythonconsultorViveEC
GO
GRANT EXECUTE ON SP_InsertarCancion TO pythonconsultorViveEC
GO
GRANT EXECUTE ON SP_ActualizarCancion TO pythonconsultorViveEC
GO
GRANT EXECUTE ON SP_EliminarCancion TO pythonconsultorViveEC
GO

-- 4.1 Conceder todos los Permisos de lectura y escritura -- para todos los objetos de la BDD
ALTER ROLE db_datareader ADD MEMBER pythonconsultorViveEC
GO
ALTER ROLE db_datawriter ADD MEMBER pythonconsultorViveEC
GO
