defmodule Utils.URIHandler do
  def decode_uri(uri) do
    {
      :ok,
      %{parsed_path: %{data: raw_data, mediatype: mediatype}}
    } =
      URL.new(uri)
    do_decode_uri(raw_data, mediatype)
  end

  def do_decode_uri(data, "image/svg+xml"), do: data
  def do_decode_uri(data, "application/json") do
    data
    |> Poison.decode!()
    |> ExStructTranslator.to_atom_struct()
  end

end
