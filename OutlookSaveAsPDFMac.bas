Sub SaveAsPDFfile()

'Get all selected items
    Dim MyOlNamespace As Outlook.NameSpace
    Set MyOlNamespace = Application.GetNamespace("MAPI")
    Set MyOlSelection = Application.ActiveExplorer.Selection

    'Make sure at least one item is selected
    If MyOlSelection.Count <> 1 Then
       Response = MsgBox("Please select a single item", vbExclamation, "Save as PDF")
       Exit Sub
    End If
    
    'Retrieve the selected item
    Set MySelectedItem = MyOlSelection.Item(1)
    
    'Get the user's TempFolder to store the item in
    Dim FSO As Object, TmpFolder As Object
    Set FSO = CreateObject("scripting.filesystemobject")
    Set tmpFileName = FSO.GetSpecialFolder(2)
    
    'construct the filename for the temp mht-file
    strName = "pdfexport"
    tmpFileName = tmpFileName & "\" & strName & ".mht"
    
    'Save the mht-file
    MySelectedItem.SaveAs tmpFileName, olMHTML
    
    'Create a Word object
    Dim wrdApp As Word.Application
    Dim wrdDoc As Word.Document
    Set wrdApp = CreateObject("Word.Application")
    
    'Open the mht-file in Word without Word visible
    Set wrdDoc = wrdApp.Documents.Open(FileName:=tmpFileName, Visible:=False)
    
    'Define the SafeAs dialog
    Dim dlgSaveAs As FileDialog
    Set dlgSaveAs = wrdApp.FileDialog(msoFileDialogSaveAs)
    
    'Determine the FilterIndex for saving as a pdf-file
    'Get all the filters
    Dim fdfs As FileDialogFilters
    Dim fdf As FileDialogFilter
    Set fdfs = dlgSaveAs.Filters

    'Loop through the Filters and exit when "pdf" is found
    Dim i As Integer
    i = 0
    For Each fdf In fdfs
        i = i + 1
        If InStr(1, fdf.Extensions, "pdf", vbTextCompare) > 0 Then
            Exit For
        End If
    Next fdf
    
    'Set the FilterIndex to pdf-files
    dlgSaveAs.FilterIndex = i
    
    'Get location of My Documents folder
    Dim WshShell As Object
    Dim SpecialPath As String
    Set WshShell = CreateObject("WScript.Shell")
    SpecialPath = WshShell.SpecialFolders(16)
    
    'Construct a safe file name from the message subject
    Dim msgFileName As String
    msgFileName = MySelectedItem.Subject

    Set oRegEx = CreateObject("vbscript.regexp")
    oRegEx.Global = True
    oRegEx.Pattern = "[\/:*?""<>|]"
    msgFileName = Trim(oRegEx.Replace(msgFileName, ""))
    
    'Set the initial location and file name for SaveAs dialog
    Dim strCurrentFile As String
    dlgSaveAs.InitialFileName = SpecialPath & "\" & msgFileName
       
    'Show the SaveAs dialog and save the message as pdf
    If dlgSaveAs.Show = -1 Then
        strCurrentFile = dlgSaveAs.SelectedItems(1)
        
        'Verify if pdf is selected
        If Right(strCurrentFile, 4) <> ".pdf" Then
            Response = MsgBox("Sorry, only saving in the pdf-format is supported." & _
                vbNewLine & vbNewLine & "Save as pdf instead?", vbInformation + vbOKCancel)
                If Response = vbCancel Then
                    wrdDoc.Close
                    wrdApp.Quit
                    Exit Sub
                ElseIf Response = vbOK Then
                    intPos = InStrRev(strCurrentFile, ".")
                    If intPos > 0 Then
                       strCurrentFile = Left(strCurrentFile, intPos - 1)
                    End If

                    strCurrentFile = strCurrentFile & ".pdf"
                End If
        End If
        
        'Save as pdf
        wrdApp.ActiveDocument.ExportAsFixedFormat OutputFileName:= _
            strCurrentFile, ExportFormat:= _
            wdExportFormatPDF, OpenAfterExport:=False, OptimizeFor:= _
            wdExportOptimizeForPrint, Range:=wdExportAllDocument, From:=0, To:=0, _
            Item:=wdExportDocumentContent, IncludeDocProps:=True, KeepIRM:=True, _
            CreateBookmarks:=wdExportCreateNoBookmarks, DocStructureTags:=True, _
            BitmapMissingFonts:=True, UseISO19005_1:=False
    End If
    Set dlgSaveAs = Nothing
    
    ' close the document and Word
    wrdDoc.Close
    wrdApp.Quit
    
    'Cleanup
    Set MyOlNamespace = Nothing
    Set MyOlSelection = Nothing
    Set MySelectedItem = Nothing
    Set wrdDoc = Nothing
    Set wrdApp = Nothing
    Set oRegEx = Nothing

End Sub
