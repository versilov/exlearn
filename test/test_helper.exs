ExUnit.start()

Code.require_file("test/test_utils.exs")

Path.wildcard("test/fixtures/**/*_fixtures.exs")
|> Enum.map(&Code.require_file/1)
