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

  test "encode decode empty string" do
    assert(Bencode.decode(Bencode.encode "") == "")
  end

  test "encode decode string" do
    assert(Bencode.decode(Bencode.encode "aze") == "aze")
  end

  test " decode susccessive string" do
    assert(Bencode.decode("6:qwerty6:azerty") == ["qwerty","azerty"])
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

  test "decode multine text" do
    s = """
d2:ex45:class clojure.lang.Compiler$CompilerException7:root-ex45:class clojure.lang.Compiler$CompilerException7:session36:3ea0cb6b-47ff-4105-b308-a4f26774cdf86:statusl10:eval-erroreed
"""
    assert(Bencode.decode(s) == Bencode.decode(s))
  end

  test "decode complex datas" do
    # when miltiple values are concatened we return a list
    sin = """
d2:ex45:class clojure.lang.Compiler$CompilerException7:root-ex45:class clojure.lang.Compiler$CompilerException7:session36:3ea0cb6b-47ff-4105-b308-a4f26774cdf86:statusl10:eval-erroreed3:err123:CompilerException java.lang.RuntimeException: Unable to resolve symbol: e in this context, compiling:(NO_SOURCE_PATH:0:0) 
...(7)> 7:session36:3ea0cb6b-47ff-4105-b308-a4f26774cdf8ed2:ns4:user7:session36:3ea0cb6b-47ff-4105-b308-a4f26774cdf85:value1:8ed7:session36:3ea0cb6b-47ff-4105-b308-a4f26774cdf86:statusl4:doneee
"""
    l = Bencode.decode(sin)
    # IO.puts ("Complex datas #{inspect l} ")
    e = Bencode.encode(l)
    n = Bencode.decode(e)
    # when re-decode the  encoded decoded should be same
    assert(l == n )
  end
end

 