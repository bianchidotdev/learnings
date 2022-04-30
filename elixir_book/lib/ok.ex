defmodule OK do
  def ok!({:ok, data}) do
    data
  end

  def ok!({_, data}) do
    raise data
  end
end
