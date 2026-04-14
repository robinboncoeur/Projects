Rem Attribute VBA_ModuleType=VBAModule
Option VBASupport 1
Option Explicit

'======================================================
'                 Household/Investments Budget Tool
'======================================================

'*************************************
'                  Launcher
'*************************************
Public Sub LaunchTxnCodes()
  On Error GoTo ErrHandler

  Dim oDoc As Object, oController As Object, oSheet As Object
  Dim sSheetName As String, errMsg As String

  oDoc = ThisComponent
  If IsNull(oDoc) Then errMsg = "No document is open."

  If errMsg = "" Then
    If Not oDoc.supportsService("com.sun.star.sheet.SpreadsheetDocument") Then
      errMsg = "Active document is not a Calc workbook."
    End If
  End If

  If errMsg = "" Then
    oController = oDoc.getCurrentController()
    If IsNull(oController) Then errMsg = "No active controller found."
  End If

  If errMsg = "" Then
    oSheet = oController.getActiveSheet()
    If IsNull(oSheet) Then errMsg = "No active sheet found."
  End If

  If errMsg = "" Then
    sSheetName = Trim(oSheet.getName())
    If sSheetName = "" Then errMsg = "Active sheet has no valid name."
  End If

  If errMsg = "" Then
    Select Case UCase(sSheetName)
      Case "ALIST", "OVERVIEW", "TSY"
        errMsg = "Sheet '" & sSheetName & "' is not a transaction sheet."
    End Select
  End If

  If errMsg <> "" Then
    MsgBox errMsg, 48, "TxnTracker"
    Exit Sub
  End If

  TxnCodes oSheet
  Exit Sub

ErrHandler:
  MsgBox "LaunchTxnCodes failed." & Chr(10) & _
         "Error " & Err & ": " & Error$, 16, "TxnTracker"
End Sub
'======================================================






'======================================================
'              Transaction Code Helper Functions
'======================================================

Private Function GetCurrentRegionFromA1(oSheet As Object) As Object
    Dim oStart As Object
    Dim oCursor As Object

    oStart = oSheet.getCellRangeByName("A1")
    oCursor = oSheet.createCursorByRange(oStart)
    oCursor.collapseToCurrentRegion()

    GetCurrentRegionFromA1 = oCursor
End Function
''******************************************************



Private Function GetTxnRange(oSheet As Object) As Object

  Dim oCursor As Object
  Dim lLastRow As Long

  oCursor = oSheet.createCursor()
  oCursor.gotoEndOfUsedArea(True)
  lLastRow = oCursor.RangeAddress.EndRow

  ' A:G, starting from row 2
  GetTxnRange = oSheet.getCellRangeByPosition(0, 1, 6, lLastRow)

End Function
'******************************************************











'======================================================
' Transaction Codes (TxnCodes)
' Processes Worksheets 259Checking, 568CreditCard, 972Savings
' Assigns base description [col C] & code [col D] to a transaction.
' Accepts: oSheet... active worksheet as object
' Vendor List codes set: AList
'======================================================
Private Sub TxnCodes(oSheet As Object)

  Const COL_C As Long = 2
  Const COL_D As Long = 3
  Const COL_G As Long = 6
  Const ALIST_REGEX As Long = 0
  Const ALIST_COL_B as Long = 1
  Const ALIST_COL_C as Long = 2

  Dim sEntry As String
  Dim i As Long, j As Long
 
  Dim rTxnRegion As Object, rRulesRegion As Object
  Dim oAListSheet As Object
  Dim arrayAList As Variant, arrayTxns as variant
  
' replaces Excel's .CurrentRegion property (calls helper)
  rTxnRegion = GetTxnRange(oSheet)
  arrayTxns = rTxnRegion.getDataArray()
   
' vendor / rules list from sheet "AList"
  oAListSheet = ThisComponent.Sheets.getByName("AList")
  rRulesRegion = GetCurrentRegionFromA1(oAListSheet)
  arrayAList = rRulesRegion.getDataArray()

   
' stepping through array of Transactions
  For i = LBound(arrayTxns, 1) to UBound(arrayTxns, 1)
     
    If Trim(CStr(arrayTxns(i, COL_D))) = "" Then
      sEntry = CStr(arrayTxns(i, COL_G))

' stepping through array of VendorList
      For j = LBound(arrayAList, 1) + 1 To UBound(arrayAList, 1)        
        regEx.Pattern = CStr(arrayAList(j, ALIST_REGEX))


' if there's a match, write to TxnArray
        If regEx.Test(sEntry) Then
          arrayTxns(i, COL_C) = arrayAList(j, ALIST_COL_B)
          arrayTxns(i, COL_D) = arrayAList(j, ALIST_COL_C)
          Exit For
        End If
      Next j
      
    End If

  Next i

  rTxnRegion.setDataArray(arrayTxns)
  
  MsgBox UBound(arrayTxns, 1) & " transaction rows processed.", 64, "TxnTracker"

End Sub
'=============================================================



















