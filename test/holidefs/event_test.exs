defmodule Holidefs.EventTest do
  use ExUnit.Case
  alias ExIcal.Event, as: IcalEvent
  alias Holidefs.DefinitionRule
  alias Holidefs.Event

  doctest Event

  test "from_rule/2 returns an event from a rule and year" do
    rule = %DefinitionRule{name: "Christmas", month: 12, day: 25}
    assert [%Event{} = event] = Event.from_rule("us", rule, 2017)
    assert event.name == "Christmas"
    assert event.date == ~D[2017-12-25]

    rule = %DefinitionRule{name: "Test 1", month: 7, week: -1, weekday: 3}
    assert [%Event{} = event] = Event.from_rule("us", rule, 2017)
    assert event.date == ~D[2017-07-26]
  end

  test "from_calendar/1 returns an event from falback calendar event" do
    fallback_event = %IcalEvent{
      description: "Christmas",
      start: %Timex.DateTime{
        day: 25,
        month: 12,
        year: 2017
      }
    }

    assert %Event{} = event = Event.from_fallback(fallback_event)
    assert event.name == "Christmas"
    assert event.date == ~D[2017-12-25]
  end
end