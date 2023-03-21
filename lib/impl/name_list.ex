defmodule TesNameGenerator.Impl.NameList do
  @type t :: map()

  @spec names_data :: t
  def names_data do
    "../../assets/data.json"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Poison.Parser.parse!(%{keys: :atoms})
  end

  ############################## ALTMER ##############################
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

  ############################## ARGONIAN ##############################
  def get_argonian(names_data, gender) do
    [true, false]
    |> Enum.random()
    |> get_argonian(names_data, gender)
  end

  defp get_argonian(_tamrielic = true, data, _gender) do
    Enum.random(data.argonian.neutral.verb) <>
      "-" <>
      Enum.random(data.argonian.neutral.center) <> "-" <> Enum.random(data.argonian.neutral.noun)
  end

  defp get_argonian(_tamrielic = false, data, gender) do
    [true, false]
    |> Enum.random()
    |> get_argonian_by_modifier(data, gender)
  end

  defp get_argonian_by_modifier(_with_modifier = true, data, gender) do
    Enum.random(data.argonian[gender].middle) <> "-" <> Enum.random(data.argonian[gender].middle)
  end

  defp get_argonian_by_modifier(_with_modifier = false, data, gender) do
    Enum.random(data.argonian[gender].begin) <> Enum.random(data.argonian[gender].end)
  end

  ############################## BOSMER ##############################
  def get_bosmer(names_data, gender) do
    Enum.random(names_data.bosmer[gender].begin) <> Enum.random(names_data.bosmer[gender].end)
  end

  ############################## BRETON ##############################
  def get_breton(names_data, gender) do
    Enum.random(names_data.breton[gender].name) <>
      " " <> Enum.random(names_data.breton.neutral.surname)
  end

  ############################## DUNMER ##############################
  def get_dunmer(names_data, gender) do
    Enum.random(names_data.dunmer[gender].name) <>
      " " <> Enum.random(names_data.dunmer.neutral.surname)
  end

  ############################## IMPERIAL ##############################
  def get_imperial(names_data, gender) do
    Enum.random(names_data.imperial[gender].name) <>
      " " <> Enum.random(names_data.imperial.neutral.surname)
  end

  ############################## KHAJIIT ##############################
  def get_khajiit(names_data, gender) do
    type = Enum.random(["prefix", "suffix", "none"])

    apply_khajiit_prefix(names_data, type, gender)
    |> apply_khajiit_begin(names_data, gender)
    |> apply_khajiit_long(names_data, gender)
    |> apply_khajiit_end(names_data, gender)
    |> apply_khajiit_suffix(names_data, type, gender)
  end

  defp apply_khajiit_prefix(data, "prefix", gender) do
    "" <> Enum.random(data.khajiit[gender].prefix)
  end

  defp apply_khajiit_prefix(_, _, _), do: ""

  defp apply_khajiit_begin(base, data, gender) do
    base <> Enum.random(data.khajiit[gender].begin)
  end

  defp apply_khajiit_end(base, data, gender) do
    base <> Enum.random(data.khajiit[gender].end)
  end

  defp apply_khajiit_suffix(base, data, "suffix", gender) do
    base <> Enum.random(data.khajiit[gender].suffix)
  end

  defp apply_khajiit_suffix(base, _, _, _), do: base

  defp apply_khajiit_long(base, data, gender) do
    Enum.random([true, false])
    |> apply_khajiit_long(base, data, gender)
  end

  defp apply_khajiit_long(true, base, data, gender) do
    base <> Enum.random(data.khajiit[gender].middle)
  end

  defp apply_khajiit_long(false, base, _, _), do: base

  ############################## NORD ##############################

  def get_nord(names_data, gender) do
    (Enum.random(names_data.nord[gender].begin) <> Enum.random(names_data.nord[gender].end))
    |> apply_nord_modifier(names_data)
  end

  defp apply_nord_modifier(base, data) do
    Enum.random(["none", "title", "adjective-noun", "adjective-verb"])
    |> apply_nord_modifier(base, data)
  end

  defp apply_nord_modifier("title", base, data) do
    base <> " the " <> Enum.random(data.nord.neutral.title)
  end

  defp apply_nord_modifier("adjective-noun", base, data) do
    base <>
      " " <>
      Enum.random(data.nord.neutral.adjective) <> "-" <> Enum.random(data.nord.neutral.noun)
  end

  defp apply_nord_modifier("adjective-verb", base, data) do
    base <>
      " " <>
      Enum.random(data.nord.neutral.adjective) <> "-" <> Enum.random(data.nord.neutral.verb)
  end

  defp apply_nord_modifier(_, base, _), do: base
end
