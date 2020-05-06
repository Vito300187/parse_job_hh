def request_into_database(params)
  # date = %|'#{Time.now.strftime('%d-%m-%Y')}'|
  # vacancy_name = params['name'].nil? ? %|'-'| : %|'#{params['name']}'|
  # city = params['area'].nil? ? %|'-'| : %|'#{params['area']['name']}'|
  # salary_from =
  #   if params['salary'].nil?
  #     %|'-'|
  #   elsif params['salary'] && params['salary']['from'].nil?
  #     %|'-'|
  #   else
  #     %|'#{params['salary']['from']}'|
  #   end
  #
  # salary_to =
  #   if params['salary'].nil?
  #     %|'-'|
  #   elsif params['salary'] && params['salary']['to'].nil?
  #     %|'-'|
  #   else
  #     %|'#{params['salary']['to']}'|
  #   end
  #
  # currency = params['salary'].nil? ? %|'-'| : %|'#{params['salary']['currency']}'|
  # company = params['employer'].nil? ? %|'-'| : %|'#{params['employer']['name']}'|

  execute = ->(params, par1, par2) { params[par1].nil? ? "'-'" : "'#{params[par1][par2]}'" }
  date = "'#{Time.now.strftime('%d-%m-%Y')}'"
  vacancy_name = params['name'].nil? ? "'-'" : "'#{params['name']}'"
  city = "#{execute.call(params, 'area', 'name')}"
  salary_from = "#{execute.call(params, 'salary', 'from')}"
  salary_to = "#{execute.call(params, 'salary', 'to')}"
  currency = "#{execute.call(params, 'salary', 'currency')}"
  company = "#{execute.call(params, 'salary', 'name')}"

  'INSERT INTO vacancies (date, vacancy_name, city, salary_from, salary_to, currency, company) '\
  "VALUES(#{date}, #{vacancy_name}, #{city}, #{salary_from}, #{salary_to}, #{currency}, #{company})"
end

# create table vacancies (
# id serial primary key,
# date varchar NOT NULL,
# vacancy_name varchar (255),
# city varchar (255) NOT NULL,
# salary_from varchar (255) NOT NULL,
# salary_to varchar (255) NOT NULL,
# currency varchar (10),
# company varchar (255)
# )