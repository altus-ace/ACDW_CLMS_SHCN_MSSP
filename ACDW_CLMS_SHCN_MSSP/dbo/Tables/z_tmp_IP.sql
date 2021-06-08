CREATE TABLE [dbo].[z_tmp_IP] (
    [Type]            NVARCHAR (50)  NULL,
    [memberNo]        NVARCHAR (50)  NULL,
    [ArcadiaEventID]  FLOAT (53)     NULL,
    [Payor]           NVARCHAR (50)  NULL,
    [Region]          NVARCHAR (100) NULL,
    [Chapter]         NVARCHAR (50)  NULL,
    [claimHeaderId]   FLOAT (53)     NULL,
    [MedicareClaimNo] FLOAT (53)     NULL,
    [admitDate]       DATE           NULL,
    [DischargeDate]   DATE           NULL,
    [Readmission]     FLOAT (53)     NULL
);

