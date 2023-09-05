"""Module to create a remote endpoint for classification.

Can be used to start up a server and feed it classification requests.
"""
import argparse
import json
import os
import tempfile
from datetime import date, datetime
from multiprocessing import freeze_support

import bottle

import analyze
import config as cfg
import species
import utils


def resultPooling(lines: list[str], num_results=5, pmode="avg"):
    """Parses the results into list of (species, score).

    Args:
        lines: List of result scores.
        num_results: The number of entries to be returned.
        pmode: Decides how the score for each species is computed.
               If "max" used the maximum score for the species,
               if "avg" computes the average score per species.

    Returns:
        A List of (species, score).
    """
    # Parse results
    results = {}

    for line in lines:
        d = line.split("\t")
        species = d[2].replace(", ", "_")
        score = float(d[-1])

        if not species in results:
            results[species] = []

        results[species].append(score)

    # Compute score for each species
    for species in results:
        if pmode == "max":
            results[species] = max(results[species])
        else:
            results[species] = sum(results[species]) / len(results[species])

    # Sort results
    results = sorted(results.items(), key=lambda x: x[1], reverse=True)

    return results[:num_results]


@bottle.route("/healthcheck", method="GET")
def healthcheck():
    """Checks the health of the running server.
    Returns:
        A json message.
    """
    return json.dumps({"msg": "Server is healthy."})


@bottle.route("/analyze", method="POST")
def handleRequest():
    """Handles a classification request.

    Takes a POST request and tries to analyze it.

    The response contains the result or error message.

    Returns:
        A json response with the result.
    """
    # Print divider
    print(f"{'#' * 20}  {datetime.now()}  {'#' * 20}")

    # Get request payload
    upload = bottle.request.files.get("audio")
    mdata = json.loads(bottle.request.forms.get("meta", {}))

    if not upload:
        return json.dumps({"msg": "No audio file."})

    print(mdata)

    # Get filename
    name, ext = os.path.splitext(upload.filename.lower())
    file_path = upload.filename
    file_path_tmp = None

    # Save file
    try:
        if ext[1:].lower() in cfg.ALLOWED_FILETYPES:
            if mdata.get("save", False):
                save_path = os.path.join(cfg.FILE_STORAGE_PATH, str(date.today()))

                os.makedirs(save_path, exist_ok=True)

                file_path = os.path.join(save_path, name + ext)
            else:
                save_path = ""
                file_path_tmp = tempfile.NamedTemporaryFile(suffix=ext.lower(), delete=False)
                file_path_tmp.close()
                file_path = file_path_tmp.name

            upload.save(file_path, overwrite=True)
        else:
            return json.dumps({"msg": "Filetype not supported."})

    except Exception as ex:
        if file_path_tmp:
            os.unlink(file_path_tmp.name)

        # Write error log
        print(f"Error: Cannot save file {file_path}.", flush=True)
        utils.writeErrorLog(ex)

        # Return error
        return json.dumps({"msg": "Error while saving file."})

    # Analyze file
    try:
        # Set config based on mdata
        if "lat" in mdata and "lon" in mdata:
            cfg.LATITUDE = float(mdata["lat"])
            cfg.LONGITUDE = float(mdata["lon"])
        else:
            cfg.LATITUDE = -1
            cfg.LONGITUDE = -1

        cfg.WEEK = int(mdata.get("week", -1))
        cfg.SIG_OVERLAP = max(0.0, min(2.9, float(mdata.get("overlap", 0.0))))
        cfg.SIGMOID_SENSITIVITY = max(0.5, min(1.0 - (float(mdata.get("sensitivity", 1.0)) - 1.0), 1.5))
        cfg.LOCATION_FILTER_THRESHOLD = max(0.01, min(0.99, float(mdata.get("sf_thresh", 0.03))))

        # Set species list
        if not cfg.LATITUDE == -1 and not cfg.LONGITUDE == -1:
            cfg.SPECIES_LIST_FILE = None
            cfg.SPECIES_LIST = species.getSpeciesList(cfg.LATITUDE, cfg.LONGITUDE, cfg.WEEK, cfg.LOCATION_FILTER_THRESHOLD)
        else:
            cfg.SPECIES_LIST_FILE = None
            cfg.SPECIES_LIST = []

        # Analyze file
        success = analyze.analyzeFile((file_path, cfg.getConfig()))

        # Parse results
        if success:
            # Open result file
            lines = utils.readLines(cfg.OUTPUT_PATH)
            pmode = mdata.get("pmode", "avg").lower()

            # Pool results
            if pmode not in ["avg", "max"]:
                pmode = "avg"

            num_results = min(99, max(1, int(mdata.get("num_results", 5))))

            results = resultPooling(lines, num_results, pmode)

            # Prepare response
            data = {"msg": "success", "results": results, "meta": mdata}

            # Save response as metadata file
            if mdata.get("save", False):
                with open(file_path.rsplit(".", 1)[0] + ".json", "w") as f:
                    json.dump(data, f, indent=2)

            # Return response
            del data["meta"]

            return json.dumps(data)

        else:
            return json.dumps({"msg": "Error during analysis."})

    except Exception as e:
        # Write error log
        print(f"Error: Cannot analyze file {file_path}.", flush=True)
        utils.writeErrorLog(e)

        data = {"msg": f"Error during analysis: {e}"}

        return json.dumps(data)
    finally:
        if file_path_tmp:
            os.unlink(file_path_tmp.name)


