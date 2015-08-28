USE [Advent]
GO

SET NOCOUNT ON
GO

IF OBJECT_ID(N'BinderSection', N'U') IS NOT NULL DROP TABLE [BinderSection]
IF OBJECT_ID(N'Binder', N'U') IS NOT NULL DROP TABLE [Binder]
IF OBJECT_ID(N'LossFund', N'U') IS NOT NULL DROP TABLE [LossFund]
IF OBJECT_ID(N'CompanyUserRole', N'U') IS NOT NULL DROP TABLE [CompanyUserRole]
IF OBJECT_ID(N'UserRoleEnum', N'U') IS NOT NULL DROP TABLE [UserRoleEnum]
IF OBJECT_ID(N'CompanyType', N'U') IS NOT NULL DROP TABLE [CompanyType]
IF OBJECT_ID(N'CompanyTypeEnum', N'U') IS NOT NULL DROP TABLE [CompanyTypeEnum]
IF OBJECT_ID(N'Company', N'U') IS NOT NULL DROP TABLE [Company]
IF OBJECT_ID(N'ClassOfBusinessPeril', N'U') IS NOT NULL DROP TABLE [ClassOfBusinessPeril]
IF OBJECT_ID(N'Peril', N'U') IS NOT NULL DROP TABLE [Peril]
IF OBJECT_ID(N'PerilHierarchy', N'U') IS NOT NULL DROP TABLE [PerilHierarchy]
IF OBJECT_ID(N'CodeScheme', N'U') IS NOT NULL DROP TABLE [CodeScheme]
IF OBJECT_ID(N'ClassOfBusiness', N'U') IS NOT NULL DROP TABLE [ClassOfBusiness]
IF OBJECT_ID(N'TerritoryCountry', N'U') IS NOT NULL DROP TABLE [TerritoryCountry]
IF OBJECT_ID(N'Territory', N'U') IS NOT NULL DROP TABLE [Territory]
IF OBJECT_ID(N'Country', N'U') IS NOT NULL DROP TABLE [Country]
IF OBJECT_ID(N'Currency', N'U') IS NOT NULL DROP TABLE [Currency]
IF OBJECT_ID(N'SuperUser', N'U') IS NOT NULL DROP TABLE [SuperUser]
GO

CREATE TABLE [SuperUser] (
  [UserId] INT NOT NULL,
		CONSTRAINT [PK_SuperUser] PRIMARY KEY CLUSTERED ([UserId]),
		CONSTRAINT [FK_SuperUser_User] FOREIGN KEY ([UserId]) REFERENCES [User] ([Id])
 )
GO

CREATE TABLE [Currency] (
  [Id] NCHAR(3) NOT NULL,
		[Name] NVARCHAR(255) NOT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_Currency_Active] DEFAULT (1),
		CONSTRAINT [PK_Currency] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_Currency_Name] UNIQUE CLUSTERED ([Name])
	)
GO

INSERT INTO [Currency] ([Id], [Name])
VALUES
	(N'AED', N'United Arab Emirates Dirham'),
	(N'AFN', N'Afghanistan Afghani'),
	(N'ALL', N'Albania Lek'),
	(N'AMD', N'Armenia Dram'),
	(N'ANG', N'Netherlands Antilles Guilder'),
	(N'AOA', N'Angola Kwanza'),
	(N'ARS', N'Argentina Peso'),
	(N'AUD', N'Australia Dollar'),
	(N'AWG', N'Aruba Guilder'),
	(N'AZN', N'Azerbaijan New Manat'),
	(N'BAM', N'Bosnia and Herzegovina Convertible Marka'),
	(N'BBD', N'Barbados Dollar'),
	(N'BDT', N'Bangladesh Taka'),
	(N'BGN', N'Bulgaria Lev'),
	(N'BHD', N'Bahrain Dinar'),
	(N'BIF', N'Burundi Franc'),
	(N'BMD', N'Bermuda Dollar'),
	(N'BND', N'Brunei Darussalam Dollar'),
	(N'BOB', N'Bolivia Boliviano'),
	(N'BRL', N'Brazil Real'),
	(N'BSD', N'Bahamas Dollar'),
	(N'BTN', N'Bhutan Ngultrum'),
	(N'BWP', N'Botswana Pula'),
	(N'BYR', N'Belarus Ruble'),
	(N'BZD', N'Belize Dollar'),
	(N'CAD', N'Canada Dollar'),
	(N'CDF', N'Congo/Kinshasa Franc'),
	(N'CHF', N'Switzerland Franc'),
	(N'CLP', N'Chile Peso'),
	(N'CNY', N'China Yuan Renminbi'),
	(N'COP', N'Colombia Peso'),
	(N'CRC', N'Costa Rica Colon'),
	(N'CUC', N'Cuba Convertible Peso'),
	(N'CUP', N'Cuba Peso'),
	(N'CVE', N'Cape Verde Escudo'),
	(N'CZK', N'Czech Republic Koruna'),
	(N'DJF', N'Djibouti Franc'),
	(N'DKK', N'Denmark Krone'),
	(N'DOP', N'Dominican Republic Peso'),
	(N'DZD', N'Algeria Dinar'),
	(N'EGP', N'Egypt Pound'),
	(N'ERN', N'Eritrea Nakfa'),
	(N'ETB', N'Ethiopia Birr'),
	(N'EUR', N'Euro Member Countries'),
	(N'FJD', N'Fiji Dollar'),
	(N'FKP', N'Falkland Islands (Malvinas) Pound'),
	(N'GBP', N'United Kingdom Pound'),
	(N'GEL', N'Georgia Lari'),
	(N'GGP', N'Guernsey Pound'),
	(N'GHS', N'Ghana Cedi'),
	(N'GIP', N'Gibraltar Pound'),
	(N'GMD', N'Gambia Dalasi'),
	(N'GNF', N'Guinea Franc'),
	(N'GTQ', N'Guatemala Quetzal'),
	(N'GYD', N'Guyana Dollar'),
	(N'HKD', N'Hong Kong Dollar'),
	(N'HNL', N'Honduras Lempira'),
	(N'HRK', N'Croatia Kuna'),
	(N'HTG', N'Haiti Gourde'),
	(N'HUF', N'Hungary Forint'),
	(N'IDR', N'Indonesia Rupiah'),
	(N'ILS', N'Israel Shekel'),
	(N'IMP', N'Isle of Man Pound'),
	(N'INR', N'India Rupee'),
	(N'IQD', N'Iraq Dinar'),
	(N'IRR', N'Iran Rial'),
	(N'ISK', N'Iceland Krona'),
	(N'JEP', N'Jersey Pound'),
	(N'JMD', N'Jamaica Dollar'),
	(N'JOD', N'Jordan Dinar'),
	(N'JPY', N'Japan Yen'),
	(N'KES', N'Kenya Shilling'),
	(N'KGS', N'Kyrgyzstan Som'),
	(N'KHR', N'Cambodia Riel'),
	(N'KMF', N'Comoros Franc'),
	(N'KPW', N'Korea (North) Won'),
	(N'KRW', N'Korea (South) Won'),
	(N'KWD', N'Kuwait Dinar'),
	(N'KYD', N'Cayman Islands Dollar'),
	(N'KZT', N'Kazakhstan Tenge'),
	(N'LAK', N'Laos Kip'),
	(N'LBP', N'Lebanon Pound'),
	(N'LKR', N'Sri Lanka Rupee'),
	(N'LRD', N'Liberia Dollar'),
	(N'LSL', N'Lesotho Loti'),
	(N'LYD', N'Libya Dinar'),
	(N'MAD', N'Morocco Dirham'),
	(N'MDL', N'Moldova Leu'),
	(N'MGA', N'Madagascar Ariary'),
	(N'MKD', N'Macedonia Denar'),
	(N'MMK', N'Myanmar (Burma) Kyat'),
	(N'MNT', N'Mongolia Tughrik'),
	(N'MOP', N'Macau Pataca'),
	(N'MRO', N'Mauritania Ouguiya'),
	(N'MUR', N'Mauritius Rupee'),
	(N'MVR', N'Maldives (Maldive Islands) Rufiyaa'),
	(N'MWK', N'Malawi Kwacha'),
	(N'MXN', N'Mexico Peso'),
	(N'MYR', N'Malaysia Ringgit'),
	(N'MZN', N'Mozambique Metical'),
	(N'NAD', N'Namibia Dollar'),
	(N'NGN', N'Nigeria Naira'),
	(N'NIO', N'Nicaragua Cordoba'),
	(N'NOK', N'Norway Krone'),
	(N'NPR', N'Nepal Rupee'),
	(N'NZD', N'New Zealand Dollar'),
	(N'OMR', N'Oman Rial'),
	(N'PAB', N'Panama Balboa'),
	(N'PEN', N'Peru Nuevo Sol'),
	(N'PGK', N'Papua New Guinea Kina'),
	(N'PHP', N'Philippines Peso'),
	(N'PKR', N'Pakistan Rupee'),
	(N'PLN', N'Poland Zloty'),
	(N'PYG', N'Paraguay Guarani'),
	(N'QAR', N'Qatar Riyal'),
	(N'RON', N'Romania New Leu'),
	(N'RSD', N'Serbia Dinar'),
	(N'RUB', N'Russia Ruble'),
	(N'RWF', N'Rwanda Franc'),
	(N'SAR', N'Saudi Arabia Riyal'),
	(N'SBD', N'Solomon Islands Dollar'),
	(N'SCR', N'Seychelles Rupee'),
	(N'SDG', N'Sudan Pound'),
	(N'SEK', N'Sweden Krona'),
	(N'SGD', N'Singapore Dollar'),
	(N'SHP', N'Saint Helena Pound'),
	(N'SLL', N'Sierra Leone Leone'),
	(N'SOS', N'Somalia Shilling'),
	(N'SPL', N'Seborga Luigino'),
	(N'SRD', N'Suriname Dollar'),
	(N'STD', N'São Tomé and Príncipe Dobra'),
	(N'SVC', N'El Salvador Colon'),
	(N'SYP', N'Syria Pound'),
	(N'SZL', N'Swaziland Lilangeni'),
	(N'THB', N'Thailand Baht'),
	(N'TJS', N'Tajikistan Somoni'),
	(N'TMT', N'Turkmenistan Manat'),
	(N'TND', N'Tunisia Dinar'),
	(N'TOP', N'Tonga Pa''anga'),
	(N'TRY', N'Turkey Lira'),
	(N'TTD', N'Trinidad and Tobago Dollar'),
	(N'TVD', N'Tuvalu Dollar'),
	(N'TWD', N'Taiwan New Dollar'),
	(N'TZS', N'Tanzania Shilling'),
	(N'UAH', N'Ukraine Hryvnia'),
	(N'UGX', N'Uganda Shilling'),
	(N'USD', N'United States Dollar'),
	(N'UYU', N'Uruguay Peso'),
	(N'UZS', N'Uzbekistan Som'),
	(N'VEF', N'Venezuela Bolivar'),
	(N'VND', N'Viet Nam Dong'),
	(N'VUV', N'Vanuatu Vatu'),
	(N'WST', N'Samoa Tala'),
	(N'XAF', N'Communauté Financière Africaine (BEAC) CFA Franc BEAC'),
	(N'XCD', N'East Caribbean Dollar'),
	(N'XDR', N'International Monetary Fund (IMF) Special Drawing Rights'),
	(N'XOF', N'Communauté Financière Africaine (BCEAO) Franc'),
	(N'XPF', N'Comptoirs Français du Pacifique (CFP) Franc'),
	(N'YER', N'Yemen Rial'),
	(N'ZAR', N'South Africa Rand'),
	(N'ZMW', N'Zambia Kwacha'),
	(N'ZWD', N'Zimbabwe Dollar')
