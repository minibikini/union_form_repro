defmodule UnionFormRepro.Services.Credentials do
  use Ash.Resource,
    otp_app: :union_form_repro,
    domain: UnionFormRepro.Services,
    data_layer: AshSqlite.DataLayer

  sqlite do
    table "credentials"
    repo UnionFormRepro.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:access], update: [:access]]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :access, UnionFormRepro.Services.Credentials.CredentialsType do
      allow_nil? false
      public? true
    end
  end
end
