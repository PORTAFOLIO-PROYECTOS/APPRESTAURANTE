USE [APPRestaurante]
GO
/****** Object:  StoredProcedure [dbo].[Cobranza_Detalle_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Cobranza_Detalle_SP](@id int)
as
begin
	select md.titulo, 
	md.tipo, 
	CONVERT(varchar(50), CONVERT(money, md.precio), 1) precio, 
	pd.cantidad, 
	CONVERT(varchar(50), CONVERT(money, pd.subtotal), 1) subtotal, 
	md.foto 
	from PedidoDetalle pd
	inner join MenuDetalle md on pd.idMenu = md.id
	where pd.idPedido = @id 
	order by md.tipo, md.titulo
end
GO
/****** Object:  StoredProcedure [dbo].[Incio_ListaPedidos_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Incio_ListaPedidos_SP](@fecha datetime)
as
begin
select * from pedido where convert(date, fecha) = convert(date, @fecha)
end
GO
/****** Object:  StoredProcedure [dbo].[Inicio_LoMasPedido_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Inicio_LoMasPedido_SP]
as
begin
select top 7 titulo, CONVERT(varchar(50), CONVERT(money, precio), 1) precio, tipo from MenuDetalle md 
inner join (
select idmenu, count(*) total from PedidoDetalle group by idMenu) c on md.id = c.idMenu
order by c.total desc
end

GO
/****** Object:  StoredProcedure [dbo].[Menu_Editar_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Menu_Editar_SP](
@idDetalle int,
@titulo varchar(250),
@descripcion varchar(500),
@tipo varchar(100),
@precio money,
@foto varchar(500)
)
as
begin
	update MenuDetalle set
		titulo = @titulo,
		descripcion = @descripcion,
		tipo = @tipo,
		precio = @precio,
		foto = @foto
	where id = @idDetalle
end








GO
/****** Object:  StoredProcedure [dbo].[Menu_Eliminar_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Menu_Eliminar_SP](
@idDetalle int
)
as
begin
	update MenuDetalle set
		estado = 0
	where id = @idDetalle
end








GO
/****** Object:  StoredProcedure [dbo].[Menu_Insertar_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Menu_Insertar_SP](
@fecha date,
@idUsuario int,
@titulo varchar(250),
@descripcion varchar(500),
@tipo varchar(100),
@precio money,
@foto varchar(500)
)
as
begin
	DECLARE @idMenu int = 0;

	IF (select count(*) from menu where CONVERT(DATE, fecha) = @fecha) = 0
	begin
		insert into menu(fecha, idUsuario, fecha_registro) values(@fecha, @idUsuario, getdate())
	end

	set @idMenu = (SELECT id from menu where CONVERT(DATE, fecha) = @fecha)

	insert into MenuDetalle(idMenu, titulo, descripcion, tipo, precio, estado, foto)
	values(@idMenu, @titulo, @descripcion, @tipo, @precio, 1, @foto)
end








GO
/****** Object:  StoredProcedure [dbo].[Menu_Lista_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Menu_Lista_SP](
@desde date,
@hasta date,
@startRow int,
@endRow int
)
as
begin
	SET NOCOUNT ON;
	SELECT 
		[id],
		[idDetalle],
		[fecha],
		[usuario],
		[titulo],
		[descripcion],
		[tipo],
		[precio],
		[foto]
	FROM (
		SELECT 
			ROW_NUMBER() OVER (ORDER BY m.id) fila, 
			m.id, 
			md.id as idDetalle,
			CONVERT(VARCHAR(24), m.fecha, 103) fecha,
			usuario, 
			md.titulo, 
			md.descripcion, 
			md.tipo, 
			md.precio, 
			isnull(md.foto, '') foto
		FROM menu m
		INNER JOIN Usuario u ON u.id = m.idUsuario
		INNER JOIN MenuDetalle md ON md.idMenu = m.id
		WHERE 
			md.estado = 1 AND 
			CONVERT(DATE, m.fecha) <= @hasta AND
			CONVERT(DATE, m.fecha) >= @desde) AS Lista
	WHERE
		fila >= @startRow AND
		fila <= @endRow
	SET NOCOUNT OFF;
end









GO
/****** Object:  StoredProcedure [dbo].[Menu_ListaHome_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Menu_ListaHome_SP '20180826'
CREATE proc [dbo].[Menu_ListaHome_SP](@fecha date)
as
begin
	select 
		md.titulo, 
		md.descripcion, 
		CONVERT(varchar(50), CONVERT(money, md.precio), 1) precioString, 
		md.foto, 
		md.estado, 
		md.tipo,
		md.id
	from menu m
	inner join MenuDetalle md on md.idMenu = m.id
	where CONVERT(date, m.fecha) = @fecha
		and md.estado = 1
	order by md.tipo, md.titulo
end
GO
/****** Object:  StoredProcedure [dbo].[Menu_Obtener_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Menu_Obtener_SP](
@id int
)
AS
BEGIN
    SELECT
      md.id
     ,md.idMenu
     ,md.titulo
     ,md.descripcion
     ,md.tipo
	 ,CONVERT(VARCHAR(24), m.fecha, 103) fecha
     ,isnull(md.foto, '') foto
     ,md.precio
    FROM MenuDetalle md
	inner join Menu m on m.id = md.idMenu
    WHERE md.id = @id
END


GO
/****** Object:  StoredProcedure [dbo].[procLogs_Insert]    Script Date: 2/9/2018 23:07:39 ******/
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
/****** Object:  StoredProcedure [dbo].[Usuario_Insertar_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Usuario_Insertar_SP](
@usuario varchar(50), 
@clave varchar(100), 
@idempleado int,
@idrol int
)
as
begin
	declare @id int

	if not exists (select * from Usuario where idempleado = @idempleado)
	begin
		set @clave = dbo.EncriptarClave(@clave)
		insert into Usuario(usuario, clave, estado, idempleado)
		values(@usuario, @clave, 1, @idempleado)

		set @id = SCOPE_IDENTITY()

		insert into RolUsuario(idUsuario, idRol, estado)
		values(@id, @idrol, 1)	

	end
	else
	begin
		set @clave = dbo.EncriptarClave(@clave)
		update usuario set clave = @clave
		where usuario = @usuario
	end
end

GO
/****** Object:  StoredProcedure [dbo].[Usuario_Lista_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Usuario_Lista_SP]
as
begin
	select 
		u.id
		,u.usuario
		,u.estado
		,e.nombres + ' ' + e.apellidos nombres
		,e.foto
		,r.descripcion rol 
		,e.id idempleado
	from usuario u
	inner join Empleado e on u.idempleado = e.id
	inner join RolUsuario ru on ru.idUsuario = u.id
	inner join rol r on r.id = ru.idRol
end

GO
/****** Object:  StoredProcedure [dbo].[Usuario_ListarOpcionesAcceso_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usuario_ListarOpcionesAcceso_SP](
@idUsuario int
)
as
begin
	select p.descripcion, p.url, p.id, p.padre, isnull(p.icono, '') icono, controlador, active
	from permiso p
	inner join rolpermiso rp on rp.idpermiso = p.id
	inner join rolusuario ru on ru.idrol = rp.idrol
	inner join usuario u on u.id = ru.idusuario
	where u.id = @idUsuario and u.estado =  1
end









GO
/****** Object:  StoredProcedure [dbo].[Usuario_Obtener_SP]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Usuario_Obtener_SP](@id int)
as
begin
	select 
		u.id
		,u.usuario
		,u.estado
		,e.nombres + ' ' + e.apellidos nombres
		,e.foto
		,r.descripcion rol 
		,e.id idEmpleado
		,r.id idRol
	from usuario u
	inner join Empleado e on u.idempleado = e.id
	inner join RolUsuario ru on ru.idUsuario = u.id
	inner join rol r on r.id = ru.idRol
	where u.id = @id
end

GO
/****** Object:  StoredProcedure [dbo].[Usuario_Validar_SP]    Script Date: 2/9/2018 23:07:39 ******/
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

	select u.id, u.usuario, u.clave, u.estado, e.nombres, e.foto from usuario u
	inner join Empleado e on u.idempleado = e.id
	where u.usuario = @usuario and u.clave = @encriptado and u.estado = 1
