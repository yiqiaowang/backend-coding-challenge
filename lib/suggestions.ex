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
end
