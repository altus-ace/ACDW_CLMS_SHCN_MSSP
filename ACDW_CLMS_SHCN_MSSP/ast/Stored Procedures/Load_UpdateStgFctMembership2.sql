
CREATE PROCEDURE [ast].[Load_UpdateStgFctMembership2]
AS

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRY 
BEGIN TRAN
BEGIN
-- (A)  Update MPIs 
		--Update stg table with the mstrmrnkeys
		BEGIN
				UPDATE		[ast].[StgFctMembership]
				SET			Ace_ID = o.MstrMrnKey--SELECT o.MstrMrnKey,stg.Ace_ID,stg.ClientMemberKey,o.ClientMemberKey,o.ClientKey
				FROM		[ast].[StgFctMembership] stg
				LEFT JOIN	AceMPI.adw.MPI_ClientMemberAssociationHistoryODS o
				ON			stg.ClientMemberKey = o.ClientMemberKey
				WHERE		MbrYear = 2019
		END
		
		
		--(B) Update Transform Gender Column
		BEGIN
				UPDATE		ast.StgFctMembership
				SET			Gender = 'M'
				WHERE		Gender = '1'
				
				UPDATE		ast.StgFctMembership
				SET			Gender = 'F'
				WHERE		Gender LIKE '2' 
		END
		
		--(Ci) Update NPI and TIN By Pcp_List
		BEGIN
		IF OBJECT_ID('tempdb..#NpiByPcpList') IS NOT NULL DROP TABLE #NpiByPcpList
		CREATE TABLE #NpiByPcpList (MedicareBeneficiaryID VARCHAR(50),PCP_NPI VARCHAR(50), NPI VARCHAR(50),PCP_PRACTICE_TIN VARCHAR(50))
		
		INSERT INTO #NpiByPcpList
		SELECT			 MedicareBeneficiaryID  
						,NPI = MAX(PCP_NPI) 
						,MAX(NPI) NPI
						,MAX(PCP_PRACTICE_TIN) PCP_PRACTICE_TIN
		FROM			lst.List_PCP lst  
		JOIN			adi.Steward_MSSPAnnualMembershipTIN_NPICrosswalk_HALRBASE adi 
		ON				lst.PCP_NPI = adi.NPI  
		WHERE			YearNBR = 2019
		GROUP BY		MedicareBeneficiaryID
				
		UPDATE			ast.StgFctMembership  
		SET				NPI = tbl.NPI
						,PcpPracticeTIN = PCP_PRACTICE_TIN--SELECT PCP_PRACTICE_TIN,PcpPracticeTIN, stg.NPI,PCP_NPI,mbryear
		FROM			ast.StgFctMembership stg  
		JOIN			#NpiByPcpList tbl  
		ON				stg.ClientMemberKey = tbl.MedicareBeneficiaryID 
		WHERE			stg.MbrYear = 2019
		
		END
		
		--(Cii) Update NPI By NPICrossWalk
		BEGIN
		IF OBJECT_ID('tempdb..#OutStdPCP') IS NOT NULL DROP TABLE #OutStdPCP
		CREATE TABLE #OutStdPCP (ClientMemberKey VARCHAR(50),trgNPI VARCHAR(50), srcNPI VARCHAR(50), srcTIN VARCHAR(50),trgTIN VARCHAR(50))
		INSERT INTO #OutStdPCP  
		SELECT				ClientMemberKey      
							,trg.NPI
							,NPI = MAX(src.NPI)
							,TIN = MAX(src.TIN)
							,PcpPracticeTIN
		FROM				ast.StgFctMembership trg  
		JOIN				adi.Steward_MSSPAnnualMembershipTIN_NPICrosswalk_HALRBASE src 
		ON					trg.ClientMemberKey = src.MedicareBeneficiaryID
		WHERE				MbrYear = 2019  
		AND					trg.NPI = ''  
		AND					trg.PcpPracticeTIN = ''
		GROUP BY			ClientMemberKey,trg.NPI,PcpPracticeTIN
		--SELECT * FROM #OutStdPCP
		UPDATE				ast.StgFctMembership  
		SET					NPI = tmp.srcNPI
							,PcpPracticeTIN = srcTIN
		FROM				ast.StgFctMembership ast  
		JOIN				#OutStdPCP tmp  
		ON					ast.ClientMemberKey = tmp.ClientMemberKey  
		WHERE				MbrYear = 2019 
		AND					ast.NPI = ''
		AND					ast.PcpPracticeTIN = ''
			
		END
		
		
		
		END
		
		COMMIT
		END TRY
		BEGIN CATCH
		EXECUTE [dbo].[usp_QM_Error_handler]
		END CATCH
		
		


	
		