end











GO
/****** Object:  UserDefinedFunction [dbo].[EncriptarClave]    Script Date: 2/9/2018 23:07:39 ******/
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
/****** Object:  Table [dbo].[Empleado]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Empleado](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombres] [varchar](250) NULL,
	[apellidos] [varchar](250) NULL,
	[direccion] [varchar](250) NULL,
	[celular] [varchar](20) NULL,
	[tipoDocumento] [varchar](20) NULL,
	[documento] [varchar](20) NULL,
	[foto] [varchar](250) NULL,
	[estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Logs]    Script Date: 2/9/2018 23:07:39 ******/
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
/****** Object:  Table [dbo].[Menu]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fecha] [datetime] NULL,
	[idUsuario] [int] NOT NULL,
	[fecha_registro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuDetalle]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MenuDetalle](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idMenu] [int] NOT NULL,
	[titulo] [varchar](250) NULL,
	[descripcion] [varchar](500) NULL,
	[tipo] [varchar](100) NULL,
	[precio] [money] NULL,
	[estado] [bit] NULL,
	[foto] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Pedido]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fecha] [datetime] NULL,
	[total] [money] NULL,
	[nombres] [varchar](250) NULL,
	[mesa] [int] NULL,
	[tipoPago] [varchar](20) NULL,
	[idEmpleado] [int] NULL,
	[idUsuario] [int] NULL,
	[estado] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PedidoDetalle]    Script Date: 2/9/2018 23:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PedidoDetalle](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPedido] [int] NULL,
	[idMenu] [int] NULL,
	[cantidad] [int] NULL,
	[precio] [money] NULL,
	[subtotal] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Permiso]    Script Date: 2/9/2018 23:07:39 ******/
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
	[icono] [varchar](50) NULL,
	[controlador] [varchar](50) NULL,
	[active] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rol]    Script Date: 2/9/2018 23:07:39 ******/
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
/****** Object:  Table [dbo].[RolPermiso]    Script Date: 2/9/2018 23:07:39 ******/
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
/****** Object:  Table [dbo].[RolUsuario]    Script Date: 2/9/2018 23:07:39 ******/
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
/****** Object:  Table [dbo].[Usuario]    Script Date: 2/9/2018 23:07:39 ******/
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
	[idEmpleado] [int] NULL,
 CONSTRAINT [PK_dbo.Usuario] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Empleado] ON 