Rem Attribute VBA_ModuleType=VBAModule
Option VBASupport 1
Option Explicit

'======================================================
'                 Household/Investments Budget Tool
'======================================================

'*************************************
'                  Launcher
'*************************************
Public Sub LaunchTxnCodes()
  On Error GoTo ErrHandler
  
  Dim oDoc As Object, oController As Object, oSheet As Object
  Dim sSheetName As String, errMsg As String

  oDoc = ThisComponent
  If IsNull(oDoc) Then errMsg = "No document is open."

  If errMsg = "" Then
    If Not oDoc.supportsService("com.sun.star.sheet.SpreadsheetDocument") Then
      errMsg = "Active document is not a Calc workbook."
    End If
  End If

  If errMsg = "" Then
    oController = oDoc.getCurrentController()
    If IsNull(oController) Then errMsg = "No active controller found."
  End If

  If errMsg = "" Then
    oSheet = oController.getActiveSheet()
    If IsNull(oSheet) Then errMsg = "No active sheet found."
  End If

  If errMsg = "" Then
    sSheetName = Trim(oSheet.getName())
    If sSheetName = "" Then errMsg = "Active sheet has no valid name."
  End If

  If errMsg = "" Then
    Select Case UCase(sSheetName)
      Case "ALIST", "OVERVIEW", "TSY"
        errMsg = "Sheet '" & sSheetName & "' is not a transaction sheet."
    End Select
  End If

  If errMsg <> "" Then
    MsgBox errMsg, 48, "TxnTracker"
    Exit Sub
  End If

  TxnCodes oSheet
  Exit Sub

ErrHandler:
  MsgBox "LaunchTxnCodes failed." & Chr(10) & _
         "Error " & Err & ": " & Error$, 16, "TxnTracker"
End Sub
'======================================================






'======================================================
'              Transaction Code Helper Functions
'======================================================

Private Function GetCurrentRegionFromA1(oSheet As Object) As Object
    Dim oStart As Object
    Dim oCursor As Object

    oStart = oSheet.getCellRangeByName("A1")
    oCursor = oSheet.createCursorByRange(oStart)
    oCursor.collapseToCurrentRegion()

    GetCurrentRegionFromA1 = oCursor
End Function
''******************************************************



Private Function GetTxnRange(oSheet As Object) As Object

  Dim oCursor As Object
  Dim lLastRow As Long

  oCursor = oSheet.createCursor()
  oCursor.gotoEndOfUsedArea(True)
  lLastRow = oCursor.RangeAddress.EndRow

  ' A:G, starting from row 2
  GetTxnRange = oSheet.getCellRangeByPosition(0, 1, 6, lLastRow)

End Function
'******************************************************











'======================================================
' Transaction Codes (TxnCodes)
' Processes Worksheets 259Checking, 568CreditCard, 972Savings
' Assigns base description [col C] & code [col D] to a transaction.
' Accepts: oSheet... active worksheet as object
' Vendor List codes set: AList
'======================================================
Private Sub TxnCodes(oSheet As Object)

  Const COL_C As Long = 2
  Const COL_D As Long = 3
  Const COL_G As Long = 6
  Const ALIST_REGEX As Long = 0
  Const ALIST_COL_B as Long = 1
  Const ALIST_COL_C as Long = 2

  Dim sEntry As String
  Dim i As Long, j As Long
 
  Dim rTxnRegion As Object, rRulesRegion As Object
  Dim oAListSheet As Object
  Dim arrayAList As Variant, arrayTxns as variant
  

' replaces Excel's .CurrentRegion property (calls helper)
  rTxnRegion = GetTxnRange(oSheet)
  arrayTxns = rTxnRegion.getDataArray()

  'MsgBox "At the level of arrayTxns =", 64, "TxnTracker"
  'Exit Sub


' vendor / rules list from sheet "AList"
  oAListSheet = ThisComponent.Sheets.getByName("AList")
  rRulesRegion = GetCurrentRegionFromA1(oAListSheet)
  arrayAList = rRulesRegion.getDataArray()

   
' stepping through array of Transactions
  For i = LBound(arrayTxns) to UBound(arrayTxns)
     
    If Trim(CStr(arrayTxns(i)(COL_D))) = "" Then
      sEntry = CStr(arrayTxns(i)(COL_G))

' stepping through array of VendorList
      For j = LBound(arrayAList) + 1 To UBound(arrayAList)        
        regEx.Pattern = CStr(arrayAList(j)(ALIST_REGEX))


' if there's a match, write to TxnArray
        If regEx.Test(sEntry) Then
          arrayTxns(i)(COL_C) = arrayAList(j)(ALIST_COL_B)
          arrayTxns(i)(COL_D) = arrayAList(j)(ALIST_COL_C)
          Exit For
        End If
      Next j
      
    End If

  Next i

  rTxnRegion.setDataArray(arrayTxns)
  
  MsgBox UBound(arrayTxns) & " transaction rows processed.", 64, "TxnTracker"

End Sub
'=============================================================
