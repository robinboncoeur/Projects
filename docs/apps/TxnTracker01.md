# Transaction Tracker

## Migrating to Calc from Excel

### Original Code







<hr style="height:4px;border-width:0;color:blue;background-color:blue" />


## Initial Revision

```vb.net
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
    Dim sSheetName As String
    
    oDoc = ThisComponent
    
    If IsNull(oDoc) Then
        MsgBox "No document is open.", 48, "TxnTracker"
        Exit Sub
    End If
    
    If Not oDoc.supportsService("com.sun.star.sheet.SpreadsheetDocument") Then
        MsgBox "Active document is not a Calc workbook.", 48, "TxnTracker"
        Exit Sub
    End If
    
    oController = oDoc.getCurrentController()
    
    If IsNull(oController) Then
        MsgBox "No active controller found.", 48, "TxnTracker"
        Exit Sub
    End If
    
    oSheet = oController.getActiveSheet()
    
    If IsNull(oSheet) Then
        MsgBox "No active sheet found.", 48, "TxnTracker"
        Exit Sub
    End If
    
    sSheetName = Trim(oSheet.getName())
    
    If sSheetName = "" Then
        MsgBox "Active sheet has no valid name.", 48, "TxnTracker"
        Exit Sub
    End If
    
    ' Optional guardrails
    Select Case UCase(sSheetName)
        Case "ALIST", "OVERVIEW", "TSY"
			MsgBox "Sheet '" & sSheetName & "' is not a transaction sheet.", 48, "TxnTracker"
	        Exit Sub
	    Case Else
	    	' okay to carry on
    End Select
    
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

Private Function CheckFilterMode(sSheet As Integer) As Boolean
    Select Case sSheet
        Case 1: CheckFilterMode = RangeHasActiveFilter("259Checking")
        Case 2: CheckFilterMode = RangeHasActiveFilter("568CreditCard")
        Case 3: CheckFilterMode = RangeHasActiveFilter("972Savings")
        Case Else: CheckFilterMode = False
    End Select
End Function
'**********************************************************************************


Private Function RangeHasActiveFilter(sSheetName As String) As Boolean
    Dim oSheet As Object
    Dim oDesc As Object
    Dim aFields

    oSheet = ThisComponent.Sheets.getByName(sSheetName)
    oDesc = oSheet.createFilterDescriptor(False)
    aFields = oDesc.getFilterFields()

    On Error GoTo NoFields
    RangeHasActiveFilter = (UBound(aFields) >= 0)
    Exit Function

NoFields:
    RangeHasActiveFilter = False
End Function
'**********************************************************************************



Private Function RuleMatches(sPattern As String, sEntry As String) As Boolean
    Static regEx As regExp

    If regEx Is Nothing Then
        Set regEx = New regExp
        regEx.IgnoreCase = True
    End If

    regEx.Pattern = sPattern
    RuleMatches = regEx.Test(sEntry)
End Function
  
  ' Pattern: (string and regEx within double quotes)
  ' ------------------------------------------------
  ' ^ = starts with, $ = ends with,
  ' (use no symbols in Pattern string to find Pattern string in
  '   string to be searched),
  ' [ab]c = can be either a or b, [^a]c = anything BUT a,
  ' \s = space, [A-z] letter only, no numbers
'**********************************************************************************



Private Function GetCurrentRegionFromA1(oSheet As Object) As Object
    Dim oStart As Object
    Dim oCursor As Object

    oStart = oSheet.getCellRangeByName("A1")
    oCursor = oSheet.createCursorByRange(oStart)
    oCursor.collapseToCurrentRegion()

    GetCurrentRegionFromA1 = oCursor
End Function
'**********************************************************************************



Private Function GetTxnRange(oSheet As Object) As Object

  Dim oCursor As Object
  Dim lLastRow As Long

  oCursor = oSheet.createCursor()
  oCursor.gotoEndOfUsedArea(True)
  lLastRow = oCursor.RangeAddress.EndRow

  ' A:G, starting from row 2
  GetTxnRange = oSheet.getCellRangeByPosition(0, 1, 6, lLastRow)

End Function
'**********************************************************************************











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

End Function
'=============================================================
