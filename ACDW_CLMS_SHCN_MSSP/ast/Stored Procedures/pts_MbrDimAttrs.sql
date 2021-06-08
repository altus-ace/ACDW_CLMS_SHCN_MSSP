

CREATE PROCEDURE [ast].[pts_MbrDimAttrs]
AS

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN

-- (A)  Update MPIs 
		--Update stg table with the mstrmrnkeys
BEGIN
		UPDATE		[ast].[MbrModelMbrData]
		SET			MstrMrnKey = o.MstrMrnKey--SELECT o.MstrMrnKey,stg.Ace_ID,stg.ClientMemberKey,o.ClientMemberKey,o.ClientKey
		FROM		[ast].[MbrModelMbrData] stg   --  select * from ast.[MbrModelMbrData] stg
		LEFT JOIN	AceMPI.adw.MPI_ClientMemberAssociationHistoryODS o
		ON			stg.ClientSubscriberId = o.ClientMemberKey
END

--Ai
BEGIN
		UPDATE		[ast].[MbrModelMbrData]
		SET			mbrFirstName = [adi].[udf_ConvertToCamelCase](MbrFirstName)
					,MbrLastName = [adi].[udf_ConvertToCamelCase](mbrLastName) --select Firstname,LastName from ast.StgFctMembership
		

END


--(B) Update Transform Gender Column
BEGIN
		UPDATE		ast.MbrModelMbrData
		SET			mbrGENDER = 'M'
		WHERE		mbrGENDER = '1'
		
		UPDATE		ast.MbrModelMbrData
		SET			mbrGENDER = 'F'
		WHERE		mbrGENDER LIKE '2'
END

--(C) Update Member Demographics
  
BEGIN
--A
;WITH CTE_DemoUpdate
AS
(
SELECT 			MedicareBeneficiaryID
				,MemberHomeAddress			= (MailingAddress01TXT) 
				,MemberHomeAddress1			= (src.MailingAddress02TXT)
				,MemberHomeCity				= (src.CityNM)
				,MemberHomeState			= (src.StateCD)
				,MemberHomeZip				= (src.PostalZipCD)
				,MemberMailingZip			= (src.PostalZipCD)
				,MemberMailingAddress		= (src.MailingAddress01TXT)
				,MemberMailingAddress1		= (src.MailingAddress02TXT)
				,MemberMailingCity			= (src.CityNM)
				,MemberMailingState		    = (src.StateCD)
				,CountyNumber			    = (src.FIPSStateCD)


FROM			[ast].[MbrModelPhoneAddEmail] trg
LEFT JOIN		[adi].[Steward_MSSPBeneficiaryDemographic] src
ON				trg.ClientMemberKey = src.MedicareBeneficiaryID
WHERE			src.MedicareBeneficiaryID IS NOT NULL 
AND				src.DataDate = (SELECT MAX(Datadate) FROM [adi].[Steward_MSSPBeneficiaryDemographic])

)

UPDATE			ast.MbrModelPhoneAddEmail
SET				MemberHomeAddress = [adi].[udf_ConvertToCamelCase](src.MemberHomeAddress)
				,MemberHomeAddress1 = [adi].[udf_ConvertToCamelCase](src.MemberHomeAddress1)
				,MemberHomeCity = [adi].[udf_ConvertToCamelCase](src.MemberHomeCity)
				,MemberHomeState = src.MemberHomeState
				,MemberHomeZip = [adi].[udf_ConvertToCamelCase](src.MemberHomeZip)
				,MemberMailingZip = [adi].[udf_ConvertToCamelCase](src.MemberMailingZip)
				,MemberMailingAddress = [adi].[udf_ConvertToCamelCase](src.MemberMailingAddress)
				,MemberMailingAddress1 = [adi].[udf_ConvertToCamelCase](src.MemberMailingAddress1)
				,MemberMailingCity = [adi].[udf_ConvertToCamelCase](src.MemberMailingCity)
				,MemberMailingState = src.MemberMailingState
				,CountyNumber = [adi].[udf_ConvertToCamelCase](src.CountyNumber)
FROM			ast.MbrModelPhoneAddEmail trg
JOIN			CTE_DemoUpdate src
ON				trg.ClientMemberKey = src.MedicareBeneficiaryID

