
CREATE PROCEDURE [adw].[z_sp_Drop_Create_Load_tmpActiveMembers]
AS    
BEGIN
    SET NOCOUNT ON;
    IF OBJECT_ID('adw.tmp_Active_Members', 'U') IS NOT NULL
        DROP TABLE adw.tmp_Active_Members;

CREATE TABLE adw.tmp_Active_Members (
	[URN]						INT IDENTITY NOT NULL,
	[ClientKey]					INT NOT NULL,
	[ACE_ID]					[VARCHAR] (50) NOT NULL,
	[ClientMemberKey]			[VARCHAR] (50) NOT NULL,
	[AltMemberID]				[VARCHAR] (50) NOT NULL,
	[Product]					[VARCHAR](50) NULL,
	[MainPlan]					[VARCHAR](50) NULL,
	[SubPlan]					[VARCHAR](100) NULL,
	[FirstName]					[VARCHAR](50) NULL,
	[LastName]					[VARCHAR](50) NULL,
	[Gender]					[VARCHAR](1) NULL,				-- M-male, F-female
	[Member_Address]			[VARCHAR](100) NULL,
	[Member_Address2]			[VARCHAR](50) NULL,
	[Member_City]				[VARCHAR](100) NULL,
	[Member_State]				[VARCHAR](20) NULL,
	[Member_Phone]				[VARCHAR](25) NULL,
	[Member_Phone2]				[VARCHAR](25) NULL,
	[Member_Zip]				[VARCHAR](5) NULL,
	[Member_Pod]				[VARCHAR](5) NULL,
	[DOB]						DATE NULL,
	[DOD]						DATE NULL,
	[CurrentAge]				INT NULL,
	[Exclusion]					[VARCHAR](1) NULL DEFAULT 'N',
	[Mbr_Type]					[VARCHAR](1) NULL,				-- A-assigned, U-unassigned 
	[Lst12Mths_AWV]				INT NULL DEFAULT 0,
	[Lst12Mths_PCP]				INT NULL DEFAULT 0,
	[Lst12Mths_Specialist]		INT NULL DEFAULT 0,
	[Lst12Mths_IP]				INT NULL DEFAULT 0,
	[Lst12Mths_ER]				INT NULL DEFAULT 0,
	[Lst12Mths_RA]				INT NULL DEFAULT 0,
	[CurrentGaps]				INT NULL DEFAULT 0, -- All Gaps
	[ContractedGaps]			INT NULL DEFAULT 0, -- Gaps Contracted
	[AHRGaps]					INT NULL DEFAULT 0, -- Gaps to be displayed on AHR
	[Demo_RiskScore]			[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[HCC_RiskScore]				[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[Churn_RiskScore]			[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[MEngagement_RiskScore]		[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[PEngagement_RiskScore]		[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[Alt1_RiskScore]			[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[Alt2_RiskScore]			[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[Tot_RiskScore]				[DECIMAL](5, 4) NULL  DEFAULT 0.00,
	[Tot_RiskBand]				[INT] NULL DEFAULT 0,
	[AgeBand]					[INT] NULL DEFAULT 0,
	[MortalityFlg]				INT NULL DEFAULT 0,		-- ESRD, Hospice
	[TIN]						[VARCHAR](50) NULL,
	[TIN_NAME]					[VARCHAR](100) NULL, 
	[NPI]						[VARCHAR](50) NULL,
	[NPI_NAME]					[VARCHAR](100) NULL,
	[MBR_YEAR]					INT NULL DEFAULT YEAR(GETDATE()),
    [MBR_QTR]					INT NULL DEFAULT DATEPART(Q,GETDATE()),
	[MBR_MTH]					INT NULL DEFAULT MONTH(GETDATE()),
    [LOAD_DATE]					DATE NULL,
    [LOAD_USER]					[VARCHAR](50) NULL,
	[CreateDate]				[datetime2](7) NOT NULL,
	[CreateBy]					[varchar](50) NOT NULL,
	[LastUpdateDate]			[datetime2](7) NOT NULL,
	[LastUpdateBy]				[varchar](50) NOT NULL,
	[AdiTableName]				[varchar](100) NULL,
	[SrcFileName]				[varchar](100) NULL,
	[EffectiveDate]				[date] NULL,
	[ExpirationDate]			[date] NULL


) ON [PRIMARY]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (sysdatetime()) FOR [LOAD_DATE]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (suser_sname()) FOR [LOAD_USER]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (sysdatetime()) FOR [CreateDate]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (suser_sname()) FOR [CreateBy]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (sysdatetime()) FOR [LastUpdateDate]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (suser_sname()) FOR [LastUpdateBy]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))) FOR [EffectiveDate]
ALTER TABLE [adw].[tmp_Active_Members] ADD  DEFAULT (EOMONTH (GETDATE())) FOR [ExpirationDate]


INSERT INTO [adw].[tmp_Active_Members]
           ([ClientKey]
           ,[ACE_ID]
           ,[ClientMemberKey]
           ,[AltMemberID]
           ,[Product]
           ,[MainPlan]
           ,[SubPlan]
           ,[FirstName]
           ,[LastName]
           ,[Gender]
		   ,[Member_Address]	
		   ,[Member_Address2]	
		   ,[Member_City]		
		   ,[Member_State]		
		   ,[Member_Phone]		
           ,[Member_Phone2]
           ,[Member_Zip]
           ,[Member_Pod]
           ,[DOB]
           ,[DOD]
           ,[CurrentAge]
           ,[Exclusion]
           ,[Mbr_Type]
		   ,[MBR_YEAR]
		   ,[MBR_QTR]
		   ,[MBR_MTH]
		   ,[TIN] 
		   ,[TIN_NAME] 
		   ,[NPI] 
		   ,[NPI_NAME] 
		   ,[SrcFileName]				
			)
	SELECT 
			[ClientKey]							
			,[Ace_ID]							
			,[ClientMemberKey]					
			,[MBI]								
			,[LOB]								
			,[PlanID]							
			,[SubgrpID]							
			,[FirstName]						
			,[LastName]							
			,[Gender]							
			,[MemberMailingAddress]				
			,[MemberMailingAddress1]			
			,[MemberMailingCity]				
			,[MemberMailingState]				
			,[MemberPhone]
			,[MemberCellPhone]									
			,[MemberHomeZip]					
			,[POD]								
			,[DOB]								
			,[DOD]	
			,[CurrentAge]
			,'N'							
			,'A'								
			,[MbrYear]							
			,CASE WHEN [MbrMonth] IN (1,2,3) THEN 1
				WHEN [MbrMonth] IN (4,5,6) THEN 2
				WHEN [MbrMonth] IN (7,8,9) THEN 3
				WHEN [MbrMonth] IN (10,11,12) THEN 4
				END							
			,[MbrMonth]							
			,[PcpPracticeTIN]					
			,[ProviderPracticeName]				
			,[NPI]								
			,CONCAT([ProviderFirstName],' ',[ProviderLastName])						
			,'adw.fctMembership'
	FROM [adw].[2020_tvf_Get_ActiveMembersFull]	(GETDATE())
END;												


/***
EXEC [adw].[sp_Drop_Create_Load_tmpActiveMembers]

SELECT *
FROM adw.tmp_Active_Members
***/