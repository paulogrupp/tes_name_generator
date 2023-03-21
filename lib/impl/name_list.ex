defmodule TesNameGenerator.Impl.NameList do
  @type t :: map()

  @spec names_data :: t
  def names_data do
    "../../assets/data.json"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Poison.Parser.parse!(%{keys: :atoms})
  end

  @race_list [
    :altmer,
    :argonian,
    :bosmer,
    :breton,
    :dunmer,
    :imperial,
    :khajiit,
    :nord,
    :orsimer,
    :redguard
  ]

  ############################## ALTMER ##############################
  def get_altmer(names_data, gender) do
    data = names_data.altmer[gender]

    get_altmer_begin(data) <>
      get_altmer_middle(data) <>
      get_altmer_end(data)
  end

  defp get_altmer_begin(data) do
    Enum.random(data.begin)
  end

  defp get_altmer_middle(data) do
    get_altmer_middle_by_presence(data[:middle])
  end

  defp get_altmer_middle_by_presence(nil), do: ""

  defp get_altmer_middle_by_presence(data) do
    Enum.take_random(data, Enum.random(0..2))
    |> Enum.join("")
  end

  defp get_altmer_end(data) do
    Enum.random(data.end)
  end

  ############################## ARGONIAN ##############################
  def get_argonian(names_data, gender) do
    [true, false]
    |> Enum.random()
    |> get_argonian(names_data.argonian, gender)
  end

  defp get_argonian(_tamrielic = true, data, _gender) do
    data = data.neutral

    Enum.random(data.verb) <>
      "-" <>
      Enum.random(data.center) <> "-" <> Enum.random(data.noun)
  end

  defp get_argonian(_tamrielic = false, data, gender) do
    [true, false]
    |> Enum.random()
    |> get_argonian_by_modifier(data[gender])
  end

  defp get_argonian_by_modifier(_with_modifier = true, data) do
    Enum.random(data.middle) <> "-" <> Enum.random(data.middle)
  end

  defp get_argonian_by_modifier(_with_modifier = false, data) do
    Enum.random(data.begin) <> Enum.random(data.end)
  end

  ############################## BOSMER ##############################
  def get_bosmer(names_data, gender) do
    data = names_data.bosmer[gender]
    Enum.random(data.begin) <> Enum.random(data.end)
  end

  ############################## BRETON ##############################
  def get_breton(names_data, gender) do
    data = names_data.breton

    Enum.random(data[gender].name) <>
      " " <> Enum.random(data.neutral.surname)
  end

  ############################## DUNMER ##############################
  def get_dunmer(names_data, gender) do
    data = names_data.dunmer

    Enum.random(data[gender].name) <>
      " " <> Enum.random(data.neutral.surname)
  end

  ############################## IMPERIAL ##############################
  def get_imperial(names_data, gender) do
    data = names_data.imperial

    Enum.random(data[gender].name) <>
      " " <> Enum.random(data.neutral.surname)
  end

  ############################## KHAJIIT ##############################
  def get_khajiit(names_data, gender) do
    data = names_data.khajiit[gender]
    type = Enum.random(["prefix", "suffix", "none"])

    apply_khajiit_prefix(data, type)
    |> apply_khajiit_begin(data)
    |> apply_khajiit_long(data)
    |> apply_khajiit_end(data)
    |> apply_khajiit_suffix(data, type)
  end

  defp apply_khajiit_prefix(data, "prefix") do
    "" <> Enum.random(data.prefix)
  end

  defp apply_khajiit_prefix(_, _), do: ""

  defp apply_khajiit_begin(base, data) do
    base <> Enum.random(data.begin)
  end

  defp apply_khajiit_end(base, data) do
    base <> Enum.random(data.end)
  end

  defp apply_khajiit_suffix(base, data, "suffix") do
    base <> Enum.random(data.suffix)
  end

  defp apply_khajiit_suffix(base, _, _), do: base

  defp apply_khajiit_long(base, data) do
    Enum.random([true, false])
    |> apply_khajiit_long(base, data)
  end

  defp apply_khajiit_long(true, base, data) do
    base <> Enum.random(data.middle)
  end

  defp apply_khajiit_long(false, base, _), do: base

  ############################## NORD ##############################

  def get_nord(names_data, gender) do
    nord_data = names_data.nord
    data = nord_data[gender]

    (Enum.random(data.begin) <> Enum.random(data.end))
    |> apply_nord_modifier(nord_data)
  end

  defp apply_nord_modifier(base, data) do
    Enum.random(["none", "title", "adjective-noun", "adjective-verb"])
    |> apply_nord_modifier(base, data.neutral)
  end

  defp apply_nord_modifier("title", base, data) do
    base <> " the " <> Enum.random(data.title)
  end

  defp apply_nord_modifier("adjective-noun", base, data) do
    base <>
      " " <>
      Enum.random(data.adjective) <> "-" <> Enum.random(data.noun)
  end

  defp apply_nord_modifier("adjective-verb", base, data) do
    base <>
      " " <>
      Enum.random(data.adjective) <> "-" <> Enum.random(data.verb)
  end

  defp apply_nord_modifier(_, base, _), do: base

  ############################## ORSIMER ##############################
  def get_orsimer(names_data, gender) do
    data = names_data.orsimer

    (Enum.random(data[gender].name) <> orsimer_surname_prefix(gender))
    |> get_orsimer_surname(data, Enum.random(["father", "mother", "surname"]))
  end

  defp orsimer_surname_prefix(:male), do: " gro-"
  defp orsimer_surname_prefix(:female), do: " gra-"

  defp get_orsimer_surname(base, data, "father") do
    base <> Enum.random(data.male.name)
  end

  defp get_orsimer_surname(base, data, "mother") do
    base <> Enum.random(data.female.name)
  end

  defp get_orsimer_surname(base, data, "surname") do
    base <> Enum.random(data.neutral.surname)
  end

  ############################## REDGUARD ##############################
  def get_redguard(names_data, gender) do
    Enum.random(names_data.redguard[gender].name)
  end
end
