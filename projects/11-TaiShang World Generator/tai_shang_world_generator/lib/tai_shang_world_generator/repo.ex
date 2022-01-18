defmodule TaiShangWorldGenerator.Repo do
  use Ecto.Repo,
    otp_app: :tai_shang_world_generator,
    adapter: Ecto.Adapters.Postgres
end
