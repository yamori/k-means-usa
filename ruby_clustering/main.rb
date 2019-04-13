load './USAStates.rb'
load './ClusteredCity.rb'

require 'json'
require 'kmeans-clusterer'

######## Important vars defined, variables that shouldn't change much
jsonData = nil
@citiesHash = Hash.new # instance of ClusteredCity
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
		population = obj['population'].to_i
		
		# Create unique label
		label = "#{city}(#{USAStates.findStateCode(state)})"
		
		# Add to the hash (to track city uniqueness)
		@citiesHash[label] = ClusteredCity.new(label, long, lat, population)
		
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
	# Iterate over data, and put into a CSV format, then write file.
	
	file = File.open(CSV_OUT_FILE, "w") # 'w' means it overwrite if file already exists
	# Iterate over each cluster(size is k)
	clustering.clusters.each do |cluster|
		clusterNumber = cluster.id # Convenient, otherwise we'd have to use an each_with_index
		
		# Iterate over all the points in the cluster
		cluster.points.each  do |point|
			label = point.label
			# Use the Hash to grab the coordinates!
			cityObject = @citiesHash[label]
			
			# Write to file
			file.write("#{clusterNumber},#{label},#{cityObject.longitude}," + ","*clusterNumber + "#{cityObject.latitude},\n")
		end
	end
	file.close
end

def addClusteringToCitiesHash(k, clustering)
	# Iterate over data, put into a structure, then write a JSON file.
	
	clusteredCities = []
	
	clustering.clusters.each do |cluster|
		clusterNumber = cluster.id # Convenient, otherwise we'd have to use an each_with_index
		# Iterate over all the points in the cluster
		cluster.points.each  do |point|
			label = point.label
			cityObject = @citiesHash[label]
			
			# Add the clustering info
			cityObject.addClusterMembership(k, clusterNumber)
		end
	end
end

######## Script begins
jsonData = jsonParseCities

populateCitiesHashAndDataArray(jsonData)

k=12
clustering = doKMeansCluster(k, @citiesData, @citiesLabels)

# csvPrintByCluster(clustering)

addClusteringToCitiesHash(k, clustering)

ClusteredCity.writeHashToJSONFile(@citiesHash, "cityClustering.json")