# notion-zsh-wrapper

ZSH Wrapper for Notion Developers API.

For more info check the [Notion Developers](https://developers.notion.com) website. 

And for instructions on how to get an Notion API Key, [check here](https://developers.notion.com/docs).



### Usage: 

`./notion.zsh function [-k/--api-key <notion_api_key>] [-d/--database-id <notion_database_id>]  [-p/--page-id <notion_page_id>]`

Supported functions up until now:
```
list_databases
retrieve_database
retrieve_page
create_page
```

## create_page

#### Usage: 

If you're creating a page inside a Database, use `./notion.zsh create_page <db_column_name> <new_page_name> -d <parent_database_id> [args*]`

If you're creating a page inside another Page, use `./notion.zsh create_page <new_page_name> -p <parent_page_id> [args*]`

_* Check help: -k is always needed._
