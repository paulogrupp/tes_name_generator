defmodule TesNameGenerator.Runtime.Server do
  @type t :: pid()
  @me __MODULE__

  use Agent

  alias TesNameGenerator.Impl.NameList

  def start_link(_) do
    # Agent.start_link(&NameList.word_list/0, name: @me)
  end

  def random_name(race) do
    # Agent.get(@me, &NameList.random_word/1)
  end
end
