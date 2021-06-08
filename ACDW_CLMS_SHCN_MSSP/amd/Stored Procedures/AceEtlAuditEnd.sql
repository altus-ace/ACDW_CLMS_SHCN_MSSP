CREATE PROCEDURE [amd].[AceEtlAuditEnd](
      @audit_id int
    , @ActionStopTime DATETIME 
    , @SourceCount int = 0
    , @DestinationCount int = 0
    , @ErrorCount int = 0    
    , @JobStatus tinyInt = 2
	)
AS 
BEGIN

EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Close] @audit_id, @ActionStopTime, @SourceCount, @DestinationCount,  @ErrorCount, @JobStatus    

 
END
