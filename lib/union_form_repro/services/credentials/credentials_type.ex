defmodule UnionFormRepro.Services.Credentials.CredentialsType do
  use Ash.Type.NewType,
    subtype_of: :union,
    constraints: [
      types: [
        xyz: [
          type: :struct,
          constraints: [instance_of: UnionFormRepro.Services.Credentials.XyzCredentials],
          tag: :type,
          tag_value: :xyz
        ]
      ]
    ]
end