INSERT [dbo].[Empleado] ([id], [nombres], [apellidos], [direccion], [celular], [tipoDocumento], [documento], [foto], [estado]) VALUES (1, N'Hugo Antonio', N'Roca Espinoza', N'Mz c las2 wdsdj sd', N'978451565', N'DNI', N'75412536', N'20180820092820-joker_chibi.jpg', NULL)
INSERT [dbo].[Empleado] ([id], [nombres], [apellidos], [direccion], [celular], [tipoDocumento], [documento], [foto], [estado]) VALUES (2, N'test', N'test', N'una calle', N'987654532', N'DNI', N'98765421', N'20180820150836-alien_chibi.jpg', NULL)
INSERT [dbo].[Empleado] ([id], [nombres], [apellidos], [direccion], [celular], [tipoDocumento], [documento], [foto], [estado]) VALUES (3, N'asdasd', N'asdasd', N'asdasd', N'asdasdasd', N'DNI', N'asdasdsd', N'20180820163819-daredevil_chibi.jpg', NULL)
INSERT [dbo].[Empleado] ([id], [nombres], [apellidos], [direccion], [celular], [tipoDocumento], [documento], [foto], [estado]) VALUES (4, N'hugo 222', N'12321321', N'una calle cerca de casa', N'654321987', N'DNI', N'321654987', N'20180820225529-user.jpg', NULL)
SET IDENTITY_INSERT [dbo].[Empleado] OFF
SET IDENTITY_INSERT [dbo].[Menu] ON 

