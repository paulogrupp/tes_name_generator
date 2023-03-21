defmodule TesNameGeneratorTest do
  use ExUnit.Case
  doctest TesNameGenerator

  test "tests all races and genders" do
    data = TesNameGenerator.Impl.NameList.names_data()
    race_list = ["altmer", "argonian", "bosmer", "breton", "dunmer", "imperial", "khajiit", "nord"]

    Enum.each(race_list, fn
      race ->
        function = String.to_atom("get_" <> race)
        apply(TesNameGenerator.Impl.NameList, function, [data, :male])
        apply(TesNameGenerator.Impl.NameList, function, [data, :female])
    end)
  end
end
