defmodule IndicadoresDesenvolvimento do
  def execute do
    result =
      File.read("indicadores.txt")
      |> handle_file()
      |> Enum.join("\n")

    "indicador_new.txt"
    |> File.write(result)

    IO.inspect(result, char_lists: :as_lists)

    {:ok, result}
  end

  defp handle_file({:ok, content}) do
    content
    |> String.split("\n")
    |> Enum.map(&format_line/1)
  end

  defp format_line(content) do
    content
    |> String.split(";")
    |> Enum.map(&format_column/1)
    |> Enum.join(";")
  end

  def format_column(content) do
    content
    |> String.replace("\"FORMAT_JIRA_TIME(", "")
    |> String.replace("\")", "")
    |> String.replace("\"", "")
    |> String.split(" ")
    |> Enum.map(&get_time_form_string/1)
    |> Enum.sum()
  end

  defp get_time_form_string(value) do
    value
    |> Float.parse()
    |> get_days()
  end

  defp get_days({value, digito}) when digito == "H" or digito == "h", do: value |> Float.round(2)

  defp get_days({value, digito}) when digito == "D" or digito == "d",
    do: (value * 8) |> Float.round(2)

  defp get_days({value, digito}) when digito == "W" or digito == "w",
    do: (value * 40) |> Float.round(2)

  defp get_days({value, digito}) when digito == "M" or digito == "m",
    do: (value / 60) |> Float.round(2)
end
