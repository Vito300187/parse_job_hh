def list_junior_job(junior_positions)
  junior_positions.select { |a| a['name'].include?('Junior') || a['name'].include?('junior') }
end

def print_list_junior_job(junior_vacancies)
  list_junior_job(junior_vacancies).each do |junior_position|
    sleep 2
    puts '- ' * 20
    puts junior_position['name']
    puts junior_position['employer']['name']
    puts junior_position['alternate_url']

    if junior_position['salary'].nil?
      puts "Зарплата не указана"
    else
      params = {}; params_word = %w[from to currency]
      params_word.each { |key| params[key] = junior_position['salary'][key].nil? ? '-' : junior_position['salary'][key] }

      puts "Зарплата От #{params['from']} до #{params['to']} #{params['currency']}"
    end

    next if junior_position['contacts'].nil?

    puts 'Контакты'
    puts junior_position['contacts']['name']
    puts junior_position['contacts']['email']
  end
end

def list_job(positions)
  puts '- ' * 30
  positions.each do |a|
    sleep 2
    puts a['name']
    puts a['alternate_url']
    puts a['employer']['name']
    puts '- ' * 30
  end
end

def get_city_code
  data_cities = Net::HTTP.get(URI('https://api.hh.ru/areas'))
  cities = []
  JSON.parse(data_cities).map do |a|
    a['areas'].each do |area|
      area['areas'].each do |ar|
        cities << { 'id' => ar['id'], 'name' => ar['name'] }
      end
    end
  end
  [{ "id" => 1, "name" => "Москва" }, { "id" => 113, "name" => "Россия" }].each { |params| cities << params }
  cities
end

def city_code(city)
  begin
    get_city_code.detect { |el| el['name'] == city }['id']
  rescue
    abort 'Город не найден, попробуйте другой город для поиска или всю Россию'
  end
end
