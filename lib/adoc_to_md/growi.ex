defmodule AdocToMd.Growi do
  @host_url "hoge"
  @access_token "hoge"

  def create_page(page_path, page_body) do
    post("/pages", %{
      path: page_path,
      body: page_body,
      access_token: @access_token
    })
  end

  def post(path, body) do
    url = growi_endpoint(path)
    HTTPoison.post!(url, Jason.encode!(body), %{"Content-type": "application/json"})
  end

  def growi_endpoint(path) do
    "#{@host_url}#{path}"
  end
end
