defmodule Project2 do
  [numNodes, topology, algo] = System.argv()

  Proj2.main(String.to_integer(numNodes), topology, algo)
end
