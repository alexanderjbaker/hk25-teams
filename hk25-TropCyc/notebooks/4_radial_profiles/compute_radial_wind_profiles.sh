#!/bin/bash
## Compute radial wind profiles with TempestExtremes' NodeFileEditor
## By Alexander Baker

# Script Parameters
run='um_glm_n1280_GAL9' # Code of your simulation (must be the reference in the catalog)
zoom=9

u_name='uas'
v_name='vas'
bin_count=159
bin_width=0.125

# Folders
scr_dir='/work/scratch-nopw2/bakera/' # Change to your own scratch/temporary folder
data_pp_dir=$scr_dir/$run/data_healpix # dir to store preprocessed (pp) files

# Input
tracks_file="../../TC_tracks/$run.csv"

# Connectivity File
CONNECT_FILE=/home/users/sbourdin/WCRP_Hackathon/hk25-teams/hk25-TropCyc/ConnectivityFiles/ConnectivityFiles_for_healpix_zoom_$zoom.txt

# Output
out_nodefile="../../${var}/${run}_rprof.nc"

# Prepare file list
flist=`ls $data_pp_dir/*${var}_zoom_${zoom}.nc`
INPUT=""
for f in $flist
do
    INPUT="$INPUT$f;"
done
INPUT=${INPUT:0:-1} # Remove last ;
echo $INPUT > INPUT.txt

conda run -n hackathon NodeFileEditor \
--in_nodefile "$tracks_file" \
--in_connect $CONNECT_FILE \
--in_nodefile_type "SN" \
--in_fmt "(auto)" \
--in_data_list "INPUT.txt" \
--out_fmt "(auto),rprof" \
--out_nodefile "$out_nodefile" \
--calculate "rprof=radial_wind_profile($u_name,$v_name,$bin_count,$bin_width)"
