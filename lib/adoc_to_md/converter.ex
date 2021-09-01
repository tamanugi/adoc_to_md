defmodule AdocToMd.Converter do
  def adoc2md(file_path) do
    lines =
      file_path
      |> File.read!()
      |> String.split("\n")
      |> convert()
      |> Enum.map(fn line ->
        # 末尾の + を スペース二つに変換する
        String.replace(line, ~r/\+$/, "  ")
        |> String.replace(~r/^=*/, "")
      end)
      |> Enum.reverse()

    title = lines |> List.first() |> String.replace("#", "") |> String.replace(" ", "")

    %{
      title: title,
      body: lines |> Enum.join("\n")
    }
  end

  def convert(lines, state \\ :none, acc \\ [])

  # Header
  for i <- 2..6 do
    def convert([unquote(String.duplicate("=", i) <> " ") <> line | rest], state, acc),
      do: convert(rest, state, [unquote(String.duplicate("#", i - 1) <> " ") <> line | acc])
  end

  def convert(["[[" <> _ | rest], state, acc), do: convert(rest, state, acc)

  # list
  def convert(["*** " <> line | rest], state, acc),
    do: convert(rest, state, ["    - " <> line | acc])

  def convert(["** " <> line | rest], state, acc),
    do: convert(rest, state, ["  - " <> line | acc])

  def convert(["* " <> line | rest], state, acc),
    do: convert(rest, state, ["- " <> line | acc])

  # Plantuml
  def convert(["[plantuml]" | rest], _state, acc),
    do: convert(rest, :uml, ["@startuml" | acc])

  def convert(["----" | rest], :uml, acc),
    do: convert(rest, :start_uml, acc)

  def convert(["----" | rest], :start_uml, acc),
    do: convert(rest, :none, ["@enduml" | acc])

  # Note
  def convert(["[NOTE]" | rest], _state, acc),
    do: convert(rest, :note, ["" | acc])

  def convert(["====" | rest], :note, acc),
    do: convert(rest, :start_note, ["```\n[NOTE]" | acc])

  def convert(["====" | rest], :start_note, acc),
    do: convert(rest, :none, ["```" | acc])

  # Codeblock
  def convert(["[source," <> syntax | rest], _state, acc),
    do: convert(rest, {:start, String.replace_suffix(syntax, "]", "")}, acc)

  def convert(["----" <> _ | rest], {:start, syntax}, acc),
    do: convert(rest, :none, ["```#{syntax}" | acc])

  def convert(["----" <> _ | rest], state, acc), do: convert(rest, state, ["```" | acc])

  # Other
  def convert([line | rest], state, acc), do: convert(rest, state, [line | acc])

  # end
  def convert([], _state, acc), do: acc
end
