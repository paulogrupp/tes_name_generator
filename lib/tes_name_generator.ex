defmodule TesNameGenerator do
  defdelegate get_name(race, gender), to: TesNameGenerator.Runtime.Server
end
