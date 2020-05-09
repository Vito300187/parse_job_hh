Programme for parsing ruby vacancies (and not only), use api hh.ru.

Variable ```find_request``` in file ```parser_hh_to_csv.rb``` - search query.

Unfortunately the query depth can't be more than 2000 results.

For run need input command in console -> ```ruby parser_hh_to_csv.rb```

Create postgres database:

```
create table vacancies (
id serial primary key,
date varchar NOT NULL,
vacancy_name varchar (255) NOT NULL,
city varchar (255) NOT NULL,
salary_from varchar (255) NOT NULL,
salary_to varchar (255) NOT NULL,
currency varchar (10) NOT NULL,
company varchar (255) NOT NULL
)
```
