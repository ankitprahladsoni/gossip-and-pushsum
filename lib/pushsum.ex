defmodule Pushsum do
  import NeighborFactory

  def start(numNodes, topology) do
    initialize_actors(numNodes, topology)

    start_time = System.system_time(:millisecond)
    AlgoCommons.initiate_process(numNodes, {:pushsum, 0, 0})
    time_diff = System.system_time(:millisecond) - start_time
    IO.puts("Total time for convergence: #{time_diff} milliseconds")
  end

  def initialize_actors(numNodes, topology) do
    numNodes = correctNumNodesForGrids(numNodes, topology)
    range = 1..numNodes
    random2dGrid = Enum.shuffle(range) |> Enum.with_index(1)

    for i <- range do
      spawn(fn -> PushsumActor.start_link(i, getNeighbor(i, numNodes, topology, random2dGrid)) end)
      |> Process.monitor()
    end
  end
end
