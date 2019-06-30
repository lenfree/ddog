defmodule DdogTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Ddog.Helper

  require IEx

  describe "pass a list of ascii input returns a string with a ' ' in between each element" do
    property "list of strings input joins as a string should be equal to build_query/1 output" do
      check all str <- list_of(filter(string(:ascii), &(String.length(&1) > 0))) do
        assert Helper.build_query(str) ==
                 str
                 |> List.flatten()
                 |> Enum.join(" ")
      end
    end
  end

  describe "add_auth/2" do
    property "pass any string should return a url string" do
      check all str <- string(:ascii),
                api_key <- string(:ascii),
                app_key <- string(:ascii) do
        System.put_env("DATADOG_API_KEY", api_key)
        System.put_env("DATADOG_APP_KEY", app_key)

        url_encoded_api_key = api_key |> URI.encode_www_form()
        url_encoded_app_key = app_key |> URI.encode_www_form()

        assert Helper.add_auth(str) ==
                 "#{str}?api_key=#{url_encoded_api_key}&application_key=#{url_encoded_app_key}"
      end
    end

    property "pass any string and query should return a url string with encoded query" do
      check all str <- string(:ascii),
                query <- map_of(string(:ascii), string(:ascii)),
                api_key <- string(:ascii),
                api_key != "",
                app_key <- string(:ascii),
                app_key != "" do
        System.put_env("DATADOG_API_KEY", api_key)
        System.put_env("DATADOG_APP_KEY", app_key)

        url_encoded_api_key = api_key |> URI.encode_www_form()
        url_encoded_app_key = app_key |> URI.encode_www_form()

        encoded_query =
          case Map.keys(query) |> length > 0 do
            true ->
              a = query |> URI.encode_query()
              a <> "&"

            false ->
              query |> URI.encode_query()
          end

        actual = Helper.add_auth(str, query)
        expected = encoded_query |> String.split("&") |> hd

        assert String.contains?(actual, expected)
        assert String.contains?(actual, url_encoded_api_key)
        assert String.contains?(actual, url_encoded_app_key)
      end
    end
  end
end
