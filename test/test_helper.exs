ExUnit.start()

Mox.defmock(CodeComparison.LanguagesMock, for: CodeComparison.Languages.Behaviour)
Mox.defmock(CodeComparison.TopicsMock, for: CodeComparison.Topics.Behaviour)

Mox.defmock(CodeComparison.Integrations.Github.ApiMock, for: Tesla.Adapter)
