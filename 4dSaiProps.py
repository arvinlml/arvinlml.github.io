import requests
from urllib.parse import urlencode
import time
from bs4 import BeautifulSoup
from tqdm import tqdm
from concurrent.futures import ThreadPoolExecutor, as_completed
from threading import Lock

results_lock = Lock()

def scan_single_property(property_id, base_url, search_text):
    """Scan a single property and return result if match found"""
    params = {
        "zoneNo": "14",
        "collectionType": "online",
        "propertyId": f"{property_id:05d}",
        "search1": "Search",
        "subNo": "000",
        "wardNo": "189"
    }
    
    try:
        response = requests.get(base_url, params=params, timeout=10)
        response.raise_for_status()
        
        # Extract Owner Name from response
        soup = BeautifulSoup(response.text, 'html.parser')
        owner_name = soup.find('td', string=lambda x: x and 'Owner' in x)
        owner_value = owner_name.find_next('td').text if owner_name else "Not found"
        property_address = soup.find('td', string=lambda x: x and 'Property Address' in x)
        property_address_value = property_address.find_next('td').text if property_address else "Not found"
        
        # Parse response to extract Property Address and New Bill No
        if search_text.lower() in response.text.lower():
            print(f"Match found for Property ID {property_id:05d}: {owner_value}, {property_address_value}")
            return {
                "propertyId": property_id,
                "url": response.url,
                "property_address_value": property_address_value,
                "owner_value": owner_value  
            }
        
        return None
        
    except requests.exceptions.RequestException as e:
        print(f"Error for Property ID {property_id:05d}: {e}")
        return None

def scan_properties(start_id, end_id, search_text, max_workers=10):
    base_url = "https://erp.chennaicorporation.gov.in/ptis/citizensearch/searchPropByBillNumber!search.action"
    results = []
    
    # Use ThreadPoolExecutor for parallel requests
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {
            executor.submit(scan_single_property, property_id, base_url, search_text): property_id 
            for property_id in range(start_id, end_id + 1)
        }
        
        # Process completed futures as they finish
        for future in tqdm(as_completed(futures), total=len(futures), desc="Scanning properties"):
            result = future.result()
            if result:
                with results_lock:
                    results.append(result)
                print(f"Found: Property ID {result['propertyId']:05d}")
    
    return results

# Scan from 07100 to 30000
matches = scan_properties(30000, 35000, "Sai Sujeet", max_workers=10)
print(f"\nTotal matches found: {len(matches)}")
for match in matches:
    print(f"Property ID: {match['propertyId']:05d}")