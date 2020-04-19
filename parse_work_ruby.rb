# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'json'
require 'pry'
require 'csv'
require_relative './helpers'

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

abort('извините, но город не найден') if pages_vacancies.nil?
puts "All #{what_vacancy_find.upcase} vacancies in #{city} -> #{json_parse_vacancy['found'].to_i} pieces."

pages_vacancies.times do |page|
  request = Net::HTTP.get(URI("#{url}&page=#{page}"))
  JSON.parse(request)['items'].each { |el| all_vacancies << el }
end

abort('Sorry, but no vacancies were found') if all_vacancies.count.zero?

puts 'Vacancies for Junior interesting? ((Y)es / (N)o)'
answer_user = gets.chomp.downcase

abort('Sorry, incorrect input') unless %w[yes y no n].any? { |answer| answer_user.include?(answer) }

if %w[yes y].include?(answer_user)
  puts "Vacancies for Junior|#{what_vacancy_find.capitalize} -> #{list_junior_job(all_vacancies).count}"
  print_list_junior_job(all_vacancies)
else
  abort('No problem, Good luck!')
end

# FoundVacancy.new('Ruby', 'Moscow')
