CREATE VIEW adi.vw_MSSPAnnualmembership
AS
SELECT DISTINCT 
                         adi.Steward_MSSPAnnualmembership_HALRBASE.MedicareBeneficiaryID, adi.Steward_MSSPAnnualmembership_HALRBASE.FirstNM, adi.Steward_MSSPAnnualmembership_HALRBASE.LastNM, 
                         adi.Steward_MSSPAnnualmembership_HALRBASE.SexCD, adi.Steward_MSSPAnnualmembership_HALRBASE.BirthDTS, adi.Steward_MSSPAnnualmembership_HALRBASE.DeathDTS, 
                         adi.Steward_MSSPAnnualmembership_HALRBASE.CountyNM, ast.stgFctMembership.MstrMrnKey
FROM            adi.Steward_MSSPAnnualmembership_HALRBASE INNER JOIN
                         ast.stgFctMembership ON adi.Steward_MSSPAnnualmembership_HALRBASE.MedicareBeneficiaryID = ast.stgFctMembership.ClientMemberKey
WHERE        (adi.Steward_MSSPAnnualmembership_HALRBASE.HomeStateCD = 'Texas') AND (adi.Steward_MSSPAnnualmembership_HALRBASE.DeathDTS IS NULL)

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[10] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Steward_MSSPAnnualmembership_HALRBASE (adi)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 343
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "stgFctMembership (ast)"
            Begin Extent = 
               Top = 6
               Left = 381
               Bottom = 136
               Right = 631
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2055
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'VIEW', @level1name = N'vw_MSSPAnnualmembership';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'VIEW', @level1name = N'vw_MSSPAnnualmembership';

