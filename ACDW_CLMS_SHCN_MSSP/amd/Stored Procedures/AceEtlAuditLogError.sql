CREATE PROCEDURE [amd].[AceEtlAuditLogError](
     @EtlAuditPKey int,
	 @Error varchar(1000),
	 @CreateBy varchar(20) 
	)
AS 
BEGIN

EXEC [AceMetaData].[amd].[sp_AceEtlAuditLogError] @EtlAuditPKey, @Error, @CreateBy



END
