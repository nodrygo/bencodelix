# Bencodelix

** Bencode  implementation as procotol **  
stupid pure Elixir unfinished encoder decoder for Bencode
decode String only  

notes: for dict. value are converted in string or int while key decode as symbol 

** Use Case **

  Bencode.encode [123,"aze"]    => "li123e3:azee"    
  Bencode.decode "li123e3:azee" => [123, "aze"]    
    dic = HashDict.new()  
    dic = Dict.put(dic, :hello, "world")  
    dic = Dict.put(dic, :number,42)  
  Bencode.decode(Bencode.encode dic) ==> dic   

