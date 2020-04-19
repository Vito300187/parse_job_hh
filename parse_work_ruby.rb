# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'json'
require_relative 'helpers'
require_relative 'google_spreadsheets'

all_vacancies = []

puts 'What is find? ( Пример => Ruby )'
what_vacancy_find = gets.chomp.downcase

puts 'Where is find? ( Ввод только на русском и с большой буквы, пример => Москва )'
city = gets.chomp.capitalize

url_pages = -> { "https://api.hh.ru/vacancies?text=#{what_vacancy_find}&per_page=100" }
url = "#{url_pages.call}&area=#{city_code(city)}"
request = Net::HTTP.get(URI(url)); nil

json_parse_vacancy = JSON.parse(request)
pages_vacancies = json_parse_vacancy['pages']

abort('Извините, но город не найден') if pages_vacancies.nil?
puts "All #{what_vacancy_find.upcase} vacancies in #{city} -> #{json_parse_vacancy['found'].to_i} pieces."

pages_vacancies.times do |page|
  request = Net::HTTP.get(URI("#{url}&page=#{page}"))
  JSON.parse(request)['items'].each { |el| all_vacancies << el }
end

abort('Извините, но вакансии не найдены') if all_vacancies.count.zero?

puts 'Какой уровень ищем? (A)ll or (J)unior ?'
answer_user = gets.chomp.downcase[0]

abort('Извините, но ввод некорректен') unless %w[A a J j].any? { |answer| answer_user.include?(answer) }

if %w[J j].include?(answer_user)
  puts "Vacancies for Junior|#{what_vacancy_find.capitalize} -> #{list_junior_job(all_vacancies).count}"
  print_list_junior_job(all_vacancies)

elsif %w[A a].include?(answer_user)
  puts "All vacancies|#{what_vacancy_find.capitalize} -> #{list_job(all_vacancies).count}"
  list_job(all_vacancies)

else
  abort('No problem, Good luck!')

end
