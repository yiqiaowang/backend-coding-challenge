defmodule Suggestions do
  @moduledoc """
  Suggestions keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def city_data do
    {_app, config} = List.first(Application.get_all_env(:suggestions))
    Enum.into(config, %{}).data
  end

  def levenshtein_cost(string) do
    len = String.length(string)

    if len < 5 do
      1
    else
      2
    end
  end
end
