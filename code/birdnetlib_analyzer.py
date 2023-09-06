# Install Packages

from birdnetlib.batch import DirectoryAnalyzer
from birdnetlib.analyzer import Analyzer
from birdnetlib.species import SpeciesList
import os
from datetime import datetime
from pprint import pprint
import pandas as pd

# Set-up configurations

dir_path = args_d
lat = args_lat
lon = args_lon
day = args_day
month = args_mon
year = args_yr
conf = args_threshold

# Load and initialize the BirdNET-Analyzer models.

# Create an empty list to store the output data
output_data = []

def on_analyze_complete(recording):
    global output_data
    for detection in recording.detections:
        detection_info = {
            'filename': os.path.basename(recording.path),  # Extracting filename from the path
            'full_path': recording.path,
            'latitude': lat,
            'longitude': lon,
            'date': datetime(year=year, month=month, day=day),
            **detection  # Include existing detection data
        }
        output_data.append(detection_info)

def on_error(recording, error):
    print("An exception occurred: {}".format(error))
    print(recording.path)

def run_analysis_and_save_excel():
    print("Starting Analyzer")
    analyzer = Analyzer()

    print("Starting Watcher")
    directory = dir_path
    batch = DirectoryAnalyzer(
        directory,
        analyzers=[analyzer],
        lon=lon,
        lat=lat,
        date=datetime(year=year, month=month, day=day),
        min_conf=conf,
    )

    batch.on_analyze_complete = on_analyze_complete
    batch.on_error = on_error
    batch.process()

    # Convert the output data to a pandas DataFrame
    df = pd.DataFrame(output_data)

    # Get the species list
    species = SpeciesList()
    species_list = species.return_list(
        lon=lon, lat=lat, date=datetime(year=year, month=month, day=day)
    )
    species_df = pd.DataFrame(species_list)

    # Save the DataFrames to an Excel file with multiple sheets
    # Get today's date in YYYY-MM-DD format
    today_date = datetime.today().strftime('%Y-%m-%d')
    
    # Construct the Excel file name with today's date
    excel_filename = f'birdNET_results_{today_date}.xlsx'
    
    output_folder = "./results_tables/"
    full_excel_path = os.path.join(output_folder, excel_filename)

    with pd.ExcelWriter(full_excel_path, engine='xlsxwriter') as writer:
        df['latitude'] = lat
        df['longitude'] = lon
        df.to_excel(writer, sheet_name='Detections', index=False)
        species_df.to_excel(writer, sheet_name='SpeciesList', index=False)

    print(f"Data saved as '{full_excel_path}'")

# Call the function to run the analysis and save to Excel
run_analysis_and_save_excel()
