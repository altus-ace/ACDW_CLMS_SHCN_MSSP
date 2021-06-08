
CREATE  PROCEDURE [amd].[sp_AceEtlAuditOpen](
	 @AuditID INT output
	, @AuditStatus SmallInt= 0
	, @JobType SmallInt = 2
	, @ClientKey INT 
	, @JobName VARCHAR(200) = 'No Job Name'
	, @ActionStartTime DATETIME2 
	, @InputSourceName VARCHAR(200) = 'No Input Source Name Provided'	
	, @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	, @ErrorName VARCHAR(200) = 'No Error Name Provided'	
	)
AS	
    /* this is a pass through function creating a single dependency on the external db AceMetaData */
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open 
		    @AuditID		  = @AuditID OUTPUT
		  , @AuditStatus	  = @AuditStatus
		  , @JobType		  = @JobType
		  , @ClientKey		  = @ClientKey
		  , @JobName		  = @JobName
		  , @ActionStartTime  = @ActionStartTime
		  , @InputSourceName  = @InputSourceName
		  , @DestinationName  = @DestinationName
		  , @ErrorName		  = @ErrorName
		  ;
	
		  /**/

RETURN 0
