defmodule Sentence do
  @moduledoc """
  Provides functions for sentence structures.

  ## Examples

    iex> Sentence.capitalize_sentences("hi There. what's happening?")
    "Hi there. What's happening?"

  """
  def capitalize_sentences(string) do
    string
    |> String.split(". ")
    |> Enum.map_join(". ", &String.capitalize/1)
  end
end
