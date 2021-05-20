#!/bin/zsh

# ZSH Wrapper for Notion Developers API
# For more info:
# https://developers.notion.com/reference/intro


show_help() {
	echo '	
	Usage:
		./notion.sh function [-k/--api-key <notion_api_key>] [-d/--database-id <notion_database_id>]  [-p/--page-id <notion_page_id>] 

	Supported functions up until now:
		list_databases
		retrieve_database
		query_database
		retrieve_page
		create_page

	'
}


# PARSES ARGUMENTS

zparseopts -D -E -F - k:=api_key -api-key:=api_key \
	d:=db_id -database-id:=db_id \
	p:=pg_id -page-id:=pg_id \
	h=is_hp -help=is_hp || exit 1

# remove first -- or -
end_opts=$@[(i)(--|-)]
set -- "${@[0,end_opts-1]}" "${@[end_opts+1,-1]}"

if [[ -z $NOTION_API_KEY ]]; then
	NOTION_API_KEY=${${api_key/(-k|--api-key)}}
fi 
DATABASE_ID=${${db_id/(-d|--database-id)}}
PAGE_ID=${${pg_id/(-p|--page-id)}}
IS_HELP=$is_hp

API_FUNCTION=$1

if ! [[ -z $IS_HELP ]] || [[ $1 == 'help' ]]; then
	show_help
	exit 1
fi


echo ''

echo 'NOTION_API_KEY: '$NOTION_API_KEY
echo 'DATABASE_ID: '$DATABASE_ID
echo 'PAGE_ID: '$PAGE_ID
echo 'API_FUNCTION: '$API_FUNCTION

echo ''


# FUNCTIONS


## DATABASES

list_databases() {
	curl 'https://api.notion.com/v1/databases' \
	  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
	  -H 'Notion-Version: 2021-05-13'
}


retrieve_database() {
	curl 'https://api.notion.com/v1/databases/'$DATABASE_ID'' \
	  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
	  -H 'Notion-Version: 2021-05-13'
}


query_database() {
	echo 'Function query_database not supported yet.'
}



## PAGES


retrieve_page() {
	curl 'https://api.notion.com/v1/pages/'$PAGE_ID'' \
	  -H 'Notion-Version: 2021-05-13' \
	  -H 'Authorization: Bearer '"$NOTION_API_KEY"''
}


create_page() {
	if ! [[ -z $DATABASE_ID ]]; then
		parent_type=database_id
		parent_id=$DATABASE_ID
		db_column_name=$1
		if [[ -z $db_column_name ]]; then
			echo '[ERROR] Db column name is needed.'
			exit 1
		fi
		new_page_name=$2
		props='"properties": {
				"'$db_column_name'": {
					"title": [
						{
							"text": {
								"content": "'$new_page_name'"
							}
						}
					]
				}
			},'

	elif ! [[ -z $PAGE_ID ]]; then
		parent_type=page_id
		parent_id=$PAGE_ID
		new_page_name=$1
		props='"properties": {
				"title": [
					{
						"text": {
							"content": "'$new_page_name'"
						}
					}
				]
			},'
	else
		echo "[ERROR] Needs database or page id."
		exit 1
	fi

	children='{
				"object": "block",
				"type": "heading_2",
				"heading_2": {
					"text": [{ "type": "text", "text": { "content": "Lacinato kale" } }]
				}
			},
			{
				"object": "block",
				"type": "paragraph",
				"paragraph": {
					"text": [
						{
							"type": "text",
							"text": {
								"content": "Lacinato kale is a variety of kale with a long tradition in Italian cuisine, especially that of Tuscany. It is also known as Tuscan kale, Italian kale, dinosaur kale, kale, flat back kale, palm tree kale, or black Tuscan palm.",
								"link": { "url": "https://en.wikipedia.org/wiki/Lacinato_kale" }
							}
						}
					]
				}
			}'

	echo ''

	echo 'parent_type: '$parent_type
	echo 'parent_id: '$parent_id
	echo 'db_column_name: '$db_column_name
	echo 'new_page_name: '$new_page_name

	echo ''

	curl 'https://api.notion.com/v1/pages' \
	  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
	  -H "Content-Type: application/json" \
	  -H "Notion-Version: 2021-05-13" \
	  --data '{
		"parent": { "'$parent_type'": "'$parent_id'" },
		'$props'
		"children": [
		'$children'
		]
	}'
}


# TODO 
# Implement other functions




# SWITCH CASE

case $API_FUNCTION in
list_databases)
	# Usage: 

   echo 'Entered list_databases on switch \n'

   list_databases ${@:2}

   ;;
retrieve_database)
	# Usage: 

   echo 'Entered retrieve_database on switch \n'

   retrieve_database ${@:2}

   ;;
query_database)
	# Usage: 

   echo 'Entered query_database on switch \n'

   query_database ${@:2}

   ;;

retrieve_page)
	# Usage: 

   echo 'Entered retrieve_page on switch \n'

   retrieve_page ${@:2}

   ;;
create_page)
	# Usage: 
	# If you're creating a page inside a Database, use ./notion.sh create_page <db_column_name> <new_page_name> -d <parent_database_id> [args*]
	# If you're creating a page inside another Page, use ./notion.sh create_page <new_page_name> -p <parent_page_id> [args*]
	#
	# * Check help: -k is always needed  

   echo 'Entered create_page on switch \n'
   create_page ${@:2}

   ;;

*)
   echo 'Command not recognized.'
   ;;
esac
