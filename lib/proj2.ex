defmodule Proj2 do
  def main(numNodes, topology, algo) do
    Registry.start_link(keys: :unique, name: :registry)

    case algo do
      "gossip" -> Gossip.start(numNodes, topology)
      "pushsum" -> Pushsum.start(numNodes, topology)
    end
  end
end
