Option Explicit
Dim Filas, Columnas, totalRelevantes As Integer
Dim matriz() As String
Dim posicion(1, 2) As Integer
Dim orientacion As String
Dim utilidad As Integer
Dim ultimoUno(1, 2) As Integer
Dim tamano As Integer
Dim posicionesRelevantes() As Integer
Dim MaxUtilidad(), NuevoRank() As Integer

Sub InitData()

Dim Fila As Integer
Dim Columna As Integer


Filas = Range("Filas")
Columnas = Range("Columnas")

ReDim matriz(Filas, Columnas)
ReDim MaxUtilidad(1, 5)

Sheet2.Cells.Clear

Sheet2.Cells(Range("BPOS1FIL"), Range("BPOS1COL")) = "B"
Sheet2.Cells(Range("BPOS2FIL"), Range("BPOS2COL")) = "B"
Sheet2.Cells(Range("BPOS3FIL"), Range("BPOS3COL")) = "B"
posicion(1, 1) = Range("CurrentPosX")
posicion(1, 2) = Range("CurrentPosY")
orientacion = Range("Orientation")


For Fila = 1 To Filas
    For Columna = 1 To Columnas
        If IsEmpty(Sheet2.Cells(Fila, Columna)) = True Then
            Sheet2.Cells(Fila, Columna) = 0
        End If
        matriz(Fila, Columna) = Sheet2.Cells(Fila, Columna)
    Next
Next

End Sub

Sub BlanquearMatriz()
Dim Fila, Columna As Integer

For Fila = 1 To Filas
    For Columna = 1 To Columnas
        matriz(Fila, Columna) = 0
    Next
Next
End Sub
Sub NextStep()

lectura
advanceOne
funcionUtilidad
imprimir

End Sub

Sub Reiniciar()
Dim Fila, Columna As Integer

Range("CurrentPosX") = 1
Range("CurrentPosY") = 1
Range("Orientation") = "UP"
Range("utility") = 0
ultimoUno(1, 1) = 0
ultimoUno(1, 2) = 0

End Sub


Sub advanceOne()
Dim Fila, Columna As Integer
Fila = posicion(1, 1)
Columna = posicion(1, 2)


If matriz(posicion(1, 1), posicion(1, 2)) = "0" Then
    matriz(posicion(1, 1), posicion(1, 2)) = "1"
    If orientacion = "UP" Then
        orientacion = "RIGHT"
    ElseIf orientacion = "RIGHT" Then
        orientacion = "DOWN"
    ElseIf orientacion = "DOWN" Then
        orientacion = "LEFT"
    ElseIf orientacion = "LEFT" Then
        orientacion = "UP"
    End If
    ultimoUno(1, 1) = posicion(1, 1)
    ultimoUno(1, 2) = posicion(1, 2)
ElseIf matriz(posicion(1, 1), posicion(1, 2)) = "1" Then
    matriz(posicion(1, 1), posicion(1, 2)) = "2"
    If orientacion = "UP" Then
        orientacion = "LEFT"
    ElseIf orientacion = "LEFT" Then
        orientacion = "DOWN"
    ElseIf orientacion = "DOWN" Then
        orientacion = "RIGHT"
    ElseIf orientacion = "RIGHT" Then
        orientacion = "UP"
    End If
ElseIf matriz(posicion(1, 1), posicion(1, 2)) = "B" Then
    If orientacion = "UP" Then
        orientacion = "LEFT"
    ElseIf orientacion = "LEFT" Then
        orientacion = "DOWN"
    ElseIf orientacion = "DOWN" Then
        orientacion = "RIGHT"
    ElseIf orientacion = "RIGHT" Then
        orientacion = "UP"
    End If
End If


If orientacion = "RIGHT" Then
    If posicion(1, 2) = Columnas Then
        Columna = 1
    ElseIf posicion(1, 2) < Columnas Then
        Columna = Columna + 1
    End If
ElseIf orientacion = "DOWN" Then
    If posicion(1, 1) = Filas Then
        Fila = 1
    ElseIf posicion(1, 1) < Filas Then
        Fila = Fila + 1
    End If
ElseIf orientacion = "LEFT" Then
    If posicion(1, 2) = 1 Then
        Columna = Columnas
    ElseIf posicion(1, 2) > 1 Then
        Columna = Columna - 1
    End If
ElseIf orientacion = "UP" Then
    If posicion(1, 1) = 1 Then
        Fila = Filas
    ElseIf posicion(1, 1) > 1 Then
        Fila = Fila - 1
    End If
End If

posicion(1, 1) = Fila
posicion(1, 2) = Columna

End Sub

Sub imprimir()
Dim Fila As Integer
Dim Columna As Integer

Range("CurrentPosX") = posicion(1, 1)
Range("CurrentPosY") = posicion(1, 2)
Range("Orientation") = orientacion
For Fila = 1 To Filas
    For Columna = 1 To Columnas
        Sheet2.Cells(Fila, Columna).Value = matriz(Fila, Columna)
    Next
Next
Range("utility") = utilidad

End Sub

Sub lectura()

posicion(1, 1) = Range("CurrentPosX")
posicion(1, 2) = Range("CurrentPosY")
orientacion = Range("Orientation")

End Sub

Sub Next50()
Dim contador As Long

lectura
For contador = 1 To 12000000
    advanceOne
Next
funcionUtilidad
'imprimir
MsgBox utilidad

End Sub

Sub AnswerFinder()