GO

CREATE TABLE [Country] (
  [Id] NCHAR(2) NOT NULL,
		[Name] NVARCHAR(255) NOT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_Country_Active] DEFAULT (1),
		CONSTRAINT [PK_Country] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_Country_Name] UNIQUE CLUSTERED ([Name])
	)
GO

INSERT INTO [Country] ([Name], [Id])
VALUES
 (N'Afghanistan', N'AF'),
 (N'Ãland Islands', N'AX'),
 (N'Albania', N'AL'),
 (N'Algeria', N'DZ'),
 (N'American Samoa', N'AS'),
 (N'Andorra', N'AD'),
 (N'Angola', N'AO'),
 (N'Anguilla', N'AI'),
 (N'Antarctica', N'AQ'),
 (N'Antigua and Barbuda', N'AG'),
 (N'Argentina', N'AR'),
 (N'Armenia', N'AM'),
 (N'Aruba', N'AW'),
 (N'Australia', N'AU'),
 (N'Austria', N'AT'),
 (N'Azerbaijan', N'AZ'),
 (N'Bahamas', N'BS'),
 (N'Bahrain', N'BH'),
 (N'Bangladesh', N'BD'),
 (N'Barbados', N'BB'),
 (N'Belarus', N'BY'),
 (N'Belgium', N'BE'),
 (N'Belize', N'BZ'),
 (N'Benin', N'BJ'),
 (N'Bermuda', N'BM'),
 (N'Bhutan', N'BT'),
 (N'Bolivia, Plurinational State of', N'BO'),
 (N'Bonaire, Sint Eustatius and Saba', N'BQ'),
 (N'Bosnia and Herzegovina', N'BA'),
 (N'Botswana', N'BW'),
 (N'Bouvet Island', N'BV'),
 (N'Brazil', N'BR'),
 (N'British Indian Ocean Territory', N'IO'),
 (N'Brunei Darussalam', N'BN'),
 (N'Bulgaria', N'BG'),
 (N'Burkina Faso', N'BF'),
 (N'Burundi', N'BI'),
 (N'Cambodia', N'KH'),
 (N'Cameroon', N'CM'),
 (N'Canada', N'CA'),
 (N'Cape Verde', N'CV'),
 (N'Cayman Islands', N'KY'),
 (N'Central African Republic', N'CF'),
 (N'Chad', N'TD'),
 (N'Chile', N'CL'),
 (N'China', N'CN'),
 (N'Christmas Island', N'CX'),
 (N'Cocos (Keeling) Islands', N'CC'),
 (N'Colombia', N'CO'),
 (N'Comoros', N'KM'),
 (N'Congo', N'CG'),
 (N'Congo, the Democratic Republic of the', N'CD'),
 (N'Cook Islands', N'CK'),
 (N'Costa Rica', N'CR'),
 (N'Cote d''Ivoire', N'CI'),
 (N'Croatia', N'HR'),
 (N'Cuba', N'CU'),
 (N'CuraÃ§ao', N'CW'),
 (N'Cyprus', N'CY'),
 (N'Czech Republic', N'CZ'),
 (N'Denmark', N'DK'),
 (N'Djibouti', N'DJ'),
 (N'Dominica', N'DM'),
 (N'Dominican Republic', N'DO'),
 (N'Ecuador', N'EC'),
 (N'Egypt', N'EG'),
 (N'El Salvador', N'SV'),
 (N'Equatorial Guinea', N'GQ'),
 (N'Eritrea', N'ER'),
 (N'Estonia', N'EE'),
 (N'Ethiopia', N'ET'),
 (N'Falkland Islands (Malvinas)', N'FK'),
 (N'Faroe Islands', N'FO'),
 (N'Fiji', N'FJ'),
 (N'Finland', N'FI'),
 (N'France', N'FR'),
 (N'French Guiana', N'GF'),
 (N'French Polynesia', N'PF'),
 (N'French Southern Territories', N'TF'),
 (N'Gabon', N'GA'),
 (N'Gambia', N'GM'),
 (N'Georgia', N'GE'),
 (N'Germany', N'DE'),
 (N'Ghana', N'GH'),
 (N'Gibraltar', N'GI'),
 (N'Greece', N'GR'),
 (N'Greenland', N'GL'),
 (N'Grenada', N'GD'),
 (N'Guadeloupe', N'GP'),
 (N'Guam', N'GU'),
 (N'Guatemala', N'GT'),
 (N'Guernsey', N'GG'),
 (N'Guinea', N'GN'),
 (N'Guinea-Bissau', N'GW'),
 (N'Guyana', N'GY'),
 (N'Haiti', N'HT'),
 (N'Heard Island and McDonald Mcdonald Islands', N'HM'),
 (N'Holy See (Vatican City State)', N'VA'),
 (N'Honduras', N'HN'),
 (N'Hong Kong', N'HK'),
 (N'Hungary', N'HU'),
 (N'Iceland', N'IS'),
 (N'India', N'IN'),
 (N'Indonesia', N'ID'),
 (N'Iran, Islamic Republic of', N'IR'),
 (N'Iraq', N'IQ'),
 (N'Ireland', N'IE'),
 (N'Isle of Man', N'IM'),
 (N'Israel', N'IL'),
 (N'Italy', N'IT'),
 (N'Jamaica', N'JM'),
 (N'Japan', N'JP'),
 (N'Jersey', N'JE'),
 (N'Jordan', N'JO'),
 (N'Kazakhstan', N'KZ'),
 (N'Kenya', N'KE'),
 (N'Kiribati', N'KI'),
 (N'Korea, Democratic People''s Republic of', N'KP'),
 (N'Korea, Republic of', N'KR'),
 (N'Kuwait', N'KW'),
 (N'Kyrgyzstan', N'KG'),
 (N'Lao People''s Democratic Republic', N'LA'),
 (N'Latvia', N'LV'),
 (N'Lebanon', N'LB'),
 (N'Lesotho', N'LS'),
 (N'Liberia', N'LR'),
 (N'Libya', N'LY'),
 (N'Liechtenstein', N'LI'),
 (N'Lithuania', N'LT'),
 (N'Luxembourg', N'LU'),
 (N'Macao', N'MO'),
 (N'Macedonia, the Former Yugoslav Republic of', N'MK'),
 (N'Madagascar', N'MG'),
 (N'Malawi', N'MW'),
 (N'Malaysia', N'MY'),
 (N'Maldives', N'MV'),
 (N'Mali', N'ML'),
 (N'Malta', N'MT'),
 (N'Marshall Islands', N'MH'),
 (N'Martinique', N'MQ'),
 (N'Mauritania', N'MR'),
 (N'Mauritius', N'MU'),
 (N'Mayotte', N'YT'),
 (N'Mexico', N'MX'),
 (N'Micronesia, Federated States of', N'FM'),
 (N'Moldova, Republic of', N'MD'),
 (N'Monaco', N'MC'),
 (N'Mongolia', N'MN'),
 (N'Montenegro', N'ME'),
 (N'Montserrat', N'MS'),
 (N'Morocco', N'MA'),
 (N'Mozambique', N'MZ'),
 (N'Myanmar', N'MM'),
 (N'Namibia', N'NA'),
 (N'Nauru', N'NR'),
 (N'Nepal', N'NP'),
 (N'Netherlands', N'NL'),
 (N'New Caledonia', N'NC'),
 (N'New Zealand', N'NZ'),
 (N'Nicaragua', N'NI'),
 (N'Niger', N'NE'),
 (N'Nigeria', N'NG'),
 (N'Niue', N'NU'),
 (N'Norfolk Island', N'NF'),
 (N'Northern Mariana Islands', N'MP'),
 (N'Norway', N'NO'),
 (N'Oman', N'OM'),
 (N'Pakistan', N'PK'),
 (N'Palau', N'PW'),
 (N'Palestine, State of', N'PS'),
 (N'Panama', N'PA'),
 (N'Papua New Guinea', N'PG'),
 (N'Paraguay', N'PY'),
 (N'Peru', N'PE'),
 (N'Philippines', N'PH'),
 (N'Pitcairn', N'PN'),
 (N'Poland', N'PL'),
 (N'Portugal', N'PT'),
 (N'Puerto Rico', N'PR'),
 (N'Qatar', N'QA'),
 (N'Reunion', N'RE'),
 (N'Romania', N'RO'),
 (N'Russian Federation', N'RU'),
 (N'Rwanda', N'RW'),
 (N'Saint BarthÃ©lemy', N'BL'),
 (N'Saint Helena, Ascension and Tristan da Cunha', N'SH'),
 (N'Saint Kitts and Nevis', N'KN'),
 (N'Saint Lucia', N'LC'),
 (N'Saint Martin (French part)', N'MF'),
 (N'Saint Pierre and Miquelon', N'PM'),
 (N'Saint Vincent and the Grenadines', N'VC'),
 (N'Samoa', N'WS'),
 (N'San Marino', N'SM'),
 (N'Sao Tome and Principe', N'ST'),
 (N'Saudi Arabia', N'SA'),
 (N'Senegal', N'SN'),
 (N'Serbia', N'RS'),
 (N'Seychelles', N'SC'),
 (N'Sierra Leone', N'SL'),
 (N'Singapore', N'SG'),
 (N'Sint Maarten (Dutch part)', N'SX'),
 (N'Slovakia', N'SK'),
 (N'Slovenia', N'SI'),
 (N'Solomon Islands', N'SB'),
 (N'Somalia', N'SO'),
 (N'South Africa', N'ZA'),
 (N'South Georgia and the South Sandwich Islands', N'GS'),
 (N'South Sudan', N'SS'),
 (N'Spain', N'ES'),
 (N'Sri Lanka', N'LK'),
 (N'Sudan', N'SD'),
 (N'Suriname', N'SR'),
 (N'Svalbard and Jan Mayen', N'SJ'),
 (N'Swaziland', N'SZ'),
 (N'Sweden', N'SE'),
 (N'Switzerland', N'CH'),
 (N'Syrian Arab Republic', N'SY'),
 (N'Taiwan, Province of China', N'TW'),
 (N'Tajikistan', N'TJ'),
 (N'Tanzania, United Republic of', N'TZ'),
 (N'Thailand', N'TH'),
 (N'Timor-Leste', N'TL'),
 (N'Togo', N'TG'),
 (N'Tokelau', N'TK'),
 (N'Tonga', N'TO'),
 (N'Trinidad and Tobago', N'TT'),
 (N'Tunisia', N'TN'),
 (N'Turkey', N'TR'),
 (N'Turkmenistan', N'TM'),
 (N'Turks and Caicos Islands', N'TC'),
 (N'Tuvalu', N'TV'),
 (N'Uganda', N'UG'),
 (N'Ukraine', N'UA'),
 (N'United Arab Emirates', N'AE'),
 (N'United Kingdom', N'GB'),
 (N'United States', N'US'),
 (N'United States Minor Outlying Islands', N'UM'),
 (N'Uruguay', N'UY'),
 (N'Uzbekistan', N'UZ'),
 (N'Vanuatu', N'VU'),
 (N'Venezuela, Bolivarian Republic of', N'VE'),
 (N'Viet Nam', N'VN'),
 (N'Virgin Islands, British', N'VG'),
 (N'Virgin Islands, U.S.', N'VI'),
 (N'Wallis and Futuna', N'WF'),
 (N'Western Sahara', N'EH'),
 (N'Yemen', N'YE'),
 (N'Zambia', N'ZM'),
 (N'Zimbabwe', N'ZW')
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

