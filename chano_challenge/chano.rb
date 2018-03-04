require "json"
require 'securerandom'
require 'byebug'

# Utility method. Extract from http://bit.ly/2s18jyO

def distance loc1, loc2
  rad_per_deg = Math::PI/180  
  rkm = 6371                  
  rm = rkm * 1000             

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c 
end

breweries = JSON.parse(File.read('./breweries.json'))['features'].map do |brewery|
  {
    id: SecureRandom.hex,
    name: brewery['properties']['name'],
    coordinates: brewery['geometry']['coordinates']
  }
end


DISTANCES = breweries.map do |origin_brewery|
  result = { origin: origin_brewery, distances: [] }
  other_breweries = breweries.select { |b| b[:id] != origin_brewery[:id] }
  other_breweries.each do |ob|
    result[:distances] << { to: ob, distance: distance(origin_brewery[:coordinates], ob[:coordinates])} 
  end
  result
end

origin_brewery = breweries[0]
other_breweries = breweries.select { |b| b[:id] != origin_brewery[:id] }

route = [{brewery: origin_brewery, distance_traveled: 0}]

others_distances = DISTANCES.first { |d| d[:origin][:id] == origin_brewery[:id] }[:distances]

other_breweries.each do |ob|
  next_brewery = others_distances.select {|od| od[:to][:id] == ob[:id]}.min_by { |id, distance| distance }
  route << { brewery: next_brewery[:to], distance_traveled: next_brewery[:distance] }
  other_breweries = other_breweries.select { |od| route.any? { |rb| 
    rb[:brewery] && rb[:brewery][:id] == od[:id] } == false 
  }
  others_distances = DISTANCES.first { |d| 
    d[:origin][:id] == next_brewery[:to][:id] 
  }[:distances]
end

puts "Distancia total recorrida: #{route.map { |r| r[:distance_traveled] }.reduce(0, :+) / 1000} Kms."
puts "Ruta: #{route.map { |e| e[:brewery][:name] }.each { |e| puts e }}"