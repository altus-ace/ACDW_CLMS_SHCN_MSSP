

CREATE PROCEDURE adi.ValidateMbrShip

AS


		SELECT   COUNT(*)RecCnt, DataDate
		FROM	 adi.[MSSPPatientAttributionList]
		GROUP BY DataDate
		ORDER BY DataDate DESC

		SELECT   COUNT(*)RecCnt, DataDate
		FROM	 adi.Steward_MSSPBeneficiaryDemographic 
		GROUP BY DataDate
		ORDER BY DataDate DESC

		SELECT COUNT(MBI_ID) MbrCountForProcessing FROM (
		SELECT	*
		FROM	(SELECT MBI_ID,DataDate,PatientFirstName,PatientLastName,AttributedNPI
					FROM (SELECT  ROW_NUMBER()OVER(PARTITION BY MBI_ID ORDER BY DataDate)RwCnt
									,MBI_ID,DataDate,PatientFirstName,PatientLastName
									,c.AttributedNPI,c.Sex,c.DOB
						  FROM adi.[MSSPPatientAttributionList] c
							)t
						 WHERE RwCnt = 1
						 ) m
		LEFT JOIN	(SELECT * FROM (
					SELECT ROW_NUMBER()OVER(PARTITION BY MedicareBeneficiaryID ORDER BY DeathDTS DESC ) RwCnt
						,MedicareBeneficiaryID,b.DeathDTS,b.BirthDTS,b.HospiceStartDTS,b.HospiceEndDTS
						 FROM adi.Steward_MSSPBeneficiaryDemographic b
						WHERE DataDate = (SELECT  MAX(DataDate)
											FROM  adi.Steward_MSSPBeneficiaryDemographic )
						)a WHERE
						 RwCnt = 1
						 ) a
		ON		m.MBI_ID = a.MedicareBeneficiaryID
		WHERE	m.DataDate = (SELECT  MAX(DataDate)
											FROM  adi.[MSSPPatientAttributionList] ) 
						)src
		LEFT JOIN lst.List_PCP pr
		ON		src.AttributedNPI = pr.PCP_NPI
		--WHERE	pr.PCP_NPI IS NULL