SET IDENTITY_INSERT [Territory] ON
INSERT INTO [Territory] ([Id], [Name], [Type])
VALUES
 (0, N'All Countries', NULL),
	(1, N'United Kingdom', 1),
	(2, N'All Countries excluding United Kingdom', 0),
	(3, N'United Kingdom and Ireland', 1),
	(4, N'United States', 1),
	(5, N'All Countries excluding United States', 0)
SET IDENTITY_INSERT [Territory] OFF
GO

INSERT INTO [TerritoryCountry] ([TerritoryId], [CountryId], [Type])
VALUES
 (1, N'GB', 1),
	(2, N'GB', 0),
	(3, N'GB', 1),
	(3, N'IE', 1),
	(4, N'US', 1),
	(5, N'US', 0)
GO

CREATE TABLE [ClassOfBusiness] (
  [Id] NCHAR(3) NOT NULL,
		[Name] NVARCHAR(255) NOT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_ClassOfBusiness_Active] DEFAULT (1),
		CONSTRAINT [PK_ClassOfBusiness] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_ClassOfBusiness_Name] UNIQUE CLUSTERED ([Name])
 )
GO

INSERT INTO [ClassOfBusiness] ([Id], [Name])
VALUES
 (N'PRP', N'Property'),
	(N'MTR', N'Motor/Auto'),
	(N'MAR', N'Marine'),
	(N'AVI', N'Aviation'),
	(N'TRV', N'Travel'),
	(N'ACC', N'Personl Accident'),
	(N'CAS', N'Liability/Casualty'),
	(N'LIF', N'Life')
GO

CREATE TABLE [CodeScheme] (
  [Id] INT NOT NULL IDENTITY (1, 1),
		[Name] NVARCHAR(255) NOT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_CodeScheme_Active] DEFAULT (1),
		CONSTRAINT [PK_CodeScheme] PRIMARY KEY NONCLUSTERED ([Id]),
		CONSTRAINT [UQ_CodeScheme_Name] UNIQUE CLUSTERED ([Name]),
		CONSTRAINT [CK_CodeScheme_Id] CHECK ([Id] >= 0),
		CONSTRAINT [CK_CodeScheme_Lloyds] CHECK (([Id] = 0 AND [Name] = N'Lloyd''s' AND [Active] = 1) OR [Id] > 0)
	)
GO

SET IDENTITY_INSERT [CodeScheme] ON
INSERT INTO [CodeScheme] ([Id], [Name])
VALUES (0, N'Lloyd''s')
SET IDENTITY_INSERT [CodeScheme] OFF
GO

CREATE TABLE [PerilHierarchy] (
  [CodeSchemeId] INT NOT NULL,
		[Level] TINYINT NOT NULL,
		[Description] NVARCHAR(255) NOT NULL,
		[Required] BIT NOT NULL CONSTRAINT [DF_PerilHierarchy_Required] DEFAULT (1),
		[ParentLevel] AS CONVERT(TINYINT, NULLIF(CONVERT(INT, [Level]) - 1, -1)) PERSISTED,
		[ParentRequired] AS CONVERT(BIT, NULLIF([Required], 0)) PERSISTED,
		CONSTRAINT [PK_PerilHierarchy] PRIMARY KEY CLUSTERED ([CodeSchemeId], [Level]),
		CONSTRAINT [UQ_PerilHierarchy_Description] UNIQUE ([CodeSchemeId], [Description]),
		CONSTRAINT [UQ_PerilHierarchy_Required] UNIQUE ([CodeSchemeId], [Level], [Required]),
		CONSTRAINT [FK_PerilHierarchy_PerilHierarchy_PreviousLevel] FOREIGN KEY ([CodeSchemeId], [ParentLevel]) REFERENCES [PerilHierarchy] ([CodeSchemeId], [Level]),
		CONSTRAINT [FK_PerilHierarchy_PerilHierarchy_PreviousRequired] FOREIGN KEY ([CodeSchemeId], [ParentLevel], [ParentRequired]) REFERENCES [PerilHierarchy] ([CodeSchemeId], [Level], [Required]),
		CONSTRAINT [CK_PerilHierarchy_Level] CHECK ([Level] >= 0)
	)
GO

INSERT INTO [PerilHierarchy] ([CodeSchemeId], [Level], [Description], [Required])
VALUES
 (0, 0, N'High Level Class of Business', 1),
	(0, 1, N'Generic Class of Business', 1),
	(0, 2, N'Risk Code', 1)
GO

CREATE TABLE [Peril] (
  [CodeSchemeId] INT NOT NULL,
		[Level] TINYINT NOT NULL,
		[Id] INT NOT NULL IDENTITY (1, 1),
		[Code] NVARCHAR(25) NULL,
		[Description] NVARCHAR(255) NOT NULL,
		[DisplayName] AS [Description] + ISNULL(N' ' + QUOTENAME([Code], N'['), N'') PERSISTED,
		[ParentId] INT NULL,
		[ParentLevel] AS CONVERT(TINYINT, NULLIF(CONVERT(INT, [Level]) - 1, -1)) PERSISTED,
		[Active] BIT NOT NULL CONSTRAINT [DF_Peril_Active] DEFAULT (1),
		CONSTRAINT [PK_Peril] PRIMARY KEY NONCLUSTERED ([CodeSchemeId], [Level], [Id]),
		CONSTRAINT [UQ_Peril_Description] UNIQUE CLUSTERED ([CodeSchemeId], [Level], [ParentId], [Description], [Code]),
		CONSTRAINT [UQ_Peril_Id] UNIQUE ([Id]),
		CONSTRAINT [UQ_Peril_CodeSchemeId] UNIQUE ([CodeSchemeId], [Id]),
		CONSTRAINT [FK_Peril_PerilHierarchy] FOREIGN KEY ([CodeSchemeId], [Level]) REFERENCES [PerilHierarchy] ([CodeSchemeId], [Level]),
		CONSTRAINT [FK_Peril_Peril] FOREIGN KEY ([CodeSchemeId], [ParentLevel], [ParentId]) REFERENCES [Peril] ([CodeSchemeId], [Level], [Id]),
		CONSTRAINT [CK_Peril_Id] CHECK ([Id] >= 0),
		CONSTRAINT [CK_Peril_ParentId] CHECK ([Level] = 0 OR [ParentId] IS NOT NULL)
 )
GO

DECLARE @Lloyds TABLE (
  [Code] NVARCHAR(2) NOT NULL,
		[Description] NVARCHAR(255) NOT NULL,
		[Start] INT NOT NULL,
		[End] INT NOT NULL,
		[Section] NVARCHAR(255) NOT NULL,
		[Class] NVARCHAR(255) NOT NULL
 )

