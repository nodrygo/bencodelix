# Bencodelix

** Bencode  implementation as procotol **  
stupid pure Elixir unfinished encoder decoder for Bencode
decode String only  

<b>notes</b>:  
  * dict. value are converted in string or int while key decode as symbol  
  * dict. keys order is not keep  
  * when encoded line contain multiple concateted thing they are decode in a list in same order 
  <i>Bencode.decode("6:qwerty6:azerty") == ["qwerty","azerty"]</i>

** Use Case **
 - see test for more exemples

  Bencode.encode [123,"aze"]    => "li123e3:azee"    
  Bencode.decode "li123e3:azee" => [123, "aze"]    
    dic = HashDict.new()  
    dic = Dict.put(dic, :hello, "world")  
    dic = Dict.put(dic, :number,42)  
  Bencode.decode(Bencode.encode dic) ==> dic   

