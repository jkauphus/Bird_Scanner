"""Module for translating species labels.

Can be used to translate species names into other languages.

Uses the requests to the eBird-API.
"""
import json
import os
import urllib.request

import config as cfg
import utils

LOCALES = ['af', 'ar', 'cs', 'da', 'de', 'es', 'fi', 'fr', 'hu', 'it', 'ja', 'ko', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sv', 'th', 'tr', 'uk', 'zh']
""" Locales for 25 common languages (according to GitHub Copilot) """

API_TOKEN = "yourAPIToken"
""" Sign up for your personal access token here: https://ebird.org/api/keygen """


def getLocaleData(locale: str):
    """Download eBird locale species data.

    Requests the locale data through the eBird API.

    Args:
        locale: Two character string of a language.

    Returns:
        A data object containing the response from eBird.
    """
    url = "https://api.ebird.org/v2/ref/taxonomy/ebird?cat=species&fmt=json&locale=" + locale
    header = {"X-eBirdAPIToken": API_TOKEN}

    req = urllib.request.Request(url, headers=header)
    response = urllib.request.urlopen(req)

    return json.loads(response.read())


def translate(locale: str):
    """Translates species names for a locale.

    Translates species names for the given language with the eBird API.

    Args:
        locale: Two character string of a language.
    
    Returns:
        The translated list of labels.
    """
    print(f"Translating species names for {locale}...", end="", flush=True)

    # Get locale data
    data = getLocaleData(locale)

    # Create list of translated labels
    labels: list[str] = []

    for l in cfg.LABELS:
        has_translation = False
        for entry in data:
            if l.split("_", 1)[0] == entry["sciName"]:
                labels.append("{}_{}".format(l.split("_", 1)[0], entry["comName"]))
                has_translation = True
                break
        if not has_translation:
            labels.append(l)

    print("Done.", flush=True)

    return labels


def saveLabelsFile(labels: list[str], locale: str):
    """Saves localized labels to a file.

    Saves the given labels into a file with the format:
    "{config.LABELSFILE}_{locale}.txt"

    Args:
        labels: List of labels.
        locale: Two character string of a language.
    """
    # Create folder
    os.makedirs(cfg.TRANSLATED_LABELS_PATH, exist_ok=True)

    # Save labels file
    fpath = os.path.join(
        cfg.TRANSLATED_LABELS_PATH, "{}_{}.txt".format(os.path.basename(cfg.LABELS_FILE).rsplit(".", 1)[0], locale)
    )
    with open(fpath, "w", encoding="utf-8") as f:
        for l in labels:
            f.write(l + "\n")


if __name__ == "__main__":
    # Load labels
    cfg.LABELS = utils.readLines(cfg.LABELS_FILE)

    # Translate labels
    for locale in LOCALES:
        labels = translate(locale)
        saveLabelsFile(labels, locale)
