defmodule UnionFormRepro.Services do
  use Ash.Domain,
    otp_app: :union_form_repro

  resources do
    resource UnionFormRepro.Services.Credentials
  end
end
