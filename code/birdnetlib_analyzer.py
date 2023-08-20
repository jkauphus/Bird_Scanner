# Install Packages

from birdnetlib.batch import DirectoryAnalyzer
from birdnetlib.analyzer import Analyzer
from birdnetlib.species import SpeciesList
from datetime import datetime
from pprint import pprint
import pandas as pd

# Set-up configurations

dir_path = args_d
lat = args_lat
lon = args_lon
conf = args_threshold

# Week Extraction

def extract_week_from_filename(dir_path):
    # Define the expected date format in the filename
    date_format = "TEXT_%Y%m%d_%H%M%S.wav"
    
    try:
        # Parse the filename using the defined date format
        dt = datetime.strptime(dir_path, date_format)
        
        # Extract the week of the year using the timetuple method
        week_of_year = dt.timetuple().tm_yday // 7 + 1
        
        return week_of_year
    except ValueError:
        return None

# Load and initialize the BirdNET-Analyzer models.

# Create an empty list to store the output data
output_data = []

def on_analyze_complete(recording):
    global output_data
    for detection in recording.detections:
        detection_info = {
            'filename': recording.path.split('/')[-1],  # Extracting filename from the path
            'full_path': recording.path,
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
        date=extract_week_from_filename(dir_path),
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
        lon=-120.7463, lat=35.4244, date=datetime(year=2022, month=5, day=10)
    )
    species_df = pd.DataFrame(species_list)

    # Save the DataFrames to an Excel file with multiple sheets
    excel_filename = 'output_data_with_sheets.xlsx'
    
    with pd.ExcelWriter(excel_filename, engine='xlsxwriter') as writer:
        df.to_excel(writer, sheet_name='Detections', index=False)
        species_df.to_excel(writer, sheet_name='SpeciesList', index=False)

    print(f"Data saved as '{excel_filename}'")

# Call the function to run the analysis and save to Excel
run_analysis_and_save_excel()
