defmodule TesNameGenerator.Runtime.Server do
  @type t :: pid()
  @me __MODULE__

  use Agent

  alias TesNameGenerator.Impl.NameList

  def start_link(_) do
    Agent.start_link(&NameList.names_data/0, name: @me)
  end

  def get_name(race, gender) do
    Agent.get(@me, fn names_data -> NameList.get_name(names_data, race, gender) end)
  end
end
