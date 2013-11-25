import Kernel

defprotocol Bencode do 
   def encode(thing)
   def decode(thing)
end  

defimpl Bencode,  for:  Atom do
  def encode(a) do
     Bencode.encode(Kernel.atom_to_binary(a))
  end
  def decode(_) do
    raise "no specific decoder for this type" 
  end

end

defimpl Bencode,  for:  Integer do
  def encode(i) do
      "i#{i}e"
  end
  def decode(_) do
    raise "no specific decoder for this type" 
  end
end
  
defimpl Bencode, for: List do
  def encode(thing) do
      l = lc x inlist thing, do: [Bencode.encode(x)]
      String.from_char_list!(List.flatten(["l", l, "e"]))
  end  
  def decode(_) do
    raise "no specific decoder for this type" 
  end
end

defimpl Bencode, for: HashDict do
  def encode(dict) do
    l = lc k inlist Dict.keys(dict), do: [Bencode.encode(k), Bencode.encode(Dict.get(dict, k))]
    String.from_char_list!(List.flatten(["d",  l , "e"]))
  end
  def decode(_) do
    raise "no specific decoder for this type" 
  end
end  

defimpl Bencode,  for: BitString do

  def encode(thing) when is_binary(thing) do
    if String.printable?(thing) do
       String.from_char_list!(List.flatten(["#{byte_size(thing)}:", thing]))
    end
  end

  def encode(_), do:  raise "encode error not a printable String"

  def decode(s), do: pdecode(s,[])

  defp pdecode(<<>>,acc), do: :lists.reverse(acc)
  defp pdecode(bin,acc) do acc
      {v,r} = pdecode1(bin)
      pdecode(r,[v|acc])
  end

  # decode integer
  defp pdecode1(<<?i, rest::binary>>) do
    [_, i,rest] = Regex.run(%r/([-0-9]+)e(.*)$/, rest)
    {i , _ } = Integer.parse(i)
    {i, rest}
  end

  # decode list
  defp pdecode1(<<?l, rest::binary>>) do
    pdecodeList(rest,[])
  end

  # decode dict 
  defp pdecode1(<<?d, rest::binary>>) do
    dic = HashDict.new()
    pdecodeDic(rest,dic)
  end

  # decode string
  defp pdecode1(<<n::integer, _::binary>> = bin)  when n >= ?0 and n <= ?9 do
      [_, strl,rest] = Regex.run(%r/^([0-9]+):(.*)$/, bin)
      {lon,_} = Integer.parse(strl)
      <<s::[binary, size(lon)],rest::binary>> = rest 
    {s,rest}
  end

  # decode string
  # defp pdecode1(bin), do: raise "unable to decode #{bin}"
  defp pdecodeList(<<>>,acc), do: {:lists.reverse(acc),<<>>}
  defp pdecodeList(<<?e, rest::binary>>,acc), do: {:lists.reverse(acc),rest}
  defp pdecodeList(bin,acc) do
    {e,rest} = pdecode1(bin)
    pdecodeList(rest,[e|acc])
  end 

  defp pdecodeDic(<<>>,dic), do: {dic,<<>>}
  defp pdecodeDic(<<?e, rest::binary>>,dic) do
    {dic,rest}
  end 

  defp pdecodeDic(bin,dic) do
    {k,rest} = pdecode1(bin)
    {v,rest} = pdecode1(rest)
    dic = Dict.put(dic, Kernel.binary_to_atom(k) , v)
    pdecodeDic(rest,dic)
  end
end