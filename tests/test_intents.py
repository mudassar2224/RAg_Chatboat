from core.intents import route_message


def test_greeting_is_answered_locally():
    reply, question = route_message("Good morning!")
    assert reply is not None
    assert "Hi!" in reply
    assert question == ""

    reply, question = route_message("Hi there!")
    assert reply is not None
    assert question == ""

    for typo in ("helo", "heel"):
        reply, question = route_message(typo)
        assert reply is not None
        assert "Hi!" in reply
        assert question == ""


def test_help_is_answered_locally():
    reply, question = route_message("I need help")
    assert reply is not None
    assert "uploaded files" in reply
    assert question == ""

    reply, question = route_message("Good morning, I need help")
    assert reply is not None
    assert "uploaded files" in reply
    assert question == ""


def test_how_are_you_is_answered_conversationally():
    reply, question = route_message("How are you?")
    assert reply is not None
    assert "I'm doing well" in reply
    assert question == ""


def test_goodbye_is_answered_locally():
    reply, question = route_message("Bye!")
    assert reply is not None
    assert "Goodbye" in reply
    assert question == ""


def test_acknowledgements_are_answered_locally():
    for phrase in ("ok", "Okay!", "got it"):
        reply, question = route_message(phrase)
        assert reply is not None
        assert "What would you like to know" in reply
        assert question == ""


def test_greeting_prefix_does_not_hide_database_question():
    reply, question = route_message("Hi, how many students are in the database?")
    assert reply is None
    assert question == "how many students are in the database?"

    reply, question = route_message("Hi, how many students are in the database? Bye!")
    assert reply is None
    assert question == "how many students are in the database?"


def test_pasted_greetings_and_help_do_not_contaminate_database_question():
    reply, question = route_message(
        "Good morning! Hi there, I need help. Hi, how many students are in the database? Bye!"
    )
    assert reply is None
    assert question == "how many students are in the database?"


def test_database_question_passes_through_unchanged():
    question = "Which faculty teach Artificial Intelligence?"
    reply, routed_question = route_message(question)
    assert reply is None
    assert routed_question == question