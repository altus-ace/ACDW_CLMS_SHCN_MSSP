CREATE TABLE [adi].[z_ListHospitalProductLines] (
    [VisitType]       NVARCHAR (15)  NULL,
    [ProductLine]     NVARCHAR (50)  NULL,
    [ServiceLine]     NVARCHAR (100) NULL,
    [SubServiceLine]  NVARCHAR (100) NULL,
    [MdcCode]         NVARCHAR (15)  NULL,
    [DrgCode]         NVARCHAR (15)  NULL,
    [ProcCode]        NVARCHAR (25)  NULL,
    [ServiceCode]     NVARCHAR (50)  NULL,
    [DRG]             NVARCHAR (10)  NULL,
    [CPT]             NVARCHAR (10)  NULL,
    [DiagCode]        NVARCHAR (15)  NULL,
    [SvcCodeId]       NVARCHAR (25)  NULL,
    [ServiceCodeName] NVARCHAR (50)  NULL,
    [ER_Flag]         FLOAT (53)     NULL,
    [Obv_Flag]        FLOAT (53)     NULL,
    [Surg_Flag]       FLOAT (53)     NULL
);

