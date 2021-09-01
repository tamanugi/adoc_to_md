defmodule AdocToMd.Wikijs do
  @token "hoge"

  def setup() do
    Neuron.Config.set(connection_module: AdocToMd.MyConnection)
  end

  def createpage(prefix, title, body) do
    body =
      body
      |> String.replace("\n", "\\n")
      |> String.replace("\"", "\\\"")
      |> String.replace("@startuml", "```plantuml")
      |> String.replace("@enduml", "```")

    query =
      """
      mutation Page {
        pages {
          create(
            content: "#{body}"
            description: "descrizione"
            editor: "markdown"
            isPublished: true
            isPrivate: false
            locale: "ja"
            path: "/#{prefix}/#{title}"
            tags: [""]
            title: "#{title}"
          ) {
            responseResult {
              succeeded
              errorCode
              slug
              message
            }
            page {
              id
              path
              title
            }
          }
        }
      }
    }
    """

    Neuron.query(
      query,
      %{},
      url: "http://wikijs.url.input.hear",
      headers: [authorization: "Bearer #{@token}"]
    )
    |> IO.inspect()
  end
end
