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

  def decode(s), do: pdecode(String.replace(s,"\n"," "),[])

  defp pdecode(<<>>,acc) do 
    [first|rest] = acc
    if length(rest) >0 do 
       acc 
    else
       first
    end

  end

  defp pdecode(bin,acc) do
    case pdecode1(bin) do 
      {nil,r} -> pdecode(r,acc)
      {v,r}   -> pdecode(r,[v|acc])
    end
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
  defp pdecode1(<<n::integer, x::binary>> = bin)  when n >= ?0 and n <= ?9 do
    case Regex.run(%r/^([0-9]+):(.*)/gm, bin) do 
      [_, strl,r ] -> {lon,_} = Integer.parse(strl)
                       <<s::[binary, size(lon)],rest::binary>> = r
                        {s,rest}
      nil ->  {"Fal Decode string",x} 
    end                  
  end

  # leave other char
  defp pdecode1(<<_::integer, rest::binary>>) do
    {nil,rest}
  end

  # leave other char
  defp pdecode1("") do
    {nil,""}
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
    # IO.puts "pdecodeDic bin is #{inspect bin}"    
    {k,rest} = pdecode1(bin)
    {v,rest} = pdecode1(rest)
    # IO.puts "pdecodeDic k is #{inspect k} v is #{inspect v}"
    case {k,v} do
      {nil,nil} -> dic = Dict.put(dic, :internalerror, "key and val nil") 
      {nil,_} -> dic = Dict.put(dic, :internalerror, "key is nil")
      {k,nil} -> dic = Dict.put(dic, Kernel.binary_to_atom(k), "")
      {k,v} ->   dic = Dict.put(dic, Kernel.binary_to_atom(k) , v)
    end
    pdecodeDic(rest,dic)
  end

  defp pdecodeDic(<<_::integer, rest::binary>>) do
    IO.puts "pdecodeDic acc is #{inspect rest}"
    {nil,rest}
  end
end