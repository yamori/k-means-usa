load './USAStates.rb'

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
	
	jsonData.each do |obj|
		if obj['longitude'] > -125 # no Alaska or Hawaii please.
			# 
			city = obj['city']
			state = obj['state']
			long = obj['longitude'].to_f
			lat  = obj['latitude'].to_f
			
			# Create unique label
			label = "#{city}(#{USAStates.findStateCode(state)})"
			
			# Add to the hash (to track city uniqueness)
			@citiesHash[label] = {'longitude': long, 'latitude': lat }
			
			# Add to the arrays (which will be fed into the kmeans module)
			#  (each row corresponding to the other arrays respective row)
			@citiesLabels.push(label)
			@citiesData.push( [long, lat] )
		end
	end
end

######## Script begins
jsonData = jsonParseCities

populateCitiesHashAndDataArray(jsonData)

puts @citiesHash.length
puts @citiesData.length
puts @citiesLabels.length
