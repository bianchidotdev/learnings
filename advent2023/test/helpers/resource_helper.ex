defmodule ResourceHelper do
  def get_resource(name) do
    File.read!("#{File.cwd!()}/resources/#{name}")
    |> String.trim()
  end
end
