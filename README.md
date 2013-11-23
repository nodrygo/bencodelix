# Bencodelix

** Bencode  implementation as procotol **  
stupid pure Elixir unfinished encoder decoder for Bencode
decode String only

** Use Case **

  Bencode.encode [123,"aze"] => "li123e3:azee"  
  Bencode.decode "li123e3:azee" => [[123, "aze"]]  
  dict = HashDict.new()    
  dict = Dict.put(dict, :hello, :world)  
  Bencode.decode(Bencode.encode dict) => [#HashDict<[{"a", 1}, {"b", 2}, {"hello", "world"}]>]  
