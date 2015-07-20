USE [Advent]
GO

IF OBJECT_ID(N'Binder', N'U') IS NOT NULL DROP TABLE [Binder]
IF OBJECT_ID(N'CompanyUserRole', N'U') IS NOT NULL DROP TABLE [CompanyUserRole]
IF OBJECT_ID(N'UserRoleEnum', N'U') IS NOT NULL DROP TABLE [UserRoleEnum]
IF OBJECT_ID(N'CompanyType', N'U') IS NOT NULL DROP TABLE [CompanyType]
IF OBJECT_ID(N'CompanyTypeEnum', N'U') IS NOT NULL DROP TABLE [CompanyTypeEnum]
IF OBJECT_ID(N'Company', N'U') IS NOT NULL DROP TABLE [Company]
IF OBJECT_ID(N'TerritoryCountry', N'U') IS NOT NULL DROP TABLE [TerritoryCountry]
IF OBJECT_ID(N'Territory', N'U') IS NOT NULL DROP TABLE [Territory]
IF OBJECT_ID(N'Country', N'U') IS NOT NULL DROP TABLE [Country]
IF OBJECT_ID(N'SuperUser', N'U') IS NOT NULL DROP TABLE [SuperUser]
GO

CREATE TABLE [SuperUser] (
  [UserId] INT NOT NULL,
		CONSTRAINT [PK_SuperUser] PRIMARY KEY CLUSTERED ([UserId]),
		CONSTRAINT [FK_SuperUser_User] FOREIGN KEY ([UserId]) REFERENCES [User] ([Id])
 )
GO

CREATE TABLE [Country] (
  [Id] NCHAR(2) NOT NULL,
		[Name] NVARCHAR(255) NOT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_Country_Active] DEFAULT (1),
		CONSTRAINT [PK_Country] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_Country_Name] UNIQUE CLUSTERED ([Name])
	)
GO

CREATE TABLE [Territory] (
  [Id] INT NOT NULL IDENTITY (1, 1),
		[Name] NVARCHAR(255) NOT NULL,
		[Type] BIT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_Territory_Active] DEFAULT (1),
		CONSTRAINT [PK_Territory] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_Territory_Name] UNIQUE CLUSTERED ([Name]),
		CONSTRAINT [UQ_Territory_Type] UNIQUE ([Id], [Type]),
		CONSTRAINT [CK_Territory_Id] CHECK ([Id] >= 0)
	)
GO

CREATE TABLE [TerritoryCountry] (
  [TerritoryId] INT NOT NULL,
		[CountryId] NCHAR(2) NOT NULL,
		[Type] BIT NOT NULL,
		CONSTRAINT [PK_TerritoryCountry] PRIMARY KEY CLUSTERED ([TerritoryId], [CountryId]),
		CONSTRAINT [FK_TerritoryCountry_Territory] FOREIGN KEY ([TerritoryId], [Type]) REFERENCES [Territory] ([Id], [Type]),
		CONSTRAINT [FK_TerritoryCountry_Country] FOREIGN KEY ([CountryId]) REFERENCES [Country] ([Id])
	)
GO

CREATE TABLE [Company] (
  [Id] INT NOT NULL IDENTITY (1, 1),
		[Name] NVARCHAR(255) NOT NULL,
		[Address] NVARCHAR(255) NULL,
		[Postcode] NVARCHAR(25) NULL,
		[CountryId] NCHAR(2) NOT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_Company_Active] DEFAULT (1),
		CONSTRAINT [PK_Company] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_Company_Name] UNIQUE CLUSTERED ([Name], [CountryId]),
		CONSTRAINT [FK_Company_Country] FOREIGN KEY ([CountryId]) REFERENCES [Country] ([Id]),
	 CONSTRAINT [CK_Company_Id] CHECK ([Id] > 0)
	)
GO

CREATE TABLE [CompanyTypeEnum] (
  [Id] TINYINT NOT NULL IDENTITY (1, 1),
		[Description] NVARCHAR(25) NOT NULL,
		[Sort] TINYINT NOT NULL,
		CONSTRAINT [PK_CompanyTypeEnum] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_CompanyTypeEnum_Description] UNIQUE ([Description]),
		CONSTRAINT [UQ_CompanyTypeEnum_Sort] UNIQUE CLUSTERED ([Sort])
	)
GO

INSERT INTO [CompanyTypeEnum] ([Description], [Sort])
VALUES
 (N'TPA', 1),
	(N'Coverholder', 2),
	(N'Lloyd''s Broker', 3),
	(N'Carrier', 4),
	(N'Retail Broker / Agent', 5),
	(N'Expert', 255)
GO