if __name__ == "__main__":
    # Freeze support for executable
    freeze_support()

    # Parse arguments
    parser = argparse.ArgumentParser(description="API endpoint server to analyze files remotely.")
    parser.add_argument(
        "--host", default="0.0.0.0", help="Host name or IP address of API endpoint server. Defaults to '0.0.0.0'"
    )
    parser.add_argument("--port", type=int, default=8080, help="Port of API endpoint server. Defaults to 8080.")
    parser.add_argument(
        "--spath", default="uploads/", help="Path to folder where uploaded files should be stored. Defaults to '/uploads'."
    )
    parser.add_argument("--threads", type=int, default=4, help="Number of CPU threads for analysis. Defaults to 4.")
    parser.add_argument(
        "--locale",
        default="en",
        help="Locale for translated species common names. Values in ['af', 'de', 'it', ...] Defaults to 'en'.",
    )

    args = parser.parse_args()

    # Load eBird codes, labels
    cfg.CODES = analyze.loadCodes()
    cfg.LABELS = utils.readLines(cfg.LABELS_FILE)

    # Load translated labels
    lfile = os.path.join(
        cfg.TRANSLATED_LABELS_PATH, os.path.basename(cfg.LABELS_FILE).replace(".txt", "_{}.txt".format(args.locale))
    )

    if not args.locale in ["en"] and os.path.isfile(lfile):
        cfg.TRANSLATED_LABELS = utils.readLines(lfile)
    else:
        cfg.TRANSLATED_LABELS = cfg.LABELS

    # Set storage file path
    cfg.FILE_STORAGE_PATH = args.spath

    # Set min_conf to 0.0, because we want all results
    cfg.MIN_CONFIDENCE = 0.0

    output_file = tempfile.NamedTemporaryFile(suffix=".txt", delete=False)
    output_file.close()

    # Set path for temporary result file
    cfg.OUTPUT_PATH = output_file.name

    # Set result type
    cfg.RESULT_TYPE = "audacity"

    # Set number of TFLite threads
    cfg.TFLITE_THREADS = max(1, int(args.threads))

    # Run server
    print(f"UP AND RUNNING! LISTENING ON {args.host}:{args.port}", flush=True)

    try:
        bottle.run(host=args.host, port=args.port, quiet=True)
    finally:
        os.unlink(output_file.name)
