defmodule WebSpirit.Fetcher do
  def async(camera_name) do
    parent = self()
    spawn(fn -> send(parent, {:result, WebSpirit.VideoCam.get_snapshot(camera_name)}) end)
  end

  def get_result do
    receive do {:result, filename} -> filename end
  end
end
