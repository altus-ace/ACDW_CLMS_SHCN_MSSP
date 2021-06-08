
CREATE PROCEDURE [amd].[sp_AceEtlAuditClose]
	 @AuditId int
    , @ActionStopTime DATETIME 
    , @SourceCount int = 0
    , @DestinationCount int = 0
    , @ErrorCount int = 0    
    , @JobStatus tinyInt = 2
AS
    /* this is a pass through function creating a single dependency on the external db AceMetaData */    
	 EXEC AceMetaData.amd.sp_AceEtlAudit_Close
		@AuditID		   = @AuditID
	   , @ActionStopTime   = @ActionStopTime 
	   , @SourceCount	   = @SourceCount 
	   , @DestinationCount = @DestinationCount 
	   , @ErrorCount	   = @ErrorCount 
	   , @JobStatus	   = @JobStatus
	   ;
	 
	/**/
RETURN 0
