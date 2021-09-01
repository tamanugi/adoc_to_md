defmodule AdocToMd do
  alias AdocToMd.Converter
  alias AdocToMd.Growi
  alias AdocToMd.Wikijs

  def run(dir, prefix) do
    Path.wildcard("#{dir}/**/*.adoc")
    |> Enum.map(&Converter.adoc2md/1)
    |> Enum.each(fn %{title: title, body: body} ->
      page_path = "/#{prefix}/#{title}"
      # Growi.create_page(page_path, body)
      Wikijs.createpage(prefix, title, body)

      # File.write!("output/resortwork/#{title}.md", body)
    end)
  end
end
