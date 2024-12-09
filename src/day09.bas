Function cksum(memory() As Integer) As Integer
	Dim sum As Integer = 0
	For i As Integer = 0 To UBound(memory)
		If memory(i) <> -1 Then
			sum += i * memory(i)
		EndIf
	Next
	
	Return sum
End Function

Function part1(memory() As Integer) As Integer
	Dim sorted(0 To UBound(memory)) As Integer
	For i As Integer = 0 To UBound(memory)
		sorted(i) = memory(i)
	Next
	
	Dim nextFree As Integer = 0
	For i As Integer = 0 To UBound(sorted)
		If sorted(i) = -1 Then
			nextFree = i
			Exit For
		EndIf
	Next
	
	Dim current As Integer = UBound(sorted)
	
	While nextFree < current
		Swap sorted(nextFree), sorted(current)

		While sorted(nextFree) <> -1
			nextFree += 1
		Wend
		While sorted(current) = -1
			current -= 1
		Wend
	Wend
	
	Return cksum(sorted())
End Function

Function freeSize(memory() As Integer, start As Integer) As Integer
	For i As Integer = start To UBound(memory)
		If memory(i) <> -1 Then
			Return i - start
		EndIf
	Next
	
	Return UBound(memory) - start
End Function

Function part2(memory() As Integer) As Integer
	Dim sorted(0 To UBound(memory)) As Integer
	For i As Integer = 0 To UBound(memory)
		sorted(i) = memory(i)
	Next
	
	Dim current As Integer = UBound(sorted)
	Dim currentSize As Integer = 0
	For i As Integer = current To 0 Step -1
		If sorted(i) <> sorted(current) Then
			currentSize = current - i
			Exit for
		EndIf
	Next
	
	While current > 0
		Dim last As Integer = sorted(current)
		Dim nextFree As Integer = 0
		While nextFree < current
			If sorted(nextFree) = -1 Then
				If freeSize(sorted(), nextFree) >= currentSize Then
					For i As Integer = 0 To currentSize - 1
						sorted(nextFree) = sorted(current)
						sorted(current) = -1
						nextFree += 1
						current -= 1
					Next
					Exit While
				EndIf
			EndIf
			nextFree += 1
		Wend
		
		While sorted(current) = -1 Or sorted(current) = last
			current -= 1
		Wend
		For i As Integer = current To 0 Step -1
			If sorted(i) <> sorted(current) Then
				currentSize = current - i
				Exit for
			EndIf
		Next
	Wend
	
	Return cksum(sorted())
End Function


Dim l As String
Dim ff As UByte

ff = FreeFile
Open "../inputs/day09" For Input As #ff
Line Input #ff, l
Close #ff

ReDim memory(Any) As Integer
For i As Integer = 0 To Len(l) - 1
	Dim size As Integer = l[i] - 48
	ReDim Preserve memory(UBound(memory) + size)
	
	Dim fill As Integer = -1
	If i mod 2 = 0 Then
		fill = i / 2
	EndIf
	
	For j As Integer = UBound(memory) - size + 1 To UBound(memory) 
		memory(j) = fill
	Next
Next

Print part1(memory())
Print part2(memory())
