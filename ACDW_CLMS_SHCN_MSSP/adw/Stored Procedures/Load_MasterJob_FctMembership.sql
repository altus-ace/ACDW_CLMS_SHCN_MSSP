

CREATE PROCEDURE [adw].[Load_MasterJob_FctMembership](
		         @MbrYear SmallInt
				 ,@MbrMonth TinyINT
				 ,@RwEffectiveDate DATE
				 ,@RwExpirationDate DATE
				 ,@MemberCurrentEffectiveDate DATE
				 ,@MemberCurrentExpirationDate Date
				 ,@LoadDate DATE
				 ,@ClientID INT
				 ,@DataDate DATE
				 ,@DemographicDataDate DATE
				 ,@LoadType Varchar(10)
				 ,@EffectiveDate DATE
				 )
AS


				  DECLARE @MbrMonths TINYINT = @MbrMonth 
				  DECLARE @MbrYears SMALLINT = @MbrYear				  
				  DECLARE @RwEffectiveDates  DATE = @RwEffectiveDate
				  DECLARE @RwExpirationDates  DATE = @RwExpirationDate 
				  DECLARE @MemberCurrentEffectiveDates DATE = @MemberCurrentEffectiveDate
				  DECLARE @MemberCurrentExpirationDates DATE = @MemberCurrentExpirationDate

				  --Declare @batchDate Date	= '2019-03-17';    
				  DECLARE @InsertCount INT;
				  DECLARE @SourceCount INT;
				  DECLARE @QueryCount INT				= 0;    
				  DECLARE @Audit_ID INT				= 0;
				  DECLARE @ClientKey INT		= (SELECT ClientKey FROM Lst.List_client WHERE ClientShortName = 'SHCN_MSSP');
				  DECLARE @qmFx VARCHAR(100);
				  DECLARE @Destination VARCHAR(100)	;
				  DECLARE @JobName VARCHAR(100)	;
				  DECLARE @StartTime DATETIME2;
				  DECLARE @OutputTbl Table (ID INT);
				  INSERT INTO @OutputTbl (ID)
				  SELECT StgFctMembershipSkey FROM ast.StgFctMembership
				  SELECT @SourceCount = COUNT(*) FROM @OutputTbl 
BEGIN

	SET @StartTime = GETDATE();	   
	SET @qmFx = '[ast].[Load_StgFctMembership]'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXECUTE [ast].[Pls_01_SHCN_MSSPMembership]	@MbrYear,@MbrMonth ,@RwEffectiveDate	,@RwExpirationDate, @MemberCurrentEffectiveDate, @MemberCurrentExpirationDate,@DataDate
												,@DemographicDataDate
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  


END

BEGIN

		EXECUTE [ast].[pls_02_SHCN_MSSPMbrMembershipRunMPI]@ClientKey,@EffectiveDate

END

BEGIN

	
	SET @StartTime = GETDATE();	   
	SET @qmFx = '[ast].[Load_UpdateStgFctMembership]'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXECUTE [ast].[Pts_03_Shcn_MsspMembershipTransformUpdates]@EffectiveDate
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR; 


END

BEGIN
		--Process Load DIMs
		EXECUTE	[adw].[PdwMbr_01_LoadHistory]@DaTaDate,@LoadType,@ClientID;
		EXECUTE	[adw].[PdwMbr_02_LoadMember]@DaTaDate,@LoadType,@ClientID,@EffectiveDate;
		EXECUTE	[adw].[PdwMbr_03_LoadDemo]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_04_LoadPhone]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_05_LoadAddress]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_06_LoadPcp]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_08_LoadPlan]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_09_LoadCSPlan]@DaTaDate,@ClientID;
		EXECUTE	[adw].[PdwMbr_11_LoadEmail] @DaTaDate,@ClientID;
	
	END

BEGIN
	
	 ---Process from Dims into DW
	EXECUTE [adw].[p_Pdw_Master_ProcessFctMembership]  @EffectiveDate,@ClientID, @DataDate ,@LoadDate 

	/*
	--Retired
	DECLARE @OutputTbl2 Table (ID INT);
	DECLARE @SourceCount1 INT;
	DECLARE @Destination1 VARCHAR(100)
	INSERT INTO @OutputTbl2 (ID)
	SELECT FctMembershipSkey FROM adw.FctMembership
	SELECT @SourceCount1 = COUNT(*) FROM @OutputTbl2


	SET @StartTime = GETDATE();	   
	SET @qmFx = '[adw].[Load_FctMembership]'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXECUTE [adw].[Pdw_Load_FctMembership]@ClientKey	
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount1, @DestinationCount = @SourceCount1,@ErrorCount = @@ERROR; 

	*/

END

BEGIN
		---Updating staging
		EXECUTE adw.Pupd_LineageKeysInAdiAndStaging @EffectiveDate
END



	BEGIN

		EXECUTE [adw].[pdwMbr_31_Load_MemberMonth_ConsolidationMSSP]@LoadDate,@ClientID

	END

