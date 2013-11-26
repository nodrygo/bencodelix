defmodule BencodelixTest do
  use ExUnit.Case

  test "encode int" do
    assert(Bencode.encode(42) == "i42e")
  end

  test "encode minus int" do
    assert(Bencode.encode(-42) == "i-42e")
  end

  test "decode  int" do
    assert(Bencode.decode("i42e") == 42)
  end

  test "decode minus int" do
    assert(Bencode.decode("i-42e") == -42)
  end

  test "encode str" do
    assert(Bencode.encode("azerty") == "6:azerty")
  end

  test "encode list" do
    assert(Bencode.encode([42,"az"]) == "li42e2:aze")
  end

  test "encode decode string" do
    assert(Bencode.decode(Bencode.encode "aze") == "aze")
  end

  test "encode  dic" do
    dict = HashDict.new()
    dict = Dict.put(dict, :hello, :world)
    assert(Bencode.encode dict == ["d5:hello5:worlde"])
  end 

  test "encode decode dic" do
    # Warning Key is converted into key, value are converted into string 
    dic = HashDict.new()
    dic = Dict.put(dic, :hello, "world")
    dic = Dict.put(dic, :number,42)
    assert(Bencode.decode(Bencode.encode dic) ==  dic)
  end  

  test "encode decode nested list" do
     l = [1,2,"aze",["a"]]
     assert(Bencode.decode(Bencode.encode(l)) == l )
  end    
end

