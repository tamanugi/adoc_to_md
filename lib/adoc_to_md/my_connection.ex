defmodule AdocToMd.MyConnection do
  @behaviour Neuron.Connection

  @impl Neuron.Connection
  def call(body, options) do
    IO.inspect("NEURON CALLED")
    IO.inspect(options)
    Neuron.Connection.Http.call(body, options)
  end
end
