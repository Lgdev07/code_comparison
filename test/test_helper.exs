ExUnit.start()

# Start Mox server
Mox.Server.start_link([])

# Define mocks
Mox.defmock(CodeComparison.LanguagesMock, for: CodeComparison.Languages.Behaviour)
Mox.defmock(CodeComparison.TopicsMock, for: CodeComparison.Topics.Behaviour)

Mox.defmock(CodeComparison.Integrations.Github.ApiMock, for: Tesla.Adapter)