--B
--Load DOD
UPDATE			ast.MbrModelMbrData
SET				mbrDOD = src.DeathDTS
FROM			[ast].[MbrModelMbrData] trg
LEFT JOIN		[adi].[Steward_MSSPBeneficiaryDemographic] src
ON				trg.ClientSubscriberId = src.MedicareBeneficiaryID
WHERE			src.MedicareBeneficiaryID IS NOT NULL 
AND				src.DataDate IN (SELECT MAX(DataDate) FROM adi.[Steward_MSSPBeneficiaryDemographic])

END
	
--D Update Provider Details, TIN, POD, TIN NAME, Provider Name *** LST_LIST_PCP NEEDS TO UPDATE

BEGIN
		UPDATE		ast.MbrModelMbrData
		SET			ProviderPOD = [adi].[udf_ConvertToCamelCase](PCP_POD)
					,ProviderChapter = [adi].[udf_ConvertToCamelCase](PCP_POD)
					,ProviderPracticeName = [adi].[udf_ConvertToCamelCase](PCP_PRACTICE_TIN_NAME)
					,ProviderFirstName = [adi].[udf_ConvertToCamelCase](PCP_FIRST_NAME)
					,ProviderLastName = [adi].[udf_ConvertToCamelCase](PCP_LAST_NAME)
					,ProviderMI = [adi].[udf_ConvertToCamelCase](PCP_MI)
					,ProviderSpecialty = [adi].[udf_ConvertToCamelCase](PRIM_SPECIALTY)
		FROM		ast.MbrModelMbrData trg
		JOIN		lst.List_PCP src
		ON			trg.prvNPI = src.PCP_NPI 
		
		UPDATE		ast.MbrModelPhoneAddEmail
		SET			ProviderAddressLine1 = [adi].[udf_ConvertToCamelCase](PCP__ADDRESS)
					,ProviderAddressLine2 = [adi].[udf_ConvertToCamelCase](PCP__ADDRESS2)
					,ProviderCity = [adi].[udf_ConvertToCamelCase](PCP_CITY)
					,ProviderZip = [adi].[udf_ConvertToCamelCase](PCP_ZIP)
					,ProviderPhone = [adi].[udf_ConvertToCamelCase](PCP_PHONE)  --select distinct ClientMemberKey,ClientSubscriberId, prvNPI,PCP_NPI
		FROM		ast.MbrModelPhoneAddEmail ad
		JOIN		ast.MbrModelMbrData mbr
		ON			ad.ClientMemberKey = mbr.ClientSubscriberId
		JOIN		lst.List_PCP src
		ON			mbr.prvNPI = src.PCP_NPI 

		select * from ast.MbrModelPhoneAddEmail 

		select * from adw.FctMembership where MbrYear = 2020 and MbrMonth = 10
		
	
--E Update members phone no --Yet to identify source
/*


UPDATE			ast.MbrModelPhoneAddEmail
SET				MemberPhone = src.PhoneNumber
FROM			ast.MbrModelPhoneAddEmail trg
JOIN			adw.MbrPhone src
ON				trg.ClientMemberKey = src.ClientMemberKey
WHERE			PhoneType = 1 
AND				trg.DataDate = '2020-07-01'

UPDATE			ast.MbrModelPhoneAddEmail
SET				MemberCellPhone = PhoneNumber
FROM			ast.MbrModelPhoneAddEmail trg
JOIN			adw.MbrPhone src
ON				trg.ClientMemberKey = src.ClientMemberKey
WHERE			PhoneType = 2 
AND				trg.DataDate = '2020-07-01'


UPDATE			ast.MbrModelPhoneAddEmail
SET				MemberHomePhone = PhoneNumber
FROM			ast.MbrModelPhoneAddEmail trg
JOIN			adw.MbrPhone src
ON				trg.ClientMemberKey = src.ClientMemberKey
WHERE			PhoneType = 3 
AND				trg.DataDate = '2020-07-01'

*/
--F begin tran --rollback MembershipBeneficiaryCrossReference
BEGIN
UPDATE			ast.MbrModelMbrData
SET				ClientSubscriberId = CurrentClientMemberKey
FROM			ast.MbrModelMbrData a
JOIN			[adw].[MbrClientMemberKeyHistory] b
on				a.ClientSubscriberId = b.PreviousClientMemberKey --COMMIT

END


END

COMMIT
END TRY
BEGIN CATCH
EXECUTE [dbo].[usp_QM_Error_handler]
END CATCH







