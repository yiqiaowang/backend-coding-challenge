defmodule Suggestions do
  @moduledoc """
  Suggestions keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def city_data do
    "cities_canada-usa_sample.tsv"
  end

  def levenshtein_cost do
    3
  end
end
