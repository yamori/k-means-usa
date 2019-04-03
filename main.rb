require 'json'

######## Important vars defined, variables that shouldn't change much
jsonData = nil
@citiesHash = Hash.new

######## Method definitions

def jsonParseCities
	parsedData = nil
	File.open('data/USA_cities.json') do |f|
		parsedData = JSON.parse(f.read)
		# This block automatically closes File.open
	end
	return parsedData
end

def populateCitiesHash(jsonData)
	cityDuplicateHash = Hash.new # Use this to track multiple cities
	
	jsonData.each do |obj|
		if obj['longitude'] > -125 # no Alaska or Hawaii please.
			city = obj['city']
			if cityDuplicateHash[city] != nil
				# Increment and append
				cityDuplicateHash[city] += 1
			else
				# First time this city detected
				cityDuplicateHash[city] = 1
			end
			city = city + cityDuplicateHash[city].to_s
			puts city
		end
	end
end

######## Script begins

jsonData = jsonParseCities

populateCitiesHash(jsonData)



# darn: grep -irn springfield data/USA_cities.json