Program day10;
Uses Classes, SysUtils;
Type TMap = Array Of Array Of Integer;

function DfsCount(map: TMap; y: Integer; x: Integer; var visited: TMap; distinct: Boolean): Integer;
var
    dX, dY: Integer;
    newX, newY: Integer;
Begin
    Result := 0;
    if (visited[y][x] = 0) or distinct Then
    Begin
        visited[y][x] := 1;
        if map[y][x] = 9 Then
        Begin
            Result := 1;
        End
        Else
        Begin
            For dY := -1 To 1 Do
            Begin
                newY := y + dY;
                If (newY < 0) Or (newY >= Length(map)) Then
                    Continue;

                For dX := -1 To 1 Do
                Begin
                    If (dX <> 0) And (dY <> 0) Then
                        Continue;
                    newX := x + dX;
                    If (newX < 0) Or (newX >= Length(map[y])) Then
                        Continue;
                    if map[newY][newX] = map[y][x] + 1 Then
                        Result += DfsCount(map, newY, newX, visited, distinct);
                End;
            End;
        End;
    End;
End;

procedure ResetVisited(var visited: TMap);
var
    y, x: Integer;
Begin
    For y := 0 To Length(visited) - 1 Do
    Begin
        For x := 0 To Length(visited[0]) - 1 Do
        Begin
            visited[y][x] := 0;
        End;
    End;
End;

function Part1(map: TMap): Integer;
Var
    row, col: Integer;
    visited: Array Of Array Of Integer;

Begin
    Result := 0;
    SetLength(visited, Length(map), Length(map[0]));

    For row := 0 To Length(map) - 1 Do
    Begin
        For col := 0 To Length(map[0]) - 1 Do
        Begin
            If map[row][col] = 0 Then
            Begin
                ResetVisited(visited);
                Result += DfsCount(map, row, col, visited, False);
            End;
        End;
    End;
End;

function Part2(map: TMap): Integer;
var
    row, col: Integer;
    visited: array of array of Integer;
Begin
    Result := 0;
    SetLength(visited, Length(map), Length(map[0]));

    For row := 0 To Length(map) - 1 Do
    Begin
        For col := 0 To Length(map[0]) - 1 Do
        Begin
            if map[row][col] = 0 Then
            Begin
                ResetVisited(visited);
                Result += DfsCount(map, row, col, visited, True);
            End;
        End;
    End;
End;

var
    input: TStringList;
    map: Array Of Array Of Integer;
    row, col: Integer;
Begin
    input := TStringList.Create;
    input.LoadFromFile('../inputs/day10');

    SetLength(map, input.Count, input[0].Length);

    For row := 0 To input.Count - 1 Do
    Begin
        For col := 1 To input[0].Length Do
        Begin
            map[row][col - 1] := Ord(input[row][col]) - Ord('0');
        End;
    End;

    WriteLn(Part1(map));
    WriteLn(Part2(map));
    ReadLn();
End.
