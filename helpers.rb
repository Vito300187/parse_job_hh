# TODO Если в списке нет нужного города, то выводить exception, со словами что указаннный город, не найден. Вынести в loop,
# чтобы спрашивая "Попробуем другой город?" можно было либо вновь дождаться корректного ответа, либо закончить программу

def list_junior_job(junior_positions)
  junior_positions.select { |a| a['name'].include?('Junior') || a['name'].include?('junior') }
end

def print_list_junior_job(junior_vacancies)
  list_junior_job(junior_vacancies).each do |junior_position|
    sleep 1
    puts '-' * 20
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

    puts 'Контакты не указаны' if junior_position['contacts'].nil?
    next if junior_position['contacts'].nil?

    puts junior_position['contacts']['name']
    puts junior_position['contacts']['email']
    puts junior_position['contacts']['phones']
    puts '-' * 20
  end
end

def list_job(positions)
  puts '-' * 30
  positions.each do |a|
    sleep 1
    puts a['name']
    puts a['alternate_url']
    puts a['employer']['name']
    puts '-' * 30
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
  cities << { "id" => 1, "name" => "Москва" }
  cities
end

def city_code(city)
  get_city_code.detect { |el| el['name'] == city }['id']
end