CREATE TABLE [UserRoleEnum] (
  [Id] TINYINT NOT NULL IDENTITY (1, 1),
		[Description] NVARCHAR(25) NOT NULL,
		[Sort] TINYINT NOT NULL,
		CONSTRAINT [PK_UserRoleEnum] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_UserRoleEnum_Description] UNIQUE ([Description]),
		CONSTRAINT [UQ_UserRoleEnum_Sort] UNIQUE CLUSTERED ([Sort])
	)
GO

CREATE TABLE [CompanyUserRole] (
		[CompanyId] INT NOT NULL,
  [UserId] INT NOT NULL,
		[RoleId] TINYINT NOT NULL,
		CONSTRAINT [PK_CompanyUserRole] PRIMARY KEY CLUSTERED ([UserId], [CompanyId], [RoleId]),
		CONSTRAINT [FK_CompanyUserRole_Company] FOREIGN KEY ([CompanyId]) REFERENCES [Company] ([Id]),
		CONSTRAINT [FK_CompanyUserRole_User] FOREIGN KEY ([UserId]) REFERENCES [User] ([Id]),
		CONSTRAINT [FK_CompanyUserRole_UserRoleEnum] FOREIGN KEY ([RoleId]) REFERENCES [UserRoleEnum] ([Id])
	)
GO

CREATE TABLE [Binder] (
  [Id] INT NOT NULL,
		[UMR] NVARCHAR(50) NOT NULL,
		[Reference] NVARCHAR(50) NULL,
		[CoverholderId] INT NOT NULL,
		[BrokerId] INT NOT NULL,
		[InceptionDate] DATE NOT NULL,
		[ExpiryDate] DATE NOT NULL,
		[RisksTerritoryId] INT NOT NULL CONSTRAINT [DF_Binder_RisksTerritoryId] DEFAULT (0),
		[InsuredsTerritoryId] INT NOT NULL CONSTRAINT [DF_Binder_InsuredsTerritoryId] DEFAULT (0),
		[LimitsTerritoryId] INT NOT NULL CONSTRAINT [DF_Binder_LimitsTerritoryId] DEFAULT (0),
		CONSTRAINT [PK_Binder] PRIMARY KEY CLUSTERED ([Id]),
		CONSTRAINT [UQ_Binder_UMR] UNIQUE ([UMR]),
		CONSTRAINT [FK_Binder_Company_CoverholderId] FOREIGN KEY ([CoverholderId]) REFERENCES [Company] ([Id]),
		CONSTRAINT [FK_Binder_Company_BrokerId] FOREIGN KEY ([BrokerId]) REFERENCES [Company] ([Id]),
		CONSTRAINT [FK_Binder_Territory_RisksTerritoryId] FOREIGN KEY ([RisksTerritoryId]) REFERENCES [Territory] ([Id]),
		CONSTRAINT [FK_Binder_Territory_InsuredsTerritoryId] FOREIGN KEY ([InsuredsTerritoryId]) REFERENCES [Territory] ([Id]),
		CONSTRAINT [FK_Binder_Territory_LimitsTerritoryId] FOREIGN KEY ([LimitsTerritoryId]) REFERENCES [Territory] ([Id]),
		CONSTRAINT [CK_Binder_ExpiryDate] CHECK ([ExpiryDate] >= [InceptionDate])
 )
GO

DECLARE @name SYSNAME, @SQL NVARCHAR(max)
DECLARE MyCursor CURSOR FOR SELECT [name] FROM sys.tables WHERE [name] IN (N'Territory', N'Company', N'Binder')
OPEN MyCursor
FETCH NEXT FROM MyCursor INTO @name
WHILE @@FETCH_STATUS = 0 BEGIN
 SET @SQL = N'ALTER TABLE ' + QUOTENAME(@name, N'[') + N' ADD' +
	 N' [CreatedDTO] DATETIMEOFFSET NOT NULL,' +
		N' [CreatedById] INT NOT NULL,' +
		N' [UpdatedDTO] DATETIMEOFFSET NOT NULL,' +
		N' [UpdatedById] INT NOT NULL,' +
		N' CONSTRAINT [FK_' + @name + N'_User_CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [User] ([Id]),' +
		N' CONSTRAINT [FK_' + @name + N'_User_UpdatedById] FOREIGN KEY ([UpdatedById]) REFERENCES [User] ([Id]),' +
		N' CONSTRAINT [CK_' + @name + N'_UpdatedDTO] CHECK ([UpdatedDTO] >= [CreatedDTO])'
	EXEC (@SQL)
	FETCH NEXT FROM MyCursor INTO @name
END
CLOSE MyCursor
DEALLOCATE MyCursor
GO