Dim Fila, TotalResp As Integer
Dim Columna As Integer
Dim NumeroRespuestas As Integer
Dim Respuestas() As Integer
Dim Recorredor, contador As Long
ReDim NuevoRank(Range("OtrasPosRank").Rows.Count, 2)

NumeroRespuestas = 0
For TotalResp = 1 To Range("OtrasPosRank").Rows.Count
    NuevoRank(TotalResp, 1) = Range("OtrasPosRank").Cells(TotalResp, 1)
    NuevoRank(TotalResp, 2) = Range("OtrasPosRank").Cells(TotalResp, 2)
Next

lectura
For contador = 1 To 50000
    advanceOne
Next
funcionUtilidad

For Fila = 1 To Filas
    For Columna = 1 To Columnas
        If matriz(Fila, Columna) = "1" Or matriz(Fila, Columna) = "2" Then
            NumeroRespuestas = NumeroRespuestas + 1
        End If
    Next
Next

ReDim Respuestas(NumeroRespuestas, 3)

NumeroRespuestas = 0
For Fila = 1 To Filas
    For Columna = 1 To Columnas
        If matriz(Fila, Columna) = "1" Or matriz(Fila, Columna) = "2" Then
            NumeroRespuestas = NumeroRespuestas + 1
            Respuestas(NumeroRespuestas, 1) = Fila
            Respuestas(NumeroRespuestas, 2) = Columna
        End If
    Next
Next

For Recorredor = 1 To NumeroRespuestas
    BlanquearMatriz
    matriz(2, 2) = "B"
    'matriz(41, 1) = "B"
    matriz(Respuestas(Recorredor, 1), Respuestas(Recorredor, 2)) = "B"
    orientacion = "UP"
    posicion(1, 1) = 1
    posicion(1, 2) = 1
    For contador = 1 To 50000
        advanceOne
    Next
    funcionUtilidad
    Respuestas(Recorredor, 3) = utilidad
    If utilidad > 19995 Then
        MsgBox "Found!"
        Stop
    End If
Next

'MsgBox "Nada :("
For Fila = 1 To NumeroRespuestas
    Sheet1.Cells(Fila + 11, 1) = Respuestas(Fila, 1)
    Sheet1.Cells(Fila + 11, 2) = Respuestas(Fila, 2)
    Sheet1.Cells(Fila + 11, 3) = Respuestas(Fila, 3)
Next

End Sub
Sub funcionUtilidad()

Dim Fila As Integer
Dim Columna As Integer

utilidad = 0
For Fila = 1 To Filas
    For Columna = 1 To Columnas
        If matriz(Fila, Columna) = "1" Then
            utilidad = utilidad + 1
        ElseIf matriz(Fila, Columna) = "2" Then
            utilidad = utilidad + 2
        End If
    Next
Next

End Sub

Sub AnswerLastOne()

Dim Fila As Integer
Dim Columna, contador As Integer
Dim Selectas() As Integer

InitData
lectura


ReDim Selectas(Range("MejoresRespuestas").Rows.Count, 3)
For Fila = 1 To Range("MejoresRespuestas").Rows.Count
    BlanquearMatriz
    orientacion = "UP"
    posicion(1, 1) = 1
    posicion(1, 2) = 1
    Selectas(Fila, 1) = Range("MejoresRespuestas").Cells(Fila, 1)
    Selectas(Fila, 2) = Range("MejoresRespuestas").Cells(Fila, 2)
    matriz(Selectas(Fila, 1), Selectas(Fila, 2)) = "B"
    For contador = 1 To 30000
        advanceOne
    Next
    encuentraRelevantes
    For Columna = 1 To totalRelevantes
        BlanquearMatriz
        orientacion = "UP"
        posicion(1, 1) = 1
        posicion(1, 2) = 1
        matriz(Selectas(Fila, 1), Selectas(Fila, 2)) = "B"
        matriz(posicionesRelevantes(Columna, 1), posicionesRelevantes(Columna, 2)) = "B"
        For contador = 1 To 30000
            advanceOne
        Next
        funcionUtilidad
        If MaxUtilidad(1, 5) < utilidad Then
            MaxUtilidad(1, 1) = Selectas(Fila, 1)
            MaxUtilidad(1, 2) = Selectas(Fila, 2)
            MaxUtilidad(1, 3) = posicionesRelevantes(Columna, 1)
            MaxUtilidad(1, 4) = posicionesRelevantes(Columna, 2)
            MaxUtilidad(1, 5) = utilidad
        End If
    Next
Next

For Fila = 1 To Range("UtilidadUltUno").Rows.Count
    Range("UtilidadUltUno").Cells(Fila, 1) = Selectas(Fila, 0)
Next

End Sub

Sub encuentraRelevantes()
Dim Fila As Integer
Dim Columna As Integer

totalRelevantes = 0
For Fila = 1 To Filas
    For Columna = 1 To Columnas
        If matriz(Fila, Columna) = "1" Or matriz(Fila, Columna) = "2" Then
            totalRelevantes = totalRelevantes + 1
        End If
    Next
Next

ReDim posicionesRelevantes(totalRelevantes, 2)
totalRelevantes = 0

For Fila = 1 To Filas
    For Columna = 1 To Columnas
        If matriz(Fila, Columna) = "1" Or matriz(Fila, Columna) = "2" Then
            totalRelevantes = totalRelevantes + 1
            posicionesRelevantes(totalRelevantes, 1) = Fila
            posicionesRelevantes(totalRelevantes, 2) = Columna
        End If
    Next
Next

End Sub

Sub Programa()

Dim contador As Integer

lectura
For contador = 1 To 30000
    advanceOne
Next
AnswerFinder
imprimir

End Sub

