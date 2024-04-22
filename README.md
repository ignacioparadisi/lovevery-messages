# Design

```mermaid
flowchart TD
	HTTPClient --> RemoteDataSource
	RemoteDataSource --> MessageRepository
	MessageRepository --> UsersViewModel
	MessageRepository --> ConversationViewModel
	MessageRepository --> SendMessageViewModel
	UsersViewModel --> UsersView
	ConversationViewModel --> ConversationView
	SendMessageViewModel --> SendMessageView
```

