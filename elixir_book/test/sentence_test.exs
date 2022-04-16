defmodule SentenceTest do
  use ExUnit.Case
  doctest ElixirBook

  # ch11 StringsAndBinaries-6
  test "capitalizes sentences" do
    assert Sentence.capitalize_sentences("oh. a DOG. woof. ") == "Oh. A dog. Woof. "
  end
end
