defmodule TesNameGenerator.Impl.NameList do
  @type t :: map()

  @spec names_data :: t
  def names_data do
    "../../assets/data.json"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Poison.Parser.parse!(%{keys: :atoms})
  end

  def get_altmer(names_data, gender = :male) do
    get_altmer_begin(names_data, gender) <>
      get_altmer_middle(names_data, gender) <>
      get_altmer_end(names_data, gender)
  end

  def get_altmer(names_data, gender = :female) do
    get_altmer_begin(names_data, gender) <>
    get_altmer_end(names_data, gender)
  end

  defp get_altmer_begin(data, gender) do
    Enum.random(data.altmer[gender].begin)
  end

  defp get_altmer_middle(data, gender) do
    Enum.take_random(data.altmer[gender].middle, Enum.random(0..2))
    |> Enum.join("")
  end

  defp get_altmer_end(data, gender) do
    Enum.random(data.altmer[gender].end)
  end
end
