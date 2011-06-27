Public Class Form1

    Private Sub btnStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStart.Click
        Dim client As System.Net.WebClient = New System.Net.WebClient()
        Dim current_pos As Integer = 0
        Do While current_pos < TextBox1.TextLength
            Dim end_pos As Integer

            end_pos = TextBox1.Text.IndexOf(","c, current_pos)
            Dim flat As String = TextBox1.Text.Substring(current_pos, end_pos - current_pos).Trim()
            current_pos = end_pos + 1

            end_pos = TextBox1.Text.IndexOf(","c, current_pos)
            Dim flon As String = TextBox1.Text.Substring(current_pos, end_pos - current_pos).Trim()
            current_pos = end_pos + 1

            end_pos = TextBox1.Text.IndexOf(","c, current_pos)
            Dim tlat As String = TextBox1.Text.Substring(current_pos, end_pos - current_pos).Trim()
            current_pos = end_pos + 1

            end_pos = TextBox1.Text.IndexOf(","c, current_pos)
            Dim tlon As String = TextBox1.Text.Substring(current_pos, end_pos - current_pos).Trim()
            current_pos = end_pos + 1

            end_pos = TextBox1.Text.IndexOf(vbCrLf, current_pos)
            Dim distance As String = TextBox1.Text.Substring(current_pos, end_pos - current_pos).Trim()
            'leave current_pos and end_pos surrounding the distance

            If Double.Parse(distance) < 0 Then
                Dim result As String = client.DownloadString("http://www.yournavigation.org/api/1.0/gosmore.php?flat=" & flat & "&flon=" & flon & "&tlat=" & tlat & "&tlon=" & tlon & "&v=bicycle")
                Dim m As System.Text.RegularExpressions.Match = System.Text.RegularExpressions.Regex.Match(result, "<distance>(.*)</distance>")
                If m.Success Then
                    TextBox1.Text.Remove(current_pos, end_pos - current_pos)
                    TextBox1.Text.Insert(current_pos, m.Captures(0).Value)
                End If
            End If
            current_pos = TextBox1.Text.IndexOf(vbCrLf, current_pos) + vbCrLf.Length 'next line
        Loop
    End Sub
End Class
