defmodule TesNameGeneratorTest do
  use ExUnit.Case
  doctest TesNameGenerator

  test "tests all races and genders" do
    data = TesNameGenerator.Impl.NameList.names_data()

    race_list = [
      "altmer",
      "argonian",
      "bosmer",
      "breton",
      "dunmer",
      "imperial",
      "khajiit",
      "nord",
      "orsimer",
      "redguard"
    ]

    Enum.each(race_list, fn
      race ->
        function = String.to_atom("get_" <> race)
        male_name = apply(TesNameGenerator.Impl.NameList, function, [data, :male])
        female_name = apply(TesNameGenerator.Impl.NameList, function, [data, :female])
        refute is_nil(male_name)
        refute is_nil(female_name)
    end)
  end
end
