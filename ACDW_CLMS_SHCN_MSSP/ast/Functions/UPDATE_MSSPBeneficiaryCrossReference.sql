

CREATE FUNCTION ast.UPDATE_MSSPBeneficiaryCrossReference(@DataDate Date)

RETURNS TABLE 


AS


RETURN



	SELECT		Distinct b.SUBSCRIBER_ID--,DataDate 
				,CurrentHealthInsuranceClaimNBR
				,PreviousHealthInsuranceClaimNBR
				,PreviousHealthInsuranceClaimNumberStartDTS
				,PreviousHealthInsuranceClaimNumberEndDTS
	FROM		[adi].[Steward_MSSPBeneficiaryCrossReference] a
	JOIN		[adw].Claims_Headers b
	ON			SUBSCRIBER_ID = CurrentHealthInsuranceClaimNBR 
	WHERE		SUBSCRIBER_ID is not null
	--AND			SUBSCRIBER_ID = CurrentHealthInsuranceClaimNBR
	
	