load './USAStates.rb'

require 'json'
require 'kmeans-clusterer'

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

def doKMeansCluster(k, data, labels)
	kmeans = KMeansClusterer.run k, data, labels: labels, runs: 100
end

######## Script begins
jsonData = jsonParseCities

populateCitiesHashAndDataArray(jsonData)

clustering = doKMeansCluster(12, @citiesData, @citiesLabels)

clustering.clusters.each do |cluster|
  puts "Cluster #{cluster.id}"
  puts "Center of Cluster: #{cluster.centroid}"
  puts "Cities in Cluster: " + cluster.points.map{ |c| c.label }.join(",")
end