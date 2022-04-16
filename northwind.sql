IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FK_orders_customers]') AND type in (N'U'))
ALTER TABLE [dbo].[orders] DROP CONSTRAINT [FK_orders_customers]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[order_details]') AND type in (N'U'))
ALTER TABLE [dbo].[order_details] DROP CONSTRAINT [FK_order_details_orders]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND type in (N'U'))
DROP TABLE [dbo].[orders]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[order_details]') AND type in (N'U'))
DROP TABLE [dbo].[order_details]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
DROP TABLE [dbo].[customers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customers](
	[customer_id] [char](5) NOT NULL,
	[company_name] [varchar](50) NOT NULL,
	[contact_name] [varchar](50) NOT NULL,
	[contact_title] [varchar](50) NOT NULL,
 CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_details]    Script Date: 4/16/2022 5:34:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_details](
	[order_details_id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[unit_price] [decimal](18, 2) NOT NULL,
	[quantity] [int] NOT NULL,
	[discount] [decimal](18, 6) NOT NULL,
 CONSTRAINT [PK_order_details] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 4/16/2022 5:34:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [char](5) NOT NULL,
	[order_date] [datetime] NOT NULL,
	[ship_name] [nvarchar](50) NOT NULL,
	[ship_address] [nvarchar](50) NOT NULL,
	[ship_city] [nvarchar](50) NOT NULL,
	[ship_region] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[customers] ([customer_id], [company_name], [contact_name], [contact_title]) VALUES (N'ANTON', N'Antonio Moreno Taquería', N'Antonio Moreno', N'Owner')
GO
INSERT [dbo].[customers] ([customer_id], [company_name], [contact_name], [contact_title]) VALUES (N'QUEDE', N'Que Delícia', N'Bernardo Batista', N'Accounting Manager')
GO
INSERT [dbo].[customers] ([customer_id], [company_name], [contact_name], [contact_title]) VALUES (N'WILMK', N'Wilman Kala', N'Matti Karttunen', N'Owner/Marketing Assistant')
GO
SET IDENTITY_INSERT [dbo].[order_details] ON 
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (2, 10261, 21, CAST(8.00 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (1, 10261, 35, CAST(14.40 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (5, 10291, 13, CAST(4.80 AS Decimal(18, 2)), 20, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (4, 10291, 44, CAST(15.50 AS Decimal(18, 2)), 24, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (3, 10291, 51, CAST(42.40 AS Decimal(18, 2)), 2, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (6, 10365, 11, CAST(16.80 AS Decimal(18, 2)), 24, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (9, 10379, 41, CAST(7.70 AS Decimal(18, 2)), 8, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (8, 10379, 63, CAST(35.10 AS Decimal(18, 2)), 16, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (7, 10379, 65, CAST(16.80 AS Decimal(18, 2)), 20, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (13, 10421, 19, CAST(7.30 AS Decimal(18, 2)), 4, CAST(0.150000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (12, 10421, 26, CAST(24.90 AS Decimal(18, 2)), 30, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (11, 10421, 53, CAST(26.20 AS Decimal(18, 2)), 15, CAST(0.150000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (10, 10421, 77, CAST(10.40 AS Decimal(18, 2)), 10, CAST(0.150000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (15, 10507, 43, CAST(46.00 AS Decimal(18, 2)), 15, CAST(0.150000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (14, 10507, 48, CAST(12.75 AS Decimal(18, 2)), 15, CAST(0.150000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (19, 10535, 11, CAST(21.00 AS Decimal(18, 2)), 50, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (18, 10535, 40, CAST(18.40 AS Decimal(18, 2)), 10, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (17, 10535, 57, CAST(19.50 AS Decimal(18, 2)), 5, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (16, 10535, 59, CAST(55.00 AS Decimal(18, 2)), 15, CAST(0.100000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (22, 10573, 17, CAST(39.00 AS Decimal(18, 2)), 18, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (21, 10573, 34, CAST(14.00 AS Decimal(18, 2)), 40, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (20, 10573, 53, CAST(32.80 AS Decimal(18, 2)), 25, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (25, 10587, 26, CAST(31.23 AS Decimal(18, 2)), 6, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (24, 10587, 35, CAST(18.00 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (23, 10587, 77, CAST(13.00 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (26, 10615, 55, CAST(24.00 AS Decimal(18, 2)), 5, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (28, 10647, 19, CAST(9.20 AS Decimal(18, 2)), 30, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (27, 10647, 39, CAST(18.00 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (31, 10673, 16, CAST(17.45 AS Decimal(18, 2)), 3, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (30, 10673, 42, CAST(14.00 AS Decimal(18, 2)), 6, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (29, 10673, 43, CAST(46.00 AS Decimal(18, 2)), 6, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (33, 10677, 26, CAST(31.23 AS Decimal(18, 2)), 30, CAST(0.150000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (32, 10677, 33, CAST(2.50 AS Decimal(18, 2)), 8, CAST(0.150000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (36, 10682, 33, CAST(2.50 AS Decimal(18, 2)), 30, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (35, 10682, 66, CAST(17.00 AS Decimal(18, 2)), 4, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (34, 10682, 75, CAST(7.75 AS Decimal(18, 2)), 30, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (39, 10695, 8, CAST(40.00 AS Decimal(18, 2)), 10, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (38, 10695, 12, CAST(38.00 AS Decimal(18, 2)), 4, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (37, 10695, 24, CAST(4.50 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (41, 10720, 35, CAST(18.00 AS Decimal(18, 2)), 21, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (40, 10720, 71, CAST(21.50 AS Decimal(18, 2)), 8, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (43, 10794, 14, CAST(23.25 AS Decimal(18, 2)), 15, CAST(0.200000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (42, 10794, 54, CAST(7.45 AS Decimal(18, 2)), 6, CAST(0.200000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (45, 10856, 2, CAST(19.00 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (44, 10856, 42, CAST(14.00 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (47, 10873, 21, CAST(8.00 AS Decimal(18, 2)), 20, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (46, 10873, 28, CAST(45.60 AS Decimal(18, 2)), 3, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (50, 10879, 40, CAST(18.40 AS Decimal(18, 2)), 12, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (49, 10879, 65, CAST(21.05 AS Decimal(18, 2)), 10, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (48, 10879, 76, CAST(18.00 AS Decimal(18, 2)), 10, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (53, 10910, 19, CAST(9.20 AS Decimal(18, 2)), 12, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (52, 10910, 49, CAST(20.00 AS Decimal(18, 2)), 10, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (51, 10910, 61, CAST(28.50 AS Decimal(18, 2)), 5, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (56, 10989, 6, CAST(25.00 AS Decimal(18, 2)), 40, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (55, 10989, 11, CAST(21.00 AS Decimal(18, 2)), 15, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (54, 10989, 41, CAST(9.65 AS Decimal(18, 2)), 4, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (58, 11005, 1, CAST(18.00 AS Decimal(18, 2)), 2, CAST(0.000000 AS Decimal(18, 6)))
GO
INSERT [dbo].[order_details] ([order_details_id], [order_id], [product_id], [unit_price], [quantity], [discount]) VALUES (57, 11005, 59, CAST(55.00 AS Decimal(18, 2)), 10, CAST(0.000000 AS Decimal(18, 6)))
GO
SET IDENTITY_INSERT [dbo].[order_details] OFF
GO
SET IDENTITY_INSERT [dbo].[orders] ON 
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10261, N'QUEDE', CAST(N'1996-07-19T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10291, N'QUEDE', CAST(N'1996-08-27T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10365, N'ANTON', CAST(N'1996-11-27T00:00:00.000' AS DateTime), N'Antonio Moreno Taquería', N'Mataderos  2312', N'México D.F.', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10379, N'QUEDE', CAST(N'1996-12-11T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10421, N'QUEDE', CAST(N'1997-01-21T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10507, N'ANTON', CAST(N'1997-04-15T00:00:00.000' AS DateTime), N'Antonio Moreno Taquería', N'Mataderos  2312', N'México D.F.', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10535, N'ANTON', CAST(N'1997-05-13T00:00:00.000' AS DateTime), N'Antonio Moreno Taquería', N'Mataderos  2312', N'México D.F.', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10573, N'ANTON', CAST(N'1997-06-19T00:00:00.000' AS DateTime), N'Antonio Moreno Taquería', N'Mataderos  2312', N'México D.F.', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10587, N'QUEDE', CAST(N'1997-07-02T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10615, N'WILMK', CAST(N'1997-07-30T00:00:00.000' AS DateTime), N'Wilman Kala', N'Keskuskatu 45', N'Helsinki', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10647, N'QUEDE', CAST(N'1997-08-27T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10673, N'WILMK', CAST(N'1997-09-18T00:00:00.000' AS DateTime), N'Wilman Kala', N'Keskuskatu 45', N'Helsinki', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10677, N'ANTON', CAST(N'1997-09-22T00:00:00.000' AS DateTime), N'Antonio Moreno Taquería', N'Mataderos  2312', N'México D.F.', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10682, N'ANTON', CAST(N'1997-09-25T00:00:00.000' AS DateTime), N'Antonio Moreno Taquería', N'Mataderos  2312', N'México D.F.', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10695, N'WILMK', CAST(N'1997-10-07T00:00:00.000' AS DateTime), N'Wilman Kala', N'Keskuskatu 45', N'Helsinki', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10720, N'QUEDE', CAST(N'1997-10-28T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10794, N'QUEDE', CAST(N'1997-12-24T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10856, N'ANTON', CAST(N'1998-01-28T00:00:00.000' AS DateTime), N'Antonio Moreno Taquería', N'Mataderos  2312', N'México D.F.', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10873, N'WILMK', CAST(N'1998-02-06T00:00:00.000' AS DateTime), N'Wilman Kala', N'Keskuskatu 45', N'Helsinki', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10879, N'WILMK', CAST(N'1998-02-10T00:00:00.000' AS DateTime), N'Wilman Kala', N'Keskuskatu 45', N'Helsinki', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10910, N'WILMK', CAST(N'1998-02-26T00:00:00.000' AS DateTime), N'Wilman Kala', N'Keskuskatu 45', N'Helsinki', N'NULL')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (10989, N'QUEDE', CAST(N'1998-03-31T00:00:00.000' AS DateTime), N'Que Delícia', N'Rua da Panificadora 12', N'Rio de Janeiro', N'RJ')
GO
INSERT [dbo].[orders] ([order_id], [customer_id], [order_date], [ship_name], [ship_address], [ship_city], [ship_region]) VALUES (11005, N'WILMK', CAST(N'1998-04-07T00:00:00.000' AS DateTime), N'Wilman Kala', N'Keskuskatu 45', N'Helsinki', N'NULL')
GO
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
ALTER TABLE [dbo].[order_details]  WITH CHECK ADD  CONSTRAINT [FK_order_details_orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([order_id])
GO
ALTER TABLE [dbo].[order_details] CHECK CONSTRAINT [FK_order_details_orders]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_customers] FOREIGN KEY([customer_id])
REFERENCES [dbo].[customers] ([customer_id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_customers]
GO
