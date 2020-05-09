def request_into_database(params)
  execute = proc do |params, par1, par2|
    if params[par1].nil?
      %|'-'|
    elsif params[par1] && params[par1][par2].nil?
      %|'-'|
    else
      %|'#{params[par1][par2]}'|
    end
  end

  date = "'#{Time.now.strftime('%d-%m-%Y')}'"
  vacancy_name = params['name'].nil? ? "'-'" : "'#{params['name']}'"
  city = "#{execute.call(params, 'area', 'name')}"
  salary_from = "#{execute.call(params, 'salary', 'from')}"
  salary_to = "#{execute.call(params, 'salary', 'to')}"
  currency = "#{execute.call(params, 'salary', 'currency')}"
  company = "#{execute.call(params, 'employer', 'name')}"

  'INSERT INTO vacancies (date, vacancy_name, city, salary_from, salary_to, currency, company) '\
  "VALUES(#{date}, #{vacancy_name}, #{city}, #{salary_from}, #{salary_to}, #{currency}, #{company})"
end
