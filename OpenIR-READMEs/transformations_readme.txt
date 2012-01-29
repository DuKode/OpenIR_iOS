// TRANSFORMATION COMMANDS
// FOR LANDSAT GEOLOCATION AND REPROJECTION
// Contact: Ilias Koen / Arlene Ducao, team@dukode.com
//
// These commands prepare a Landsat band composite for use in Google Maps.
// Install GDAL to run these commands.
// Landsat data: http://glcf.umd.edu



/////////////////////////////////////////CURRENT TEST


//copy geographic information from geotiff to tif. 
// export geotiff information to text file. 
listgeo p012r031_7t20000927_z19_nn10.tif > p012r031_7t20000927_z19_nn10.txt 

//import text file with geographic information to landsat composites. 
geotifcp -g p012r031_7t20000927_z19_nn10.txt  p013r032_7t20001020_z18_321.tif p013r032_7t20001020_z18_321_geo.tif

 



/////////////////////////////////////////TEST 1

//export tfw 
listgeo -tfw -no_norm -proj4 p013r032_7t20001020_z18_nn10.tif


// assign tfw to tiff -- 
geotifcp -e /Users/iliaskoen/works/DuKode/digitalGraphitti/dev/band_combinations/p013r032_7t20001020_z18_nn10.tfw bandscomposites/p013r032_7t20001020_z18_321.tif  bandscomposites/p013r032_7t20001020_z18_321.geo.tif
Clio:band_combinations iliaskoen$ gdalinfo  bandscomposites/p013r032_7t20001020_z18_321.geo.tif



//assign SRS to geotiff. 
gdal_translate -a_srs '+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs' /Users/iliaskoen/works/DuKode/digitalGraphitti/dev/band_combinations/bandscomposites/p013r032_7t20001020_z18_321.geo.tif /Users/iliaskoen/works/DuKode/digitalGraphitti/dev/band_combinations/bandscomposites/p013r032_7t20001020_z18_321.geo1.tif


//export tiles 
python /Library/Frameworks/GDAL.framework/Versions/1.8/Programs/gdal2tiles.py /Users/iliaskoen/works/DuKode/digitalGraphitti/dev/band_combinations/bandscomposites/p013r032_7t20001020_z18_321.geo1.tif /Users/iliaskoen/works/DuKode/digitalGraphitti/dev/band_combinations/bandscomposites/Tiles





/////////////////////////////////////// SCRATCHPAD

gdal_translate -a_srs p013r032_7t20001020_z18_nn10.tif  /Users/iliaskoen/works/DuKode/digitalGraphitti/dev/band_combinations/bandscomposites/p013r032_7t20001020_z18_321.tif  /Users/iliaskoen/works/DuKode/digitalGraphitti/dev/band_combinations/bandscomposites/p013r032_7t20001020_z18_321.gtif 



gdal_translate -of JPEG -co "WORLDFILE=YES" p013r032_7t20001020_z18_nn10.tif p013r032_7t20001020_z18_nn10.jpeg



//generating tiles  allow_projection_difference creates issues. 
// build vrt from all imagery present in the directory. 
gdalbuildvrt -allow_projection_difference -input_file_list test_indexlist.txt test_index.vrt *.tif

//use vrt to generate tiles. 
python /Library/Frameworks/GDAL.framework/Versions/1.8/Programs/gdal2tiles.py test_index.vrt Tiles


//additional addition of multiple tiles 
gdal_translate -of GTiff -co "TILED=YES" p013r032_7t20001020_z18_nn10.tif tiledp013r032.tif
gdal_translate -of GTiff -co "TILED=YES" p013r031_7t20020908_z18_nn10.tif tiledp013r031.tif
gdal_translate -of GTiff -co "TILED=YES" p012r031_7t20000927_z19_nn40.tif tiledp012r031.tif //failed on vrt.

gdalbuildvrt -hidenodata -vrtnodata "0,0,0" test_index2.vrt tiledp013r032.tif tiledp013r031.tif tiledp012r031.tif

python /Library/Frameworks/GDAL.framework/Versions/1.8/Programs/gdal2tiles.py test_index2.vrt Tiles2





 