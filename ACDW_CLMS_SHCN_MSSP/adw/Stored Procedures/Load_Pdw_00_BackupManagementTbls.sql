CREATE PROCEDURE [adw].[Load_Pdw_00_BackupManagementTbls]
AS 
    -- 
    --Alter table ast.bk_ClaimHeader_01_Deduplicate  ADD CONSTRAINT PK_bk_ClaimHeader_01_Deduplicate_SeqClaimIdLoadDate PRIMARY KEY CLUSTERED (SeqClaimID, LoadDate);
    INSERT INTO ast.bk_ClaimHeader_01_Deduplicate 
	   (	  [SrcAdiKey],[SeqClaimId],[OriginalFileName] ,[LoadDate],[CreatedDate],[CreatedBy])
    SELECT [SrcAdiKey] ,[SeqClaimId],[OriginalFileName] ,CONVERT(DATE,createdDate),[CreatedDate],[CreatedBy]
    FROM [ast].[ClaimHeader_01_Deduplicate]
    
    --ALTER TABLE [ast].[bk_ClaimHeader_02_ClaimSuperKey] ADD CONSTRAINT PK_bk_ClaimHeader_02_ClaimSuperKey_SuperKeyLoadDate PRIMARY KEY CLUSTERED (ClmSKey, LoadDate)
    INSERT INTO [ast].[bk_ClaimHeader_02_ClaimSuperKey] 
	   ([clmSKey],[PRVDR_OSCAR_NUM],[BENE_EQTBL_BIC_HICN_NUM],[CLM_FROM_DT],[CLM_THRU_DT],[LoadDate],[CreatedDate],[CreatedBy])
    SELECT  [clmSKey],[PRVDR_OSCAR_NUM],[BENE_EQTBL_BIC_HICN_NUM],[CLM_FROM_DT],[CLM_THRU_DT],[LoadDate],[CreatedDate],[CreatedBy]
    FROM [ast].[ClaimHeader_02_ClaimSuperKey];

    -- ALter TABLE [ast].[bk_ClaimHeader_03_LatestEffectiveClaimsHeader] ADD LoadDate DATE
    -- UPDATE CH SET ch.loadDate = CONVERT(DATE, CreatedDate)  FROM ast.bk_ClaimHeader_03_LatestEffectiveClaimsHeader ch  -- create load date for PK
    --    ALter TABLE [ast].[bk_ClaimHeader_03_LatestEffectiveClaimsHeader] ALTER COLUMN LoadDate DATE NOT NULL set column not null
    --ALTER TABLE [ast].[bk_ClaimHeader_03_LatestEffectiveClaimsHeader] ADD CONSTRAINT PK_bk_ClaimHeader_03_LatestEffectiveClaimsHeader_ClmsHdrUrnLoadDate PRIMARY KEY CLUSTERED (ClmHdrUrn,LoadDate);
    INSERT INTO [ast].[bk_ClaimHeader_03_LatestEffectiveClaimsHeader]
	   ([clmSKey],[clmHdrURN],[CreatedDate],[CreatedBy], LoadDate)
    SELECT [clmSKey], lec.LatestClaimAdiKey, [CreatedDate],[CreatedBy], CONVERT(DATE, CreatedDate)  LoadDate
    FROM [ast].[ClaimHeader_03_LatestEffectiveClaimsHeader] lec

  
    -- alter table [ast].[bk_pstcDgDeDupUrns] add LoadDate Date
    -- UPDATE CH SET ch.loadDate = CONVERT(DATE, CreatedDate)  FROM [ast].[bk_pstcDgDeDupUrns] ch  -- create load date for PK
    --  ALter TABLE [ast].[bk_pstcDgDeDupUrns]  ALTER COLUMN LoadDate DATE NOT NULL --set column not null
    --  ALTER TABLE [ast].[bk_pstcDgDeDupUrns]  ADD CONSTRAINT PK_bk_pstcDgDeDupUrns_UrnLoadDate PRIMARY KEY CLUSTERED (Urn,LoadDate);
    INSERT INTO [ast].[bk_pstcDgDeDupUrns] 
	   (Urn, CreatedDate, CreatedBy,LoadDate)
    SELECT [urn],[CreatedDate],[CreatedBy],CONVERT(DATE, CreatedDate)  LoadDate
    FROM [ast].[pstcDgDeDupUrns]


  
    -- alter table [ast].[bk_pstcLnsDeDupUrns] add LoadDate Date
    -- UPDATE CH SET ch.loadDate = CONVERT(DATE, CreatedDate)  FROM [ast].[bk_pstcLnsDeDupUrns] ch  -- create load date for PK
    --  ALter TABLE [ast].[bk_pstcLnsDeDupUrns]  ALTER COLUMN LoadDate DATE NOT NULL -- set column not null
    --  ALTER TABLE [ast].[bk_pstcLnsDeDupUrns]  ADD CONSTRAINT PK_bk_pstcLnsDeDupUrns_UrnLoadDate PRIMARY KEY CLUSTERED (Urn,LoadDate);
    INSERT INTO [ast].[bk_pstcLnsDeDupUrns]
	   (URN, CreatedDate, CreatedBy, LoadDate)
    SELECT [URN],[CreatedDate],[CreatedBy], CONVERT(DATE, CreatedDate)
    FROM [ast].[pstcLnsDeDupUrns]

    -- alter table [ast].[bk_pstcPrcDeDupUrns] add LoadDate Date
    -- UPDATE CH SET ch.loadDate = CONVERT(DATE, CreatedDate)  FROM [ast].[bk_pstcPrcDeDupUrns] ch  -- create load date for PK
    --  ALter TABLE [ast].[bk_pstcPrcDeDupUrns]  ALTER COLUMN LoadDate DATE NOT NULL -- set column not null
    --  ALTER TABLE [ast].[bk_pstcPrcDeDupUrns]  ADD CONSTRAINT PK_bk_pstcPrcDeDupUrns_UrnLoadDate PRIMARY KEY CLUSTERED (Urn,LoadDate);
    INSERT INTO ast.bk_pstcPrcDeDupUrns
	   (URN, CreatedDate, CreatedBy, LoadDate)
    SELECT [urn],[CreatedDate],[CreatedBy],CONVERT(DATE, CreatedDate)  
    FROM [ast].[pstcPrcDeDupUrns]

      
    -- alter table [ast].[bk_pstDeDupClms_PartBPhys] add LoadDate Date
    -- UPDATE CH SET ch.loadDate = CONVERT(DATE, CreatedDate)  FROM [ast].[bk_pstDeDupClms_PartBPhys] ch  -- create load date for PK
    --  ALter TABLE [ast].[bk_pstDeDupClms_PartBPhys]  ALTER COLUMN LoadDate DATE NOT NULL -- set column not null
    --  ALTER TABLE [ast].[bk_pstDeDupClms_PartBPhys]  ADD CONSTRAINT PK_bk_pstDeDupClms_PartBPhys_UrnLoadDate PRIMARY KEY CLUSTERED (Urn,LoadDate);
    INSERT INTO [ast].[bk_pstDeDupClms_PartBPhys]
	   (urn, CreatedDate, CreatedBy, LoadDate) 
    SELECT [urn],[CreatedDate],[CreatedBy], CONVERT(DATE, CreatedDate)  
    FROM [ast].[pstDeDupClms_PartBPhys]

    -- alter table [ast].[bk_pstDeDupClms_PartDPharma] add LoadDate Date
    -- UPDATE CH SET ch.loadDate = CONVERT(DATE, CreatedDate)  FROM [ast].[bk_pstDeDupClms_PartDPharma] ch  -- create load date for PK
    --  ALter TABLE [ast].[bk_pstDeDupClms_PartDPharma]  ALTER COLUMN LoadDate DATE NOT NULL -- set column not null
    --  ALTER TABLE [ast].[bk_pstDeDupClms_PartDPharma]  ADD CONSTRAINT PK_bk_pstDeDupClms_PartDPharma_UrnLoadDate PRIMARY KEY CLUSTERED (Urn,LoadDate);    
    INSERT INTO [ast].[bk_pstDeDupClms_PartDPharma]
	   (urn, createdDate, CreatedBy, LoadDate) 
    SELECT [urn],[CreatedDate],[CreatedBy], CONVERT(DATE, CreatedDate)  
    FROM [ast].[pstDeDupClms_PartDPharma]

    /*
    SELECT loadDate, count(*) FROM  ast.bk_ClaimHeader_01_Deduplicate					  C GROUP BY C.LoadDate
    SELECT loadDate, count(*) FROM  [ast].[bk_ClaimHeader_02_ClaimSuperKey] 			  C GROUP BY C.LoadDate
    SELECT loadDate, count(*) FROM  [ast].[bk_ClaimHeader_03_LatestEffectiveClaimsHeader]	  C GROUP BY C.LoadDate
    SELECT loadDate, count(*) FROM  [ast].[bk_pstcDgDeDupUrns] 						  C GROUP BY C.LoadDate
    SELECT loadDate, count(*) FROM  [ast].[bk_pstcLnsDeDupUrns]						  C GROUP BY C.LoadDate
    SELECT loadDate, count(*) FROM  ast.bk_pstcPrcDeDupUrns							  C GROUP BY C.LoadDate
    SELECT loadDate, count(*) FROM  [ast].[bk_pstDeDupClms_PartBPhys]					  C GROUP BY C.LoadDate
    SELECT loadDate, count(*) FROM  [ast].[bk_pstDeDupClms_PartDPharma]				  C GROUP BY C.LoadDate
    */
