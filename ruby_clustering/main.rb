load './USAStates.rb'

require 'json'
require 'kmeans-clusterer'

######## Important vars defined, variables that shouldn't change much
jsonData = nil
@citiesHash = Hash.new
@citiesData = []
@citiesLabels = []
CSV_OUT_FILE = "clustering.csv" # ignored by git.  (yay Ruby constants!!!)

######## Method definitions
def jsonParseCities
	parsedData = nil
	File.open('../data/USA_cities.json') do |f|
		parsedData = JSON.parse(f.read)
		# This block automatically closes File.open
	end
	return parsedData
end

def populateCitiesHashAndDataArray(jsonData)
	
	jsonData.each do |obj|
		if obj['longitude'] < -125 # no Alaska or Hawaii please.
			next
		end
		
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

def doKMeansCluster(k, data, labels)
	kmeans = KMeansClusterer.run k, data, labels: labels, runs: 100
end

def csvPrintByCluster(clustering)
	file = File.open(CSV_OUT_FILE, "w") # 'w' means it overwrite if file already exists
	# Iterate over each cluster(size is k)
	clustering.clusters.each do |cluster|
		clusterNumber = cluster.id # Convenient, otherwise we'd have to use an each_with_index
		
		# Iterate over all the points in the cluster
		cluster.points.each  do |point|
			label = point.label
			
			# Use the Hash to grab the coordinates!
			latLong = @citiesHash[label]
			
			# Write to file
			file.write("#{clusterNumber},#{label},#{latLong[:longitude]}," + ","*clusterNumber + "#{latLong[:latitude]},\n")
		end
	end
	file.close
end

######## Script begins
jsonData = jsonParseCities

populateCitiesHashAndDataArray(jsonData)

clustering = doKMeansCluster(12, @citiesData, @citiesLabels)

csvPrintByCluster(clustering)