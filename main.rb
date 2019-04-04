require 'json'

######## Important vars defined, variables that shouldn't change much
jsonData = nil
@citiesHash = Hash.new
@citiesData = []
@citiesLabels = []

######## Method definitions
def jsonParseCities
	parsedData = nil
	File.open('data/USA_cities.json') do |f|
		parsedData = JSON.parse(f.read)
		# This block automatically closes File.open
	end
	return parsedData
end

def populateCitiesHashAndDataArray(jsonData)
	cityDuplicateHash = Hash.new # Use this to track multiple cities
	
	jsonData.each do |obj|
		if obj['longitude'] > -125 # no Alaska or Hawaii please.
			# 
			city = obj['city']
			long = obj['longitude'].to_f
			lat  = obj['latitude'].to_f
			
			if cityDuplicateHash[city] != nil
				# Increment and append
				cityDuplicateHash[city] += 1
			else
				# First time this city detected
				cityDuplicateHash[city] = 1
			end
			city = city + cityDuplicateHash[city].to_s # Appends the number to the city
			
			# Add to the hash (to track city uniqueness)
			@citiesHash[city] = {'longitude': long, 'latitude': lat }
			
			# Add to the arrays (which will be fed into the kmeans module)
			#  (each row corresponding to the other arrays respective row)
			@citiesLabels.push(city)
			@citiesData.push( [long, lat] )
		end
	end
end

######## Script begins
jsonData = jsonParseCities

populateCitiesHashAndDataArray(jsonData)

puts @citiesData[0..3].inspect
puts @citiesLabels[0..3].inspect