INSERT INTO @Lloyds
SELECT *
FROM (VALUES
			('1', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('2', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('3', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('4', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('5', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('6', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('7', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('8', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('9', 'AVIATION HULL AND LIAB INCL WAR EXCL WRO NO PROPOR RI', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('1E', 'OVERSEAS LEG TERRORISM ENERGY OFFSHORE PROPERTY', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('1T', 'OVERSEAS LEG TERRORISM ACCIDENT AND HEALTH', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('2E', 'OVERSEAS LEG TERRORISM ENERGY OFFSHORE LIABILITY', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('2T', 'OVERSEAS LEG TERRORISM AVIATION', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('3E', 'OVERSEAS LEG TERRORISM ENERGY ONSHORE PROPERTY', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('3T', 'OVERSEAS LEG TERRORISM MARINE', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('4E', 'OVERSEAS LEG TERRORISM ENERGY ONSHORE LIABILITY', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('4T', 'OVERSEAS LEG TERRORISM MISC AND PECUNIARY LOSS', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('5T', 'OVERSEAS LEG TERRORISM MOTOR', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('6T', 'OVERSEAS LEG TERRORISM PROPERTY', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('7T', 'OVERSEAS LEG TERRORISM THIRD PARTY LIABILITY', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('8T', 'OVERSEAS LEG TERRORISM TRANSPORT', 2000, 9999, 'Terrorism', 'Property (D&F)'),
			('AG', 'AGRICULTURAL CROP AND FORESTRY XOL TREATY INCL STOP LOSS', 1993, 9999, 'Agriculture & Hail', 'Property Treaty'),
			('AO', 'AVIATION PREMISES LEGAL LIABILITY NO PRODUCTS', 1991, 9999, 'Aviation Products/ Airport Liabilities', 'Aviation'),
			('AP', 'AVIATION OR AEROSPACE PRODUCTS LEGAL LIABILITY', 1991, 9999, 'Aviation Products/ Airport Liabilities', 'Aviation'),
			('AR', 'AVN WHOLE ACCT STOP LOSS AND OR AGG EXCESS OF LOSS - Risk code retired with effect from 01/01/05: use risk code "XY"', 1993, 2004, 'Aviation XL', 'Aviation'),
			('AW', 'HULLS OF AIRCRAFT WAR OR CONFISCATION NO ACV', 1991, 9999, 'Aviation War', 'Aviation'),
			('AX', 'AVIATION LIABILITY EXCESS OF LOSS - Risk code retired with effect from 01/01/05: use risk code "XY"', 1992, 2004, 'Aviation XL', 'Aviation'),
			('B', 'Vessels TLO IV LOH and Containers Excl. WRO', 1991, 9999, 'Marine Hull', 'Marine'),
			('B2', 'PHYS DAMAGE BINDER FOR PRIVATE PPTY IN USA', 2004, 9999, 'Property D&F (US binder)', 'Property (D&F)'),
			('B3', 'PHYS DAMAGE BINDER FOR COMMERCIAL PPTY IN USA', 2004, 9999, 'Property D&F (US binder)', 'Property (D&F)'),
			('B4', 'PHYS DAMAGE BINDER FOR PRIVATE PPTY EXCL USA', 2004, 9999, 'Property D&F (non-US binder)', 'Property (D&F)'),
			('B5', 'PHYS DAMAGE BINDER FOR COMMERCIAL PPTY EXCL USA', 2004, 9999, 'Property D&F (non-US binder)', 'Property (D&F)'),
			('BB', 'FIDELITY COMPUTER CRIME AND BANKERS POLICIES', 1991, 9999, 'BBB/ Crime', 'Casualty'),
			('BD', 'TERRORISM POOL RE', 1991, 9999, 'Terrorism', 'Property (D&F)'),
			('BS', 'MORTGAGE INDEMNITY UK PRIVATE - Risk code retired with effect from 01/01/05: use risk code "FM"', 1991, 2004, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('CA', 'ENGINEERING INCL MCHY AND BOILERS CAR AND ENG AR - Risk code retired with effect from 01/01/2011: use risk codes "CB" or "CC" as appropriate', 1991, 2010, 'Engineering', 'Property (D&F)'),
			('CB', 'ENGINEERING ANNUAL RENEWABLE INCL CAR EAR MB CPE B&M EEI AND TREATY LOD', 2011, 9999, 'Engineering', 'Property (D&F)'),
			('CC', 'ENGINEERING SINGLE PROJECT NON RENEWABLE INCL CAR EAR AND TREATY RAD', 2011, 9999, 'Engineering', 'Property (D&F)'),
			('CF', 'CONTRACT FRUSTRATION IN ACCORD MKT BULLETIN 4396 DATED 07/05/2010 - From 01/01/05 also includes business previously coded "CP" ', 1991, 9999, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('CN', 'CREDIT NON PROPORTIONAL TREATY BUSINESS - Risk code retired with effect from 01/01/05: use risk code "CR"', 1998, 2004, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('CP', 'CONTRACT FRUSTRATION EXCLUDING WAR AND INSOLVENCY - Risk code retired with effect from 01/01/05: use risk code "CF"', 1993, 2004, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('CR', 'CREDIT BUSINESS IN ACCORD MKT BULLETIN 4396 DATED 07/05/2010 - From 01/01/05 also includes business previously coded "CN" ', 1991, 9999, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('CT', 'ARMOURED CARRIERS AND CASH IN TRANSIT', 1992, 9999, 'Specie', 'Marine'),
			('CX', 'SPACE RISKS LAUNCH COMMISSIONING AND TRANSPOND OP - Risk code being retired with effect from 01/01/2008: use risk code "SC"', 1992, 2007, 'Space', 'Aviation'),
			('CY', 'Cyber Security Data and Privacy Breach', 2013, 9999, 'Cyber', 'Casualty'),
			('CZ', 'CYBER SECURITY AND PROPERTY DAMAGE', 2015, 9999, 'Cyber', 'Casualty'),
			('D2', 'D AND O LIAB EXCL FINANCIAL INSTITUTIONS IN USA', 2004, 9999, 'Directors & Officers (US)', 'Casualty'),
			('D3', 'D AND O LIAB EXCL FINANCIAL INSTITUTIONS EXCL USA ', 2004, 9999, 'Directors & Officers (non-US)', 'Casualty'),
			('D4', 'D AND O LIAB FOR FINANCIAL INSTITUTIONS INCL USA', 2004, 9999, 'Financial Institutions (US)', 'Casualty'),
			('D5', 'D AND O LIAB FOR FINANCIAL INSTITUTIONS EXCL USA', 2004, 9999, 'Financial Institutions (non-US)', 'Casualty'),
			('D6', 'Employment Practices Liability Insurance (EPLI) Incl. US', 2016, 9999, 'Directors & Officers (US)', 'Casualty'),
			('D7', 'Employment Practices Liability Insurance (EPLI) Excl. US', 2016, 9999, 'Directors & Officers (non-US)', 'Casualty'),
			('D8', 'Transactional Liability insurance Incl. US', 2016, 9999, 'Directors & Officers (US)', 'Casualty'),
			('D9', 'Transactional Liability insurance Excl. US', 2016, 9999, 'Directors & Officers (non-US)', 'Casualty'),
			('DC', 'DIFFERENCE IN CONDITIONS', 1991, 9999, 'Difference in Conditions', 'Property (D&F)'),
			('DM', 'DIRECTORS AND OFFICERS LIAB FOR FINANCIAL INST. - Risk code retired with effect from 01/01/05: use risk codes "D4" or "D5" as appropriate', 2002, 2004, 'Directors & Officers', 'Casualty'),
			('DO', 'DIRECTORS AND OFFICERS LIAB EXCL FINANCIAL INST. - Risk code retired with effect from 01/01/05: use risk codes "D2" or "D3" as appropriate ', 1991, 2004, 'Directors & Officers', 'Casualty'),
			('DX', 'PERSONAL ACCIDENT AND SICKNESS AVIATION', 1992, 1994, 'Personal Accident XL', 'Accident & Health'),
			('E2', 'PROF INDTY E AND O FOR LEGAL PROFESSIONS INCL USA', 2004, 9999, 'Professional Indemnity (US)', 'Casualty'),
			('E3', 'PROF INDTY E AND O FOR LEGAL PROFESSIONS EXCL USA', 2004, 9999, 'Professional Indemnity (non-US)', 'Casualty'),
			('E4', 'PROF INDTY E AND O FOR ACCOUNTANTS INCL USA', 2004, 9999, 'Professional Indemnity (US)', 'Casualty'),
			('E5', 'PROF INDTY E AND O FOR ACCOUNTANTS EXCL USA', 2004, 9999, 'Professional Indemnity (non-US)', 'Casualty'),
			('E6', 'PROF INDTY E AND O ARCHITECTS ENGINEERS INCL USA', 2004, 9999, 'Professional Indemnity (US)', 'Casualty'),
			('E7', 'PROF INDTY E AND O ARCHITECTS AND ENGINEERS EXCL USA', 2004, 9999, 'Professional Indemnity (non-US)', 'Casualty'),
			('E8', 'MISC PROF IND E AND O INCL USA EXCL "E2" "E4" "E6" CODES', 2004, 9999, 'Professional Indemnity (US)', 'Casualty'),
			('E9', 'MISC PROF IND E AND O EXCL USA EXCL "E3" "E5" "E7" CODES', 2004, 9999, 'Professional Indemnity (non-US)', 'Casualty'),
			('EA', 'ENERGY LIABILITY ONSHORE CLAIMS MADE', 1991, 9999, 'Energy Onshore Liability', 'Energy'),
			('EB', 'ENERGY LIABILITY ONSHORE ALL OTHER', 1991, 9999, 'Energy Onshore Liability', 'Energy'),
			('EC', 'ENERGY CONSTRUCTION OFFSHORE PROP AND SEARCH PROD VSSLS EXCL WRO', 2010, 9999, 'Energy Offshore Property', 'Energy'),
			('EF', 'ENERGY ONSHORE PROPERTY', 1991, 9999, 'Energy Onshore Property', 'Energy'),
			('EG', 'ENERGY LIABILITY OFFSHORE CLAIMS MADE', 1991, 9999, 'Energy Offshore Liability', 'Energy'),
			('EH', 'ENERGY LIABILITY OFFSHORE ALL OTHER', 1991, 9999, 'Energy Offshore Liability', 'Energy'),
			('EM', 'ENERGY SEARCH PROD VSSLS AND OFFSHORE PROP GOM WIND EXCL WRO EXCL CONSTRUCTION', 2011, 9999, 'Energy Offshore Property', 'Energy'),
			('EN', 'ENERGY SEARCH PROD VSSLS AND OFFSHORE PROP EXCL GOM WIND EXCL WRO EXCL CONSTRUCTION', 2011, 9999, 'Energy Offshore Property', 'Energy'),
			('EP', 'Environmental Impairment Liability or NM Pollution Liability', 2016, 9999, 'NM General Liability (non-US direct)', 'Casualty'),
			('ET', 'ENERGY SEARCH PROD VSSLS AND OFFSHORE PROP EXCL WRO EXCL CONSTRUCTION - Risk code retired with effect from 01/01/2011: use risk codes "EM" or "EN" as appropriate ', 1991, 2010, 'Energy Offshore Property', 'Energy'),
			('EW', 'ENERGY OPERATORS XTRA EXPENSES AND CONTROL OF WELL - Risk code retired with effect from 01/01/2011: use risk codes "EY" or "EZ" as appropriate', 1991, 2010, 'Energy Offshore Property', 'Energy'),
			('EY', 'ENERGY OPERATORS XTRA EXPENSES AND CONTROL OF WELL GOM  WIND', 2011, 9999, 'Energy Offshore Property', 'Energy'),
			('EZ', 'ENERGY OPERATORS XTRA EXPENSES AND CONTROL OF WELL EXCL GOM WIND', 2011, 9999, 'Energy Offshore Property', 'Energy'),
			('F', 'FIRE AND PERILS - Risk code retired with effect from 01/01/05: use risk codes "B2" to "B5" or "P2" to "P7" as appropriate', 1991, 2004, 'Property (direct & facultative)', 'Property (D&F)'),
			('F2', 'PROF INDTY E AND O FOR FIN INSTITUTIONS INCL USA', 2004, 9999, 'Financial Institutions (US)', 'Casualty'),
			('F3', 'PROF INDTY E AND O FOR FIN INSTITUTIONS EXCL USA', 2004, 9999, 'Financial Institutions (non-US)', 'Casualty'),
			('F4', 'Technology and Telecommunications E&O Incl. US', 2016, 9999, 'Professional Indemnity (US)', 'Casualty'),
			('F5', 'Technology and Telecommunications E&O Excl. US', 2016, 9999, 'Professional Indemnity (non-US)', 'Casualty'),
			('FA', 'FINE ART', 1992, 9999, 'Fine Art', 'Marine'),
			('FC', 'COLLISION SALVAGE GENERAL AVERAGE GUARANTEES  - Risk code retired with effect from 01/01/05: use risk code "SB"', 1999, 2004, 'Cargo', 'Marine'),
			('FG', 'FINANCIAL GUARANTEE (authorised syndicates only)', 2001, 9999, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('FM', 'MORTGAGE INDEMNITY - From 01/01/05 also includes business previously coded "BS" ', 1999, 9999, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('FR', 'FURRIERS - Risk code retired with effect from 01/01/05: use risk code "JB"', 1992, 2004, 'Specie', 'Marine'),
			('FS', 'SURETY BOND RI WEF 31/10/01 EXCL SB COUNTRIES - Risk code retired with effect from 01/01/05: use risk code "SB"', 1999, 2004, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('G', 'MARINE LEGAL LIAB ALL OTHER NO CARGO EXCL WRO', 1991, 9999, 'Marine Liability', 'Marine'),
			('GC', 'MARINE LEGAL LIAB CLAIMS MADE NO CARGO EXCL WRO', 1991, 9999, 'Marine Liability', 'Marine'),
			('GH', 'HOSPITALS/ INSTITUTIONAL HEALTHCARE INSURANCE RISKS IN USA', 2008, 9999, 'Medical Malpractice', 'Casualty'),
			('GM', 'MEDICAL MALPRACTICE EXCL USA ', 2008, 9999, 'Medical Malpractice', 'Casualty'),
			('GN', 'NURSING HOMES/ LONG-TERM AND ALLIED HEALTHCARE/OTHER MEDICAL MALPRACTICE RISKS IN USA', 2008, 9999, 'Medical Malpractice', 'Casualty'),
			('GP', 'MEDICAL MALPRACTICE NON MARINE - Risk code being retired with effect from 01/01/2008: use risk codes "GH" "GT" "GN" and "GM" as appropriate', 1995, 2007, 'Medical Malpractice', 'Casualty'),
			('GS', 'GENERAL SPECIE INCLUDING VAULT RISK', 1992, 9999, 'Specie', 'Marine'),
			('GT', 'MEDICAL MALPRACTICE TREATY XOL IN USA', 2008, 9999, 'Medical Malpractice', 'Casualty'),
			('GX', 'XOL MARINE LEGAL LIAB EXCL CARGO ALL OTHER EXCL WRO', 1992, 9999, 'Marine XL', 'Marine'),
			('H', 'HULLS OF AIRCRAFT EXCL SPACE OR ACV EXCL WRO - Risk code retired with effect from 01/01/05: use risk codes "H2" or "H3" as appropriate', 1991, 2004, 'Airline/ General Aviation', 'Aviation'),
			('H2', 'AIRLINE HULL', 2004, 9999, 'Airline', 'Aviation'),
			('H3', 'GENERAL AVIATION HULL', 2004, 9999, 'General Aviation', 'Aviation'),
			('HA', 'AGRICULTURAL CROP AND FORESTRY EXCL XOL TREATY AND STOP LOSS', 1991, 9999, 'Agriculture & Hail', 'Property Treaty'),
			('HP', 'UK HOUSEHOLD BUSINESS', 1993, 9999, 'Property D&F (non-US binder)', 'Property (D&F)'),
			('HX', 'XOL HULLS OF AIRCRAFT INCL SPARES AND LOU EXCL WRO - Risk code being retired with effect from 01/01/2008: use risk code "XY"', 1992, 2007, 'Aviation XL', 'Aviation'),
			('JB', 'JEWELLERS BLOCK JEWELLERY ETC INCL ROBBERY - From 01/01/05 also includes business previously coded "FR" ', 1991, 9999, 'Specie', 'Marine'),
			('K', 'PERSONAL ACCIDENT AND SICKNESS', 1991, 1994, 'Accident & Health (direct)', 'Accident & Health'),
			('KA', 'PERSONAL ACCIDENT AND HEALTH CARVE OUT', 1995, 9999, 'Accident & Health (direct)', 'Accident & Health'),
			('KC', 'PERSONAL ACCIDENT AND HEALTH CREDITOR  DISABILITY', 1995, 9999, 'Accident & Health (direct)', 'Accident & Health'),
			('KD', 'PERSONAL ACCIDENT AND SICKNESS  AVIATION', 1991, 1994, 'Accident & Health (direct)', 'Accident & Health'),
			('KG', 'Personal Accident and Health Excl. K&R, KP KS AND KT CODES', 2004, 9999, 'Accident & Health (direct)', 'Accident & Health'),
			('KK', 'PERSONAL ACCIDENT AND HEALTH - Risk code retired with effect from 01/01/05: use risk codes "KG" "KS"or "KT" as appropriate', 1995, 2004, 'Accident & Health (direct)', 'Accident & Health'),
			('KL', 'PERSONAL ACCIDENT AND HEALTH LMX - Risk code being retired with effect from 01/01/2008: use risk code "KX"', 1995, 2007, 'Personal Accident XL', 'Accident & Health'),
			('KM', 'MEDICAL EXPENSES INCL XS SPEC AND AGG SELF FUND', 1995, 9999, 'Medical Expenses', 'Accident & Health'),
			('KP', 'MARITIME EXTORTION EXCL KIDNAP AND RANSOM WRITTEN UNDER KG', 2013, 9999, 'Accident & Health (direct)', 'Accident & Health'),
			('KS', 'PA AND HEALTH INCL SPORTS DIS OTHER THAN ACC DEATH', 2004, 9999, 'Accident & Health (direct)', 'Accident & Health'),
			('KT', 'PA AND HEALTH FOR TRAVEL PACKAGE SCHEMES', 2004, 9999, 'Accident & Health (direct)', 'Accident & Health'),
			('KX', 'PERSONAL ACCIDENT AND HEALTH CATASTROPHE XL - From 01/01/08 also includes business previously coded "KL"', 1995, 9999, 'Personal Accident XL', 'Accident & Health'),
			('L', 'AIRCRAFT OPERATORS AND OWNERS LEGAL LIAB  - Risk code retired with effect from 01/01/2005: use risk codes "L2" or "L3" as appropriate', 1991, 2004, 'Airline/ General Aviation', 'Aviation'),
			('L2', 'AIRLINE LIABILITY', 2004, 9999, 'Airline', 'Aviation'),
			('L3', 'GENERAL AVIATION LIABILITY', 2004, 9999, 'General Aviation', 'Aviation'),
			('LE', 'LEGAL EXPENSES    ', 1991, 9999, 'Legal Expenses', 'Accident & Health'),
			('LJ', 'FOR USE BY LLOYDS JAPAN ONLY', 1997, 9999, 'Lloyd''s Japan', 'Property (D&F)'),
			('LX', 'AIRCRAFT OPERATORS AND OWNERS LEGAL LIAB', 1992, 1996, 'Aviation XL', 'Aviation'),
			('M2', 'UK MOTOR COMP FOR PRIVATE CAR INCL MOTORCYCLE', 2004, 9999, 'UK Motor', 'UK Motor'),
			('M3', 'UK MOTOR COMP FOR FLEET AND COMMERCIAL VEHICLE', 2004, 9999, 'UK Motor', 'UK Motor'),
			('M4', 'OTHER UK MOTOR COMP AND NON COMP EXCL "M2" AND "M3" CODES - From 01/01/08 includes business previously coded "M7"', 2004, 9999, 'UK Motor', 'UK Motor'),
			('M5', 'UK MOTOR NON COMP FOR PRIVATE CAR INCL MOTORCYCLE', 2004, 9999, 'UK Motor', 'UK Motor'),
			('M6', 'UK MOTOR NON COMP FOR FLEET AND COMM VEHICLE', 2004, 9999, 'UK Motor', 'UK Motor'),
			('M7', 'OTHER UK MOTOR NON COMP EXCL "M5" AND "M6" CODES - Risk code being retired with effect from 1/1/2008: use risk code "M4"', 2004, 2007, 'UK Motor', 'UK Motor'),
			('MA', 'UK MOTOR VEHICLE PHYSICAL DAMAGE ONLY - Risk code retired with effect from 01/01/05: use risk codes "M2" to "M4" as appropriate', 1991, 2004, 'UK Motor', 'UK Motor'),
			('MB', 'UK MOTOR VEHICLE THIRD PARTY LIABILITY', 1991, 1995, 'UK Motor', 'UK Motor'),
			('MC', 'UK MOTOR VEHICLE DAMAGE AND THIRD PARTY LIABILITY', 1991, 1995, 'UK Motor', 'UK Motor'),
			('MD', 'OVERSEAS MOTOR PHYS DAM EXCL USA CAN EU AND EEA - Risk code retired with effect from 01/01/05: use risk code "MF"', 1991, 2004, 'Overseas Motor', 'Overseas Motor'),
			('ME', 'OVERSEAS MOTOR TPL EXCL USA CAN EU AND EEA - Risk code retired with effect from 01/01/05: use risk code "MF"', 1991, 2004, 'Overseas Motor', 'Overseas Motor'),
			('MF', 'OVERSEAS MOTOR DAM AND TPL EXCL USA CAN EU AND EEA - From 01/01/05 also includes business previously coded "MD" and "ME"', 1991, 9999, 'Overseas Motor', 'Overseas Motor'),
			('MG', 'USA AND CANADA MOTOR VEHICLE PHYSICAL DAMAGE', 1991, 9999, 'Overseas Motor', 'Overseas Motor'),
			('MH', 'USA AND CANADA MOTOR VEHICLE THIRD PARTY LIABILITY', 1991, 9999, 'Overseas Motor', 'Overseas Motor'),
			('MI', 'USA AND CANADA MOTOR DAMAGE AND 3RD PARTY LIAB', 1991, 9999, 'Overseas Motor', 'Overseas Motor'),
			('MK', 'UK MOTOR VEHICLE COMPREHENSIVE - Risk code retired with effect from 01/01/2005: use risk codes "M2" to "M4" as appropriate', 1995, 2004, 'UK Motor', 'UK Motor'),
			('ML', 'UK MOTOR VEHICLE NON COMPREHENSIVE - Risk code retired with effect from 01/01/2005: use risk codes "M5" to "M7" as appropriate', 1995, 2004, 'UK Motor', 'UK Motor'),
			('MM', 'EU AND EEA MOTOR PHYSICAL DAM ONLY EXCL UK - Risk code retired with effect from 01/01/05: use risk code "MP"', 1998, 2004, 'Overseas Motor', 'Overseas Motor'),
			('MN', 'EU AND EEA THIRD PARTY LIAB ONLY EXCL UK - Risk code retired with effect from 01/01/05: use risk code "MP"', 1998, 2004, 'Overseas Motor', 'Overseas Motor'),
			('MP', 'EU AND EEA MOTOR PD AND TPL EXCL UK - From 01/01/05 also includes business previously coded "MM" and "MN"', 1998, 9999, 'Overseas Motor', 'Overseas Motor'),
			('N', 'LIVESTOCK', 1991, 9999, 'Livestock & Bloodstock', 'Property (D&F)'),
			('NA', 'NM GENERAL AND MISC LIABILITY ALL OTHER  EXCL USA - From 01/01/08 also includes business previously coded "PL"  ', 1991, 9999, 'NM General Liability (non-US direct)', 'Casualty'),
			('NB', 'BLOODSTOCK', 2001, 9999, 'Livestock & Bloodstock', 'Property (D&F)'),
			('NC', 'NM GENERAL AND MISC LIAB CLAIMS MADE EXCL USA - From 01/01/08 also includes business previously coded "PL" ', 1991, 9999, 'NM General Liability (non-US direct)', 'Casualty'),
			('NL', 'NUCLEAR LIABILITY', 1998, 9999, 'Nuclear', 'Property (D&F)'),
			('NP', 'NUCLEAR PROPERTY DAMAGE', 1998, 9999, 'Nuclear', 'Property (D&F)'),
			('NX', 'LIVESTOCK EXCESS OF LOSS', 1997, 9999, 'Livestock & Bloodstock', 'Property (D&F)'),
			('O', 'YACHTS INCL WAR EXCL WRO', 1991, 9999, 'Yacht', 'Marine'),
			('OX', 'XOL YACHTS INCL WAR EXCL WRO - Risk code retired with effect from 01/01/05: use risk code "TX"', 1992, 2004, 'Marine XL', 'Marine'),
			('P', 'MISCELLANEOUS PECUNIARY LOSS - From 01/01/05 also includes business previously coded "PE" "PP" "PS" and "PW"', 1991, 9999, 'Pecuniary', 'Accident & Health'),
			('P2', 'PHYS DAMAGE FOR PRIM LAYER PPTY IN USA EXCL BINDERS', 2004, 9999, 'Property D&F (US open market)', 'Property (D&F)'),
			('P3', 'PHYS DAMAGE FOR PRIM LAYER PPTY EXCL USA EXCL BINDERS', 2004, 9999, 'Property D&F (non-US open market)', 'Property (D&F)'),
			('P4', 'PHYS DAMAGE FOR FULL VALUE PPTY IN USA EXCL BINDERS', 2004, 9999, 'Property D&F (US open market)', 'Property (D&F)'),
			('P5', 'PHYS DAMAGE FOR FULL VALUE PPTY EXCL USA EXCL BINDERS', 2004, 9999, 'Property D&F (non-US open market)', 'Property (D&F)'),
			('P6', 'PHYS DAMAGE FOR XS LAYER PPTY IN USA EXCL BINDERS', 2004, 9999, 'Property D&F (US open market)', 'Property (D&F)'),
			('P7', 'PHYS DAMAGE FOR XS LAYER PPTY EXCL USA EXCL BINDERS', 2004, 9999, 'Property D&F (non-US open market)', 'Property (D&F)'),
			('PB', 'PRODUCT RECALL', 1999, 9999, 'Pecuniary', 'Accident & Health'),
			('PC', 'CANCELLATION AND ABANDONMENT', 1999, 9999, 'Contingency', 'Accident & Health'),
			('PD', 'ALL RISK PHYSICAL LOSS DAMAGE NO DIRECT PPNL RI - Risk code retired with effect from 01/01/2005: use risk codes "B2" to "B5" or "P2" to "P7" as appropriate', 1991, 2004, 'Property (direct & facultative)', 'Property (D&F)'),
			('PE', 'LIQUIDATED DAMAGES FORCE MAJEURE - Risk code retired with effect from 01/01/05: use risk code "P"', 1999, 2004, 'Pecuniary', 'Accident & Health'),
			('PF', 'FILM INCLUDING FILM COMPLETION BONDS  ', 1999, 9999, 'Contingency', 'Accident & Health'),
			('PG', 'OPERATIONAL POWER GENERATION TRANSMISSION AND UTILITIES EXCL CONSTRUCTION ', 2008, 9999, 'Power Generation', 'Property (D&F)'),
			('PI', 'E AND O OR PROFESSIONAL INDEM EXCL FINANCIAL INST. - Risk code retired with effect from 01/01/2005: use risk codes "E2" to "E9" as appropriate  ', 1991, 2004, 'Professional Indemnity', 'Casualty'),
			('PL', 'NM LEGAL LIABILITY FOR PROPERTY OWNERS INCL RETAIL/W''SALE OUTLETS AND ASSOCIATED MINOR PRODUCTS & COMPLETED RISKS - Risk code being retired with effect from 01/01/2008: use risk codes "NA" "NC" "UA" OR "UC" as appropriate', 1991, 2007, 'NM General Liability (non-US direct)', 'Casualty'),
			('PM', 'PROFESSIONAL INDEMNITY FOR FINANCIAL INSTITUTIONS - Risk code retired with effect from 01/01/2005: use risk codes "F2" or "F3" as appropriate  ', 2002, 2004, 'Professional Indemnity', 'Casualty'),
			('PN', 'NON APPEARANCE', 1999, 9999, 'Contingency', 'Accident & Health'),
			('PO', 'OVER REDEMPTION - Risk code retired with effect from 01/01/05: use risk code "PU"', 1999, 2004, 'Contingency', 'Accident & Health'),
			('PP', 'ESTATE PROTECTION - Risk code retired with effect from 01/01/05: use risk code "P"', 1991, 2004, 'Pecuniary', 'Accident & Health'),
			('PQ', 'ROADSIDE RESCUE     ', 2000, 9999, 'UK Motor', 'UK Motor'),
			('PR', 'POLITICAL RISK EXCL CONFISCATION VESSELS AIRCRAFT', 1991, 9999, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('PS', 'PERSONAL STOP LOSS - Risk code retired with effect from 01/01/05: use risk code "P"', 1991, 2004, 'Pecuniary', 'Accident & Health'),
			('PU', 'MISCELLANEOUS CONTINGENCY - From 01/01/05 also includes business previously coded "PO"', 2001, 9999, 'Contingency', 'Accident & Health'),
			('PW', 'WEATHER INCLUDING PLUVIUS - Risk code retired with effect from 01/01/05: use risk code "PU"', 1999, 2004, 'Contingency', 'Accident & Health'),
			('PX', 'AVIATION OR AEROSPACE PRODUCTS LEGAL LIABILITY', 1992, 1996, 'Aviation Products/ Airport Liabilities', 'Aviation'),
			('PZ', 'PRIZE INDEMNITY INCLUDING HOLE IN ONE', 1999, 9999, 'Contingency', 'Accident & Health'),
			('Q', 'CARGO WAR AND OR CONFISCATION RISKS ONLY', 1991, 9999, 'Marine War', 'Marine'),
			('QL', 'WAR ON LAND  IRO GOODS IN TRANSIT - Risk code retired with effect from 01/01/05: use risk code "WL"', 1997, 2004, 'Terrorism', 'Property (D&F)'),
			('QX', 'XOL CARGO WAR AND OR CONFISCATION RISKS ONLY - Risk code retired with effect from 01/01/05: use risk code "WX"', 1992, 2004, 'Marine War', 'Marine'),
			('RX', 'XOL HULLS OF AIRCRAFT WAR AND OR CONFIS RISKS ONLY ', 1992, 9999, 'Aviation War', 'Aviation'),
			('SA', 'SEAFARERS ABANDONMENT (authorised syndicates only)', 2014, 9999, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('SB', 'SURETY BOND REINSURANCE - From 01/01/05 also includes business previously coded "FC" or "FS" ', 1995, 9999, 'Political Risks, Credit & Financial Guarantee', 'Marine'),
			('SC', 'SPACE RISKS LAUNCH COMMISSIONING PERIOD AND TRANSPOND OP - From 01/01/08 also includes business previously coded "CX"', 1991, 9999, 'Space', 'Aviation'),
			('SL', 'SPACE RISK LIABILITY NO PRODUCTS LEGAL LIABILITY', 1991, 9999, 'Space', 'Aviation'),
			('SO', 'SPACE RISKS TRANSPONDER OPERATING', 1991, 9999, 'Space', 'Aviation'),
			('SR', 'AGG STOP LOSS AND XOL MARINE OUTWARD WHOLE ACCOUNT', 1991, 9999, 'Marine XL', 'Marine'),
			('SX', 'SPACE RISK LIABILITY EXCL AEROSPACE PRODUCTS', 1992, 1996, 'Space', 'Aviation'),
			('T', 'Vessels Excl. TLO IV LOH Containers Shipbuilding and WRO', 1991, 9999, 'Marine Hull', 'Marine'),
			('TC', 'COMMERCIAL RITC', 1997, 9999, 'RITC', 'Casualty'),
			('TE', 'MALICIOUS DAMAGE AND SABOTAGE - Risk code retired with effect from 01/01/2013: use risk codes "TO" "TU" "TW" or "WL"', 1991, 2012, 'Terrorism', 'Property (D&F)'),
			('TL', 'TEMPORARY LIFE AND PERMANENT HEALTH', 1991, 9999, 'Term Life', 'Life'),
			('TO', 'OVERSEAS STAND ALONE TERROR EXCL "1T" to "8T" & "1E" to "4E"', 1999, 9999, 'Terrorism', 'Property (D&F)'),
			('TR', 'ALL RISK PHYSICAL OR LOSS DAMAGE  DIRECT PPNL RI', 1991, 9999, 'Property pro rata', 'Property Treaty'),
			('TS', 'SHIPBUILDING EXCL ENERGY CONSTRUCTION', 2005, 9999, 'Marine Hull', 'Property (D&F)'),
			('TT', 'TITLE INSURANCE', 2015, 9999, 'Pecuniary', 'Accident & Health'),
			('TU', 'UK STAND ALONE TERRORISM WHICH IS NON POOL RE', 1999, 9999, 'Terrorism', 'Property (D&F)'),
			('TW', 'TERRORISM AND WAR ON LAND WHOLE ACCOUNT XOL TREATY RI INCL RI OF POOLS ', 2013, 9999, 'Terrorism', 'Property (D&F)'),
			('TX', 'XOL VESSELS SHIPBLDG ACV LOH INCL WAR EXCL WRO - From 01/01/05 also includes business previously coded "OX"', 1992, 9999, 'Marine XL', 'Marine'),
			('UA', 'NM GENERAL AND MISC LIABILITY ALL OTHER INCL USA - From 01/01/08 also includes business previously coded "PL" ', 1991, 9999, 'NM General Liability (US direct)', 'Casualty'),
			('UC', 'NM GENERAL AND MISC LIAB CLAIMS MADE INCL USA - From 01/01/08 also includes business previously coded "PL" ', 1991, 9999, 'NM General Liability (US direct)', 'Casualty'),
			('V', 'CARGO ALL RISKS INCL WAR EXCL WRO', 1991, 9999, 'Cargo', 'Marine'),
			('VL', 'LEGAL LIAB CARGO AND PROP INCL CCC OF ASSURED EXCL WRO', 1991, 9999, 'Cargo', 'Marine'),
			('VX', 'XOL Cargo Incl. War Excl. WRO', 1992, 9999, 'Marine XL', 'Marine'),
			('W', 'VESSELS WAR AND OR CONFISCATION EXCL BREACH VOYAGES', 1991, 9999, 'Marine War', 'Marine'),
			('W2', 'US WORKERS COMPENSATION - Risk code retired with effect from 01/01/2010: use risk codes "W5" or "W6" as appropriate', 2004, 2009, 'Employers Liability/ WCA (US)', 'Casualty Treaty'),
			('W3', 'UK EMPLOYERS LIABILITY', 2004, 9999, 'Employers Liability/ WCA (non-US)', 'Casualty'),
			('W4', 'INTL WORKERS COMP AND EMPLOYERS LIAB EXCL USA AND UK', 2004, 9999, 'Employers Liability/ WCA (non-US)', 'Casualty'),
			('W5', 'US WORKERS COMPENSATION PER PERSON EXPOSED', 2010, 9999, 'Employers Liability/ WCA (US)', 'Casualty Treaty'),
			('W6', 'US WORKERS COMPENSATION CATASTROPHE EXPOSED', 2010, 9999, 'Employers Liability/ WCA (US)', 'Casualty Treaty'),
			('WA', 'EXTENDED WARRANTY - From 01/01/05 also includes business previously coded "WS"', 1991, 9999, 'Extended Warranty', 'Property (D&F)'),
			('WB', 'VESSELS HULL WAR BREACH VOYAGES ONLY', 2005, 9999, 'Marine War', 'Marine'),
			('WC', 'WORKERS  COMPENSATION AND EMPLOYERS  LIABILITY - Risk code retired with effect from 01/01/2005: use risk codes "W2" to "W4" as appropriate  ', 1991, 2004, 'Employers Liability', 'Casualty'),
			('WL', 'WAR ON LAND - From 01/01/05 also includes business previously coded "QL"', 1997, 9999, 'Terrorism', 'Property (D&F)'),
			('WS', 'EXTENDED WARRANTY STOP LOSS - Risk code retired with effect from 01/01/05: use risk code "WA"', 1998, 2004, 'Extended Warranty', 'Property (D&F)'),
			('WX', 'XOL VESSELS  WAR AND OR CONFISCATION RISKS ONLY - From 01/01/05 also includes business previously coded "QX"', 1992, 9999, 'Marine War', 'Marine'),
			('X1', 'AVIATION EXCESS OF LOSS ON EXCESS OF LOSS - From 01/01/05 also includes business previously coded "XZ"', 1991, 9999, 'Aviation XL', 'Aviation'),
			('X2', 'MARINE XOL ON XOL INCL WAR', 1991, 9999, 'Marine XL', 'Marine'),
			('X3', 'NM PROP OR PECUNIARY LOSS XOL ON XOL RETROCESSION', 1991, 9999, 'Property Cat XL (Non-US)', 'Property Treaty'),
			('X4', 'NM LIABILITY EXCESS OF LOSS ON EXCESS OF LOSS - Risk code retired with effect from 01/01/05: use risk code "XL"', 1991, 2004, 'Casualty Treaty (non-US)', 'Casualty Treaty'),
			('X5', 'ENERGY ACCOUNT XOL ON XOL INCL WAR - Risk code retired with effect from 01/01/05: use risk code "XE"', 1991, 2004, 'Marine XL', 'Marine'),
			('XA', 'NM PROPERTY OR PECUNIARY LOSS WHOLE ACCOUNT XOL IN USA', 2008, 9999, 'Property Cat XL (US)', 'Property Treaty'),
			('XC', 'PER RISK EXCESS OF LOSS PROP PECUNIARY LOSS REINS', 1998, 9999, 'Property Risk XS', 'Property Treaty'),
			('XD', 'PER RISK EXCESS OF LOSS PROFESSIONAL INDEM REINS - Risk code retired with effect from 01/01/05: use risk code "XL"', 1998, 2004, 'Casualty Treaty (non-US)', 'Casualty Treaty'),
			('XE', 'ENERGY ACCOUNT XOL INCL WAR - From 01/01/05 also includes business previously coded "X5"', 1991, 9999, 'Marine XL', 'Marine'),
			('XF', 'NM LIABILITY EXCESS OF LOSS IN USA', 2010, 9999, 'Casualty Treaty (US)', 'Casualty Treaty'),
			('XG', 'NM LIABILITY EXCESS OF LOSS CLAIMS MADE OR LOSSES DISCOVERED EXCL USA ', 2010, 9999, 'Casualty Treaty (non-US)', 'Casualty Treaty'),
			('XH', 'NM LIABILITY EXCESS OF LOSS LOSSES OCCURRING EXCL USA ', 2012, 9999, 'Casualty Treaty (non-US)', 'Casualty Treaty'),
			('XJ', 'NM PROPERTY OR PECUNIARY LOSS WHOLE ACCOUNT XOL IN JAPAN ', 2008, 9999, 'Property Cat XL (Non-US)', 'Property Treaty'),
			('XL', 'NM LIABILITY EXCESS OF LOSS - Risk code retired with effect from 01/01/2010: use risk codes "XF" or "XG" as appropriate', 1991, 2009, 'Casualty Treaty (non-US)', 'Casualty Treaty'),
			('XM', 'MOTOR WHOLE ACCOUNT EXCESS OF LOSS ORIGINAL BUSINESS IN UK', 1991, 9999, 'Motor XL', 'Casualty Treaty'),
			('XN', 'MOTOR WHOLE ACCOUNT EXCESS OF LOSS ORIGINAL BUISNESS OUTSIDE UK', 2013, 9999, 'Motor XL', 'Casualty Treaty'),
			('XP', 'NM PROPERTY OR PECUNIARY LOSS WHOLE ACCOUNT XOL - Risk code being retired with effect from 01/01/2008: use risk codes "XA" "XU" "XJ" and "XR" ', 1991, 2007, 'Property Cat XL (Non-US)', 'Property Treaty'),
			('XR', 'NM PROPERTY OR PECUNIARY LOSS WHOLE ACCOUNT XOL IN REST OF WORLD ', 2008, 9999, 'Property Cat XL (Non-US)', 'Property Treaty'),
			('XT', 'MARINE WHOLE ACCOUNT XOL INCL WAR', 1991, 9999, 'Marine XL', 'Marine'),
			('XU', 'NM PROPERTY OR PECUNIARY LOSS WHOLE ACCOUNT XOL IN ALL OF EUROPE INCL UK', 2008, 9999, 'Property Cat XL (Non-US)', 'Property Treaty'),
			('XX', 'NON MARINE PROPERTY PECUNIARY LOSS LMX - Risk code retired with effect from 01/01/05: use risk codes "XC" "XP" or "X3" as appropriate', 1992, 2004, 'Property Cat XL (Non-US)', 'Property Treaty'),
			('XY', 'AVIATION WHOLE ACCOUNT XOL INCL WAR EXCL XOL ON XOL - From 01/01/05 also includes business previously coded "AR" and "AX" - From 01/01/08 also includes business previously coded "HX"', 1991, 9999, 'Aviation XL', 'Aviation'),
			('XZ', 'AVIATION XOL INCL XOL ON XOL AND WAR - Risk code retired with effect from 01/01/05: use risk code "X1"', 1991, 2004, 'Aviation XL', 'Aviation'),
			('Y1', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y2', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y3', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y4', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y5', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y6', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y7', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y8', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('Y9', 'AVIATION HULL AND LIAB PROPORT RI INCL WAR EXCL WRO', 1991, 2000, 'Airline/ General Aviation', 'Aviation'),
			('ZX', 'SPACE RISKS TRANSPONDER OPERATING', 1992, 1996, 'Space', 'Aviation')
		) p ([Code], [Description], [StartYear], [EndYear], [Section], [Type])

INSERT INTO [Peril] ([CodeSchemeId], [Level], [Description])
SELECT DISTINCT
 [CodeSchemeId] = 0,
	[Level] = 0,
 [Description] = [Class]
FROM @Lloyds

INSERT INTO [Peril] ([CodeSchemeId], [Level], [Description], [ParentId])
SELECT DISTINCT
 [CodeSchemeId] = 0,
	[Level] = 1,
	[Description] = l.[Section],
	[ParentId] = p.[Id]
FROM @Lloyds l
 JOIN [Peril] p ON l.[Class] = p.[Description]

INSERT INTO [Peril] ([CodeSchemeId], [Level], [Code], [Description], [ParentId])
SELECT
 [CodeSchemeId] = 0,
	[Level] = 2,
	[Code] = l.[Code],
	[Description] = l.[Description],
	[ParentId] = p1.[Id]
FROM @Lloyds l
 JOIN [Peril] p1 ON l.[Section] = p1.[Description]
	JOIN [Peril] p2 ON p1.[ParentId] = p2.[Id] AND l.[Class] = p2.[Description]
GO

CREATE TABLE [ClassOfBusinessPeril] (
		[ClassOfBusinessId] NCHAR(3) NOT NULL,
  [CodeSchemeId] INT NOT NULL,
		[Level] AS CONVERT(TINYINT, 0) PERSISTED,
		[PerilId] INT NOT NULL,
		CONSTRAINT [PK_ClassOfBusinessPeril] PRIMARY KEY CLUSTERED ([ClassOfBusinessId], [PerilId]),
		CONSTRAINT [FK_ClassOfBusinessPeril_ClassOfBusiness] FOREIGN KEY ([ClassOfBusinessId]) REFERENCES [ClassOfBusiness] ([Id]),
		CONSTRAINT [FK_ClassOfBusinessPeril_Peril] FOREIGN KEY ([CodeSchemeId], [Level], [PerilId]) REFERENCES [Peril] ([CodeSchemeId], [Level], [Id])
 )
GO

INSERT INTO [ClassOfBusinessPeril] ([ClassOfBusinessId], [CodeSchemeId], [PerilId])
SELECT cob.[Id], 0, per.[Id]
FROM (VALUES
   (N'PRP', N'Property (D&F)'),
			(N'PRP', N'Property Treaty'),
			(N'PRP', N'Casualty'),
			(N'PRP', N'Energy'),
			(N'MTR', N'UK Motor'),
			(N'MTR', N'Overseas Motor'),
			(N'MAR', N'Marine'),
			(N'MAR', N'Energy'),
			(N'AVI', N'Aviation'),
			(N'TRV', N'Accident & Health'),
			(N'TRV', N'Property (D&F)'),
			(N'ACC', N'Accident & Health'),
			(N'CAS', N'Energy'),
			(N'CAS', N'Casualty'),
			(N'CAS', N'Casualty Treaty'),
			(N'LIF', N'Life')
  ) cp ([ClassOfBusinessId], [Peril])
	LEFT JOIN [ClassOfBusiness] cob ON cp.[ClassOfBusinessId] = cob.[Id]
	LEFT JOIN [Peril] per ON per.[CodeSchemeId] = 0 AND per.[Level] = 0 AND cp.[Peril] = per.[Description]
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

INSERT INTO [UserRoleEnum] ([Description], [Sort])
VALUES
 (N'Claim Handler', 1),
	(N'Claim Supervisor', 2)
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

CREATE TABLE [LossFund] (
  [Id] INT NOT NULL IDENTITY (1, 1),
		[TPAId] INT NOT NULL,
		[Name] NVARCHAR(255) NOT NULL,
		[DisplayName] AS [Name] + N' ' + QUOTENAME([CurrencyId], N'[') PERSISTED,
		[BankCode] NVARCHAR(50) NOT NULL,
		[AccountNum] NVARCHAR(50) NOT NULL,
		[AccountNumMasked] AS REPLICATE(N'X', LEN([AccountNum]) - 4) + RIGHT([AccountNum], 4) PERSISTED,
		[CurrencyId] NCHAR(3) NOT NULL,
		[Active] BIT NOT NULL CONSTRAINT [DF_LossFund_Active] DEFAULT (1),
		CONSTRAINT [PK_LossFund] PRIMARY KEY CLUSTERED ([TPAId], [Id], [CurrencyId]),
		CONSTRAINT [UQ_LossFund_Id] UNIQUE ([Id]),
		CONSTRAINT [UQ_LossFund_Name] UNIQUE ([TPAId], [Name]),
		CONSTRAINT [FK_LossFund_Company_TPAId] FOREIGN KEY ([TPAId]) REFERENCES [Company] ([Id]),
		CONSTRAINT [CK_LossFund_Id] CHECK ([Id] > 0)
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
		[CodeSchemeId] INT NOT NULL CONSTRAINT [DF_Binder_CodeSchemeId] DEFAULT (0),
		[RisksTerritoryId] INT NOT NULL CONSTRAINT [DF_Binder_RisksTerritoryId] DEFAULT (0),
		[InsuredsTerritoryId] INT NOT NULL CONSTRAINT [DF_Binder_InsuredsTerritoryId] DEFAULT (0),
		[LimitsTerritoryId] INT NOT NULL CONSTRAINT [DF_Binder_LimitsTerritoryId] DEFAULT (0),
		CONSTRAINT [PK_Binder] PRIMARY KEY CLUSTERED ([Id]),
		CONSTRAINT [UQ_Binder_UMR] UNIQUE ([UMR]),
		CONSTRAINT [UQ_Binder_CodeSchemeId] UNIQUE ([Id], [CodeSchemeId]),
		CONSTRAINT [FK_Binder_Company_CoverholderId] FOREIGN KEY ([CoverholderId]) REFERENCES [Company] ([Id]),
		CONSTRAINT [FK_Binder_Company_BrokerId] FOREIGN KEY ([BrokerId]) REFERENCES [Company] ([Id]),
		CONSTRAINT [FK_Binder_CodeScheme] FOREIGN KEY ([CodeSchemeId]) REFERENCES [CodeScheme] ([Id]),
		CONSTRAINT [FK_Binder_Territory_RisksTerritoryId] FOREIGN KEY ([RisksTerritoryId]) REFERENCES [Territory] ([Id]),
		CONSTRAINT [FK_Binder_Territory_InsuredsTerritoryId] FOREIGN KEY ([InsuredsTerritoryId]) REFERENCES [Territory] ([Id]),
		CONSTRAINT [FK_Binder_Territory_LimitsTerritoryId] FOREIGN KEY ([LimitsTerritoryId]) REFERENCES [Territory] ([Id]),
		CONSTRAINT [CK_Binder_Id] CHECK ([Id] > 0),
		CONSTRAINT [CK_Binder_ExpiryDate] CHECK ([ExpiryDate] >= [InceptionDate])
 )
GO

CREATE TABLE [BinderSection] (
		[Id] INT NOT NULL IDENTITY (1, 1),
		[Title] NVARCHAR(255) NOT NULL,
		[Narrative] NVARCHAR(max) NULL,
  [BinderId] INT NOT NULL,
		[CodeSchemeId] INT NOT NULL,
		[PerilId] INT NOT NULL,
  [DefaultLossFundId] INT NULL,
		CONSTRAINT [PK_BinderSection] PRIMARY KEY CLUSTERED ([BinderId], [Id]),
		CONSTRAINT [UQ_BinderSection_Id] UNIQUE ([Id]),
		CONSTRAINT [CK_BinderSection_Id] CHECK ([Id] > 0),
 )
GO

DECLARE @name SYSNAME, @SQL NVARCHAR(max)
DECLARE MyCursor CURSOR FOR SELECT [name] FROM sys.tables WHERE [name] IN (N'Company', N'LossFund', N'Binder')
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


SELECT N'Is table ' + QUOTENAME(t.[name], N'[') + N' missing a check constraint on column [Id]?'
FROM sys.tables t
 JOIN sys.columns c ON t.[object_id] = c.[object_id]
	JOIN sys.types st ON c.[system_type_id] = st.[system_type_id] AND c.[user_type_id] = st.[user_type_id]
	LEFT JOIN sys.check_constraints ck ON t.[object_id] = ck.[parent_object_id] AND ck.[definition] LIKE N'%[[]Id]%>%0%'
WHERE t.[name] <> N'User' 
 AND c.[name] = N'Id'
 AND st.[name] = N'int'
	AND ck.[object_id] IS NULL
