defmodule UnionFormRepro.Services.Credentials.XyzCredentials do
  use Ash.Resource, data_layer: :embedded

  actions do
    defaults [:read, create: [:api_key], update: [:api_key]]
  end

  attributes do
    attribute :api_key, :string, allow_nil?: false, public?: true
  end
end