INSERT [dbo].[Menu] ([id], [fecha], [idUsuario], [fecha_registro]) VALUES (1, CAST(0x0000A92300B54640 AS DateTime), 1, NULL)
INSERT [dbo].[Menu] ([id], [fecha], [idUsuario], [fecha_registro]) VALUES (2, CAST(0x0000A92400000000 AS DateTime), 1, NULL)
INSERT [dbo].[Menu] ([id], [fecha], [idUsuario], [fecha_registro]) VALUES (3, CAST(0x0000A92500000000 AS DateTime), 1, NULL)
INSERT [dbo].[Menu] ([id], [fecha], [idUsuario], [fecha_registro]) VALUES (5, CAST(0x0000A89C00000000 AS DateTime), 1, CAST(0x0000A92901830D80 AS DateTime))
INSERT [dbo].[Menu] ([id], [fecha], [idUsuario], [fecha_registro]) VALUES (6, CAST(0x0000A92B00000000 AS DateTime), 1, CAST(0x0000A92B000A34A0 AS DateTime))
INSERT [dbo].[Menu] ([id], [fecha], [idUsuario], [fecha_registro]) VALUES (7, CAST(0x0000A93000000000 AS DateTime), 1, CAST(0x0000A930000492C0 AS DateTime))
INSERT [dbo].[Menu] ([id], [fecha], [idUsuario], [fecha_registro]) VALUES (8, CAST(0x0000A94F0000C8CD AS DateTime), 1, CAST(0x0000A94800D7338B AS DateTime))
SET IDENTITY_INSERT [dbo].[Menu] OFF
SET IDENTITY_INSERT [dbo].[MenuDetalle] ON 

INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (1, 1, N'Estafado de pollo', N'Pollo agresado con rizas papas sancochadas acompañadas de arroz y una rica ensalada', N'plato de fondo', 14.5000, 0, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (2, 1, N'Cau Cau', N'Pollo cortados en trozos sancochadas con ricas papas en cuadraditos', N'plato de fond', 10.0000, 0, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (3, 1, N'Carne asada', N'Carne asada acompañasdas de ricas papas fritas', N'plato de fondo', 15.5000, 0, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (4, 1, N'Picante de carne', N'Carne y papas en trozos consochadas con las mas tieras verduras picantes', N'plato de fondo', 12.5000, 0, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (5, 1, N'Lomo de pollo', N'Pollo en trozos acompañadas de unas ricas papas fritas', N'plato de fondo', 16.5000, 0, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (6, 1, N'Aguadito', N'Rica sopa hecha con arroz acompañada con pollo', N'Entrasa', 3.5000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (7, 1, N'Sopa de casa', N'Sopa de carne ', N'Entrada', 3.5000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (8, 1, N'Ensalada de palta', N'Rica ensalada de palta ', N'Entrada', 5.0000, 0, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (9, 1, N'Selva negra', N'Postre', N'Postre', 4.0000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (10, 1, N'Gelatina', N'Postre', N'Postre', 2.5000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (11, 2, N'Gruipo de pollo', N'Pollo sancochado con un rico aderezo acompañada de papas sancochadas', N'Plato de fondo', 15.5000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (12, 2, N'Caigua Rellena', N'Caiga rellana de aderezo de pollo en trozos', N'Plato de fondo', 12.5000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (13, 2, N'Arroz chaufa', N'Rico arroz frito acompañada con pollo en trozos', N'plato de fondo', 15.5000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (14, 2, N'Tallarines verdes', N'Tallarines verdes acompañada de huevo frito', N'Plato de fondo', 14.6000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (15, 2, N'Churrazco', N'Carne a la plancha frita con el mas delicioso aderesos', N'Plato de fondo', 15.6000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (16, 2, N'Sopa de cemola', N'Rica sopa de cemola acompañada de verduras', N'entrada', 5.2000, 1, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (17, 2, N'Sopa de crema de alverga', N'Rica sopa de crema de alverja acompañada de su rica cancha', N'Entrada', 5.4000, 0, NULL)
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (18, 2, N'Mazamorra morada', N'Rica mazamorra morada ', N'Postre', 3.5000, 1, N'20180808232010-002.png')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (20, 5, N'ssdf', N'sdfsdf', N'sdfds', 0.0000, 1, N'12.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (21, 6, N'123', N'123', N'123', 123.0000, 1, N'20180728003656-002.png')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (22, 7, N'ESTOFADO DE POLLO', N'Rico estofado de pollo compañada con ricas papas sancochadas al estilo serrado', N'Plato de fondo', 15.0200, 1, N'20180804130615-angularjs_logo.svg.png')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (23, 7, N'asdasd', N'asdasdasdwqeqwe', N'123213', 22.0000, 1, N'20180802001834-js-jquery.png')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (24, 7, N'eqwewqe', N'qwefdgdf dfgfdgd dfgdfg dgdfgre', N'345', 54.0000, 1, N'20180802001854-technologies.png')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (25, 8, N'pepian de choclo', N'El Pepián de Choclo es como la versión en puré del Tamal Verde, es un guiso muy cremoso que se sirve con  de arroz, podemos incluir carne de ave, res o chancho en la cocción o como acompañamiento.', N'Fondo', 15.5000, 1, N'20180826130330-pepian_choclo.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (26, 8, N'tallarines verdes', N'Los tallarines verdes en el Perú son uno de los tantos platos que fueron creados gracias al ingenio y creatividad de una de las comunidades extranjeras que vinieron al Perú en busca de un futuro mejor. En esta ocasión se trata de la comunidad italiana', N'Entrada', 15.0000, 1, N'20180826130528-tallarines-verdes.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (27, 8, N'lomo salatado', N'El Lomo Saltado está sin duda entre los principales y más solicitados platos de la gastronomía peruana. Ocupa un lugar especial en la interminable lista de comidas peruanas que nacen gracias a la fusión de la cocina peruana con otras cocinas del mundo.', N'Fondo', 16.5000, 1, N'20180826130626-lomo-saltado.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (28, 8, N'arroz con pollo', N'Esta deliciosa receta de Arroz con Pollo la suelen preparar muchas veces en las fiestas familiares de los hogares peruanos, me arriesgaría a decir que es un clásico de los cumpleaños. El sabor y el olor son riquísimos e inconfundibles gracias al culantro (cilantro) y a la cerveza negra.', N'Fondo', 15.5000, 1, N'20180826130709-arroz-con-pollo.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (29, 8, N'arroz con mariscos', N'El Arroz con Mariscos es un plato típico del Perú que se elabora con mariscos frescos de la costa del Pacífico y con los ingredientes autóctonos del Perú, como son el ají amarillo y el ají colorado. Si te gusta el pescado y los mariscos, aquí tienes más recetas.', N'Fondo', 16.5000, 1, N'20180826130828-arroz-con-mariscos.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (30, 8, N'carapulcra', N'La Carapulcra es un plato típico del Perú y esta considerado como uno de los más antiguos y proviene de la sierra peruana. Hace muchos años se preparaba con distintas carnes como llamas o alpacas. Hoy en día lo comemos con chancho, pollo o gallina.', N'Fondo', 15.0000, 1, N'20180826130912-carapulcra.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (31, 8, N'causa', N'Hablar de la Causa Rellena es hablar de uno de los platos más tradicionales de la cocina peruana. Cuenta la historia que este plato ya se consumía en la época precolombina. En esos tiempos era una masa preparada a base de papa amarilla mezclada con ají amarillo.', N'Entrada', 3.0000, 1, N'20180826131031-causa_limena.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (32, 8, N'papa a la huancaina', N'Fue a los 8 años de edad, que por primera vez que comí Papa a la Huancaina, desde aquel día le pedí a mamá que no deje de preparar ese plato tan sabroso. La Papa a la Huancaina es un plato típico de la costa y sierra central del Perú. Y se dice que este plato no nació en la ciudad de Huancayo, sino en la ciudad de Lima.', N'Entrada', 3.0000, 1, N'20180826131119-papa-a-la-huancaina.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (33, 8, N'papa rellena', N'La Papa Rellena es un plato típico peruano hecho con una masa de papa rellena de carne, cebolla, huevo, aceituna, especies y frito en aceite muy caliente.', N'Entrada', 3.0000, 1, N'20180826131205-papa-rellena.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (34, 8, N'sopa a la minuta', N'La Sopa a la Minuta es una sopa peruana creada por la comunidad italiana que vino al Perú en el siglo XIX. Esta sopa es muy fácil de hacer y su sabor es increíblemente delicioso. Te recomiendo que la pruebes y espero que te guste esta receta', N'Entrada', 3.0000, 1, N'20180826131248-sopa-a-la-minuta.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (35, 8, N'budin de pan', N'El Budin de Pan es un postre riquísimo, dulce y con un aroma inigualable. Sigue esta fácil receta y compruébalo tú mismo. Los ingredientes son fáciles de conseguir y su elaboración más fácil aún.', N'Postre', 2.0000, 1, N'20180826131337-budin-de-pan-estilo-peruano.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (36, 8, N'torta de maracuyá', N'Preparar una rica Torta de Maracuyá es mucho más sencillo de lo que imaginas y no será como una tarta plana, con esta receta tendrás un postre esponjoso casi como un cheesecake, ligeramente agridulce y que inundará el ambiente con su exquisito aroma.', N'Postre', 2.0000, 1, N'20180826131420-torta-de-maracuya.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (37, 8, N'milhojas', N'La preparación de Milhojas es una tarea que requiere paciencia, pues para obtener el hojaldre debemos amasar los ingredientes varias veces.  Verás que al final el resultado valdrá todo el esfuerzo y podrás disfrutar este rico postre tomando el té durante el lonche o como bocadito en alguna reunión.', N'Postre', 2.0000, 1, N'20180826131454-milhojas-con-manjar-blanco.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (38, 8, N'crema volteada', N'Aprende como preparar este rico postre peruano ideal para fiestas de cumpleaños, eventos especiales o cualquier reunión con tus amigos o familia.', N'Postre', 2.0000, 1, N'20180826131544-crema-volteada.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (39, 8, N'CASPIROLETA', N'La Caspiroleta además de ser sabrosa, es muy sencilla de preparar y económica, puedes hacerla sin licor para que puedan consumirla también los niños, y luego lo añades en las copas de los mayores. Sin más que agregar, comparto contigo la receta que me dejó mi abuelita. Espero que la disfrutes tanto como yo.', N'Bebida', 4.0000, 1, N'20180826131820-caspiroleta.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (40, 8, N'emoliente', N'Los ingredientes del emoliente suelen ser muy variados según la tradición de cada región y las propias tradiciones familiares. Sin embargo, sabemos que siempre será reconocido y se mantendrá lo principal que es la cebada y el jugo (zumo) de limón.', N'Bebida', 4.0000, 1, N'20180826131844-emoliente.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (41, 8, N'chilcano', N'El Chilcano de Pisco Clásico junto al Pisco Sour son los cocteles más aclamados en las noches de celebración peruanas. Especiales para cada ocasión y fáciles de preparar, sólo se necesitan unos pocos ingredientes y buen humor.', N'Bebida', 10.0000, 1, N'20180826131949-chilcano-de-pisco.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (42, 8, N'pisco sour', N'¡Si tienes algo que celebrar, celébralo con nuestro coctel bandera! Receta a base de Pisco Peruano y juego de limón. ¡SALUD CON PISCO SOUR!', N'Bebida', 10.0000, 1, N'20180826132027-pisco-sour-receta.jpg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (43, 8, N'Agua de toronja', N'Pique finamente los gajos de toronja y mézclelos en un bol con el agua. Deje reposar a temperatura ambiente durante una noche. Cuele. Sirva en un vaso y beba el agua de toronja a temperatura ambiente en la mañana, antes del desayuno. ', N'Bebida', 4.0000, 1, N'20180826155414-agua de toronja.jpeg')
INSERT [dbo].[MenuDetalle] ([id], [idMenu], [titulo], [descripcion], [tipo], [precio], [estado], [foto]) VALUES (44, 8, N'melocotón', N'Ponga todos los ingredientes en una olla, tape y lleve a fuego alto hasta que hierva. Reduzca a fuego bajo y deje cocinar durante una hora, hasta que los melocotones estén suaves. Retire del fuego, cuele y mantenga en el refrigerador hasta que aliste la lonchera.', N'Bebida', 4.0000, 1, N'20180826155509-agua_de_melocoton.jpeg')
SET IDENTITY_INSERT [dbo].[MenuDetalle] OFF
SET IDENTITY_INSERT [dbo].[Pedido] ON 

INSERT [dbo].[Pedido] ([id], [fecha], [total], [nombres], [mesa], [tipoPago], [idEmpleado], [idUsuario], [estado]) VALUES (2, CAST(0x0000A94F016EBDBA AS DateTime), 36.0000, NULL, 1, N'EFECTIVO', 1, 1, 2)
INSERT [dbo].[Pedido] ([id], [fecha], [total], [nombres], [mesa], [tipoPago], [idEmpleado], [idUsuario], [estado]) VALUES (3, CAST(0x0000A94F016EBDBA AS DateTime), 66.0000, N'', 1, N'', 1, 1, 1)
INSERT [dbo].[Pedido] ([id], [fecha], [total], [nombres], [mesa], [tipoPago], [idEmpleado], [idUsuario], [estado]) VALUES (4, CAST(0x0000A94F016EBDBA AS DateTime), 50.0000, N'test', 10, N'EFECTIVO', 1, 1, 2)
INSERT [dbo].[Pedido] ([id], [fecha], [total], [nombres], [mesa], [tipoPago], [idEmpleado], [idUsuario], [estado]) VALUES (5, CAST(0x0000A94F016EBDBA AS DateTime), 50.0000, N'', 17, N'', 1, 1, 1)
INSERT [dbo].[Pedido] ([id], [fecha], [total], [nombres], [mesa], [tipoPago], [idEmpleado], [idUsuario], [estado]) VALUES (6, CAST(0x0000A94F016EBDBA AS DateTime), 14.0000, N'', 11, N'', 1, 1, 1)
INSERT [dbo].[Pedido] ([id], [fecha], [total], [nombres], [mesa], [tipoPago], [idEmpleado], [idUsuario], [estado]) VALUES (7, CAST(0x0000A94F016EBDBA AS DateTime), 111.0000, N'HUGO ROCA ESPINOZA', 20, N'VISA', 1, 1, 2)
SET IDENTITY_INSERT [dbo].[Pedido] OFF
SET IDENTITY_INSERT [dbo].[PedidoDetalle] ON 

INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (1, 2, 31, 2, 3.0000, 6.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (2, 2, 32, 2, 3.0000, 6.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (3, 2, 35, 2, 2.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (4, 2, 38, 2, 2.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (5, 2, 43, 2, 4.0000, 8.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (6, 2, 39, 2, 4.0000, 8.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (7, 3, 29, 1, 16.5000, 16.5000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (8, 3, 28, 1, 15.5000, 15.5000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (9, 3, 33, 1, 3.0000, 3.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (10, 3, 26, 1, 15.0000, 15.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (11, 3, 38, 1, 2.0000, 2.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (12, 3, 44, 1, 4.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (13, 3, 41, 1, 10.0000, 10.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (14, 4, 29, 1, 16.5000, 16.5000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (15, 4, 28, 1, 15.5000, 15.5000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (16, 4, 33, 1, 3.0000, 3.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (17, 4, 34, 1, 3.0000, 3.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (18, 4, 35, 2, 2.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (19, 4, 39, 2, 4.0000, 8.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (20, 5, 29, 1, 16.5000, 16.5000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (21, 5, 28, 1, 15.5000, 15.5000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (22, 5, 33, 1, 3.0000, 3.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (23, 5, 34, 1, 3.0000, 3.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (24, 5, 35, 2, 2.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (25, 5, 39, 2, 4.0000, 8.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (26, 6, 41, 1, 10.0000, 10.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (27, 6, 40, 1, 4.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (28, 7, 29, 2, 16.5000, 33.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (29, 7, 28, 2, 15.5000, 31.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (30, 7, 34, 1, 3.0000, 3.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (31, 7, 33, 1, 3.0000, 3.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (32, 7, 26, 1, 15.0000, 15.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (33, 7, 35, 1, 2.0000, 2.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (34, 7, 38, 1, 2.0000, 2.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (35, 7, 43, 1, 4.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (36, 7, 39, 1, 4.0000, 4.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (37, 7, 41, 1, 10.0000, 10.0000)
INSERT [dbo].[PedidoDetalle] ([id], [idPedido], [idMenu], [cantidad], [precio], [subtotal]) VALUES (38, 7, 40, 1, 4.0000, 4.0000)
SET IDENTITY_INSERT [dbo].[PedidoDetalle] OFF
SET IDENTITY_INSERT [dbo].[Permiso] ON 

INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (1, N'Inicio', 1, 0, N'/Admin/Inicio/Index', N'menu-icon fa fa-tachometer', N'Inicio', 0)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (2, N'Menu', 1, 0, N'', N'menu-icon fa fa-pencil-square-o', N'', 0)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (3, N'Registro de menú', 1, 2, N'/Admin/Menu/Index', N'', N'Menu', 0)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (4, N'Acceso', 1, 0, N'', N'menu-icon fa fa-users', N'', 0)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (5, N'Registro de empleado', 1, 4, N'/Admin/Empleado/Index', N'', N'Empleado', 0)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (6, N'Registro de usuario', 1, 4, N'/Admin/Usuario/Index', N'', N'Usuario', 0)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (7, N'Caja', 1, 0, N'', N'menu-icon fa fa-folder-open-o', N'', 0)
INSERT [dbo].[Permiso] ([id], [descripcion], [estado], [padre], [url], [icono], [controlador], [active]) VALUES (8, N'Cobro de consumo', 1, 7, N'/Admin/Cobranza/Index', N'', N'Cobranza', 0)
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
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (7, 1, 7)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (8, 1, 8)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (9, 2, 7)
INSERT [dbo].[RolPermiso] ([id], [idRol], [idPermiso]) VALUES (10, 2, 8)
SET IDENTITY_INSERT [dbo].[RolPermiso] OFF
SET IDENTITY_INSERT [dbo].[RolUsuario] ON 

INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (1, 1, 1, 1)
INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (2, 2, 2, 1)
INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (3, 3, 2, 1)
INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (5, 5, 1, 1)
INSERT [dbo].[RolUsuario] ([id], [idUsuario], [idRol], [estado]) VALUES (6, 6, 2, 1)
SET IDENTITY_INSERT [dbo].[RolUsuario] OFF
SET IDENTITY_INSERT [dbo].[Usuario] ON 

INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado], [idEmpleado]) VALUES (1, N'hugo.roca', N'0E9DE27D147FD4C75AF0D891DF0D9C6AAC7D1F24', 1, 1)
INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado], [idEmpleado]) VALUES (2, N'jehidi.chavez', N'B11DE28C967D26AA47DA5326E7B092FA9B73FD2C', 1, NULL)
INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado], [idEmpleado]) VALUES (3, N'test.test', N'B11DE28C967D26AA47DA5326E7B092FA9B73FD2C', 1, 2)
INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado], [idEmpleado]) VALUES (5, N'1234567', N'B11DE28C967D26AA47DA5326E7B092FA9B73FD2C', 1, 3)
INSERT [dbo].[Usuario] ([id], [usuario], [clave], [estado], [idEmpleado]) VALUES (6, N'hugo.23', N'8E87C8EF8A73A9015AFBBC08272B2C4E1402A98D', 1, 4)
SET IDENTITY_INSERT [dbo].[Usuario] OFF
ALTER TABLE [dbo].[Menu]  WITH CHECK ADD FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuario] ([id])
GO
ALTER TABLE [dbo].[MenuDetalle]  WITH CHECK ADD FOREIGN KEY([idMenu])
REFERENCES [dbo].[Menu] ([id])
GO
ALTER TABLE [dbo].[Pedido]  WITH CHECK ADD FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[Pedido]  WITH CHECK ADD FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuario] ([id])
GO
ALTER TABLE [dbo].[PedidoDetalle]  WITH CHECK ADD FOREIGN KEY([idMenu])
REFERENCES [dbo].[MenuDetalle] ([id])
GO
ALTER TABLE [dbo].[PedidoDetalle]  WITH CHECK ADD FOREIGN KEY([idPedido])
REFERENCES [dbo].[Pedido] ([id])
GO
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
