USE [APPRestaurante]
GO
/****** Object:  UserDefinedFunction [dbo].[EncriptarClave]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  Table [dbo].[Cliente]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  Table [dbo].[Logs]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  Table [dbo].[Permiso]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  Table [dbo].[Rol]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  Table [dbo].[RolPermiso]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  Table [dbo].[RolUsuario]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  Table [dbo].[Usuario]    Script Date: 10/07/2018 17:25:31 ******/
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
SET IDENTITY_INSERT [dbo].[Permiso] ON 

INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (1, N'Dashboard', 1, 0, N'/Inicio/Index')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (2, N'Menu', 1, 0, N'')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (3, N'Registro de menú', 1, 2, N'/Menu/Index')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (4, N'Acceso', 1, 0, NULL)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (5, N'Registro de empleado', 1, 4, N'/Empleado/Index')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (6, N'Registro de usuario', 1, 4, N'/Usuario/Index')
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (7, N'Caja', 1, 0, NULL)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url]) VALUES (8, N'Cobro de consumo', 1, 7, N'/Cobranza/Index')
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
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (7, 2, 7)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (8, 2, 8)
SET IDENTITY_INSERT [dbo].[RolPermiso] OFF
SET IDENTITY_INSERT [dbo].[RolUsuario] ON 

INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (1, 1, 1, 1)
INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (2, 2, 2, 1)
SET IDENTITY_INSERT [dbo].[RolUsuario] OFF
SET IDENTITY_INSERT [dbo].[Usuario] ON 

INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado]) VALUES (1, N'hugo.roca', N'B11DE28C967D26AA47DA5326E7B092FA9B73FD2C', 1)
INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado]) VALUES (2, N'jehidi.chavez', N'B11DE28C967D26AA47DA5326E7B092FA9B73FD2C', 1)
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
/****** Object:  StoredProcedure [dbo].[procLogs_Insert]    Script Date: 10/07/2018 17:25:31 ******/
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
/****** Object:  StoredProcedure [dbo].[Usuario_ListarOpcionesAcceso_SP]    Script Date: 10/07/2018 17:25:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usuario_ListarOpcionesAcceso_SP](
@usuario varchar(50)
)
as
begin
	select p.descripcion, p.url, p.id, p.padre 
	from permiso p
	inner join rolpermiso rp on rp.idpermiso = p.id
	inner join rolusuario ru on ru.idrol = rp.idrol
	inner join usuario u on u.id = ru.idusuario
	where u.usuario = @usuario and u.estado =  1
end
GO
/****** Object:  StoredProcedure [dbo].[Usuario_Validar_SP]    Script Date: 10/07/2018 17:25:31 ******/
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
