USE [APPRestaurante]
GO
/****** Object:  StoredProcedure [dbo].[procLogs_Insert]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procLogs_Insert] 
	@log_date datetime2, 
  @log_thread varchar(50), 
  @log_level varchar(50), 
  @log_source varchar(300), 
  @log_message varchar(4000), 
  @exception varchar(4000)
AS
BEGIN
	SET NOCOUNT ON;

  insert into dbo.Logs (logDate, logThread, logLevel, logSource, logMessage, exception)
  values (@log_date, @log_thread, @log_level, @log_source, @log_message, @exception)

END

GO
/****** Object:  StoredProcedure [dbo].[Usuario_Validar_SP]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usuario_Validar_SP](
	@usuario varchar(50),
	@clave varchar(100)
)
as
begin
	declare @encriptado varchar(100) = dbo.EncriptarClave(@clave)
	select id, usuario, clave, estado from usuario where usuario = @usuario and clave = @encriptado and estado = 1
end

GO
/****** Object:  UserDefinedFunction [dbo].[EncriptarClave]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[EncriptarClave] (@Clave NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
	SET @Clave = UPPER(@Clave)

	DECLARE @ClaveEncriptada NVARCHAR(MAX);

	SELECT
		@ClaveEncriptada = UPPER(SUBSTRING(master.dbo.fn_varbintohexstr(HASHBYTES('SHA1', @Clave)), 3, 40));

	RETURN @ClaveEncriptada;
END
GO
/****** Object:  Table [dbo].[Cliente]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cliente](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NULL,
	[apellido] [varchar](100) NULL,
	[tipo_documento] [varchar](20) NOT NULL,
	[num_documento] [varchar](20) NOT NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Logs]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Logs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[logDate] [datetime2](7) NOT NULL,
	[logThread] [varchar](50) NOT NULL,
	[logLevel] [varchar](50) NOT NULL,
	[logSource] [varchar](300) NOT NULL,
	[logMessage] [varchar](4000) NOT NULL,
	[exception] [varchar](4000) NULL,
 CONSTRAINT [PK_Logs] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Permiso]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Permiso](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](100) NULL,
	[estado] [bit] NULL,
	[padre] [int] NULL,
	[url] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rol]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rol](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](50) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Rol] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RolPermiso]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolPermiso](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idRol] [int] NOT NULL,
	[idPermiso] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RolUsuario]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolUsuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idUsuario] [int] NOT NULL,
	[idRol] [int] NOT NULL,
	[estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 9/7/2018 23:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [varchar](50) NULL,
	[clave] [varchar](100) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_dbo.Usuario] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Cliente] ON 

INSERT [dbo].[Cliente] ([id], [nombre], [apellido], [tipo_documento], [num_documento], [estado]) VALUES (3, N'Hugo', N'Roca', N'DNI', N'12345678', 0)
INSERT [dbo].[Cliente] ([id], [nombre], [apellido], [tipo_documento], [num_documento], [estado]) VALUES (5, N'Hugo', N'Roca', N'DNI', N'12345678', 1)
INSERT [dbo].[Cliente] ([id], [nombre], [apellido], [tipo_documento], [num_documento], [estado]) VALUES (6, N'Hugo', N'Roca', N'DNI', N'12345678', 1)
INSERT [dbo].[Cliente] ([id], [nombre], [apellido], [tipo_documento], [num_documento], [estado]) VALUES (7, N'Hugo', N'Roca', N'DNI', N'12345678', 1)
INSERT [dbo].[Cliente] ([id], [nombre], [apellido], [tipo_documento], [num_documento], [estado]) VALUES (8, N'Hugo', N'Roca', N'DNI', N'12345678', 1)
SET IDENTITY_INSERT [dbo].[Cliente] OFF
SET IDENTITY_INSERT [dbo].[Logs] ON 

INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (1, CAST(0x0760B069E6806B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (2, CAST(0x0750BE2F15896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (3, CAST(0x07A0105C37896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (4, CAST(0x0700A9CE49896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (5, CAST(0x0790D4536D896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (6, CAST(0x0710ABF286896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (7, CAST(0x07E085268A896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (8, CAST(0x07B013BD90896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (9, CAST(0x07A0B3E5AA896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (10, CAST(0x07F0D094CA896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (11, CAST(0x0710594FDB896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (12, CAST(0x07409C62F5896B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (13, CAST(0x073047C8088A6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (14, CAST(0x071001BA188A6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'this is my error message', N'')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (15, CAST(0x07E02C5CF78A6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (16, CAST(0x0790024B008B6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (17, CAST(0x0770AB24118B6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (18, CAST(0x07B0B4CAE98B6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (19, CAST(0x07E08908F28B6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (20, CAST(0x07507DD2FB8B6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (21, CAST(0x076096F0278C6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (22, CAST(0x07908C766C8C6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (23, CAST(0x07D037109C8C6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (24, CAST(0x07507AFCBA8C6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (25, CAST(0x07800531D5AA6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (26, CAST(0x0770564F9DAB6B3E0B AS DateTime2), N'1', N'ERROR', N'C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs', N'división entro 0', N'System.DivideByZeroException: Intento de dividir por cero.
   en Log4Net.Program.<Main>g__divide|1_0() en C:\Users\hugor\Documents\GitHub\LOG4NET_PRINCIPIANTE_A_FIN\Log4Net\Log4Net\Program.cs:línea 24')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (27, CAST(0x07305F7CFAB76B3E0B AS DateTime2), N'5', N'ERROR', N'C:\Users\hugor\Documents\GitHub\APPRESTAURANTE\APPRestaurante\APPRestaurante.Web\Areas\Admin\Controllers\InicioController.cs', N'Intento de dividir por cero.', N'System.DivideByZeroException: Intento de dividir por cero.
   en APPRestaurante.Web.Areas.Admin.Controllers.InicioController.Error() en C:\Users\hugor\Documents\GitHub\APPRESTAURANTE\APPRestaurante\APPRestaurante.Web\Areas\Admin\Controllers\InicioController.cs:línea 40')
INSERT [dbo].[Logs] ([id], [logDate], [logThread], [logLevel], [logSource], [logMessage], [exception]) VALUES (28, CAST(0x0720E23F84C06F3E0B AS DateTime2), N'6', N'ERROR', N'C:\Users\hugor\Documents\GitHub\APPRESTAURANTE\APPRestaurante\APPRestaurante.Web\Areas\Admin\Controllers\LoginController.cs', N'Error Validar Usuario', N'System.NullReferenceException: Referencia a objeto no establecida como instancia de un objeto.
   en APPRestaurante.Web.Areas.Admin.Controllers.LoginController.ValidarUsuario(String usuario, String clave) en C:\Users\hugor\Documents\GitHub\APPRESTAURANTE\APPRestaurante\APPRestaurante.Web\Areas\Admin\Controllers\LoginController.cs:línea 39')
SET IDENTITY_INSERT [dbo].[Logs] OFF
SET IDENTITY_INSERT [dbo].[Permiso] ON 

INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (1, N'Dashboard', 1, 0, N'/Inicio/Index')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (2, N'Menu', 1, 0, N'')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (3, N'Registro de menú', 1, 2, N'/Menu/Index')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (4, N'Acceso', 1, 0, NULL)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (5, N'Registro de empleado', 1, 4, N'/Empleado/Index')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (6, N'Registro de usuario', 1, 4, N'/Usuario/Index')
SET IDENTITY_INSERT [dbo].[Permiso] OFF
SET IDENTITY_INSERT [dbo].[Rol] ON 

INSERT [dbo].[Rol] ([id], [descripcion], [estado]) VALUES (1, N'Administrador', 1)
INSERT [dbo].[Rol] ([id], [descripcion], [estado]) VALUES (2, N'Cajero', 1)
INSERT [dbo].[Rol] ([id], [descripcion], [estado]) VALUES (3, N'Cocinero', 1)
SET IDENTITY_INSERT [dbo].[Rol] OFF
SET IDENTITY_INSERT [dbo].[RolPermiso] ON 

INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (1, 1, 1)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (2, 1, 2)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (3, 1, 3)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (4, 1, 4)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (5, 1, 5)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (6, 1, 6)
SET IDENTITY_INSERT [dbo].[RolPermiso] OFF
SET IDENTITY_INSERT [dbo].[RolUsuario] ON 

INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (1, 1, 1, 1)
SET IDENTITY_INSERT [dbo].[RolUsuario] OFF
SET IDENTITY_INSERT [dbo].[Usuario] ON 

INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado]) VALUES (1, N'hugo.roca', N'B11DE28C967D26AA47DA5326E7B092FA9B73FD2C', 1)
SET IDENTITY_INSERT [dbo].[Usuario] OFF
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermisoPermiso] FOREIGN KEY([idPermiso])
REFERENCES [dbo].[Permiso] ([id])
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermisoPermiso]
GO
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermisoRol] FOREIGN KEY([idRol])
REFERENCES [dbo].[Rol] ([id])
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermisoRol]
GO
ALTER TABLE [dbo].[RolUsuario]  WITH CHECK ADD  CONSTRAINT [FK_RolRolUsuario] FOREIGN KEY([idRol])
REFERENCES [dbo].[Rol] ([id])
GO
ALTER TABLE [dbo].[RolUsuario] CHECK CONSTRAINT [FK_RolRolUsuario]
GO
ALTER TABLE [dbo].[RolUsuario]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioRolUsuario] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuario] ([id])
GO
ALTER TABLE [dbo].[RolUsuario] CHECK CONSTRAINT [FK_UsuarioRolUsuario]
GO
