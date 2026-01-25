import re
import json
import sys

# Define the new image URLs map
car_updates = [
    ("Acura", "Integra", "https://upload.wikimedia.org/wikipedia/commons/7/78/%E2%80%9823_Acura_Integra_A-Spec.jpg"),
    ("Alfa Romeo", "Giulia", "https://upload.wikimedia.org/wikipedia/commons/6/6f/Alfa_Romeo_Giulia_Veloce_IMG_5945.jpg"),
    ("Aston Martin", "DB12", "https://upload.wikimedia.org/wikipedia/commons/a/a6/Aston_Martin_DB12_IMG_0286.jpg"),
    ("Audi", "A6", "https://upload.wikimedia.org/wikipedia/commons/e/ed/Audi_A6_I_Genf_2018.jpg"),
    ("Bentley", "Continental GT", "https://upload.wikimedia.org/wikipedia/commons/3/36/0_Bentley_Continental_GT_%283rd_gen.%29_1.jpg"),
    ("BMW", "X5", "https://upload.wikimedia.org/wikipedia/commons/4/43/2020_BMW_X5_xDrive30d_M_Sport_Automatic_3.0_Front.jpg"),
    ("Bugatti", "Chiron", "https://upload.wikimedia.org/wikipedia/commons/4/32/2018_Bugatti_Chiron_3.jpg"),
    ("Buick", "Enclave", "https://upload.wikimedia.org/wikipedia/commons/0/0e/Buick_Enclave.jpg"),
    ("BYD", "Atto 3", "https://www.byd.com/eu/car/atto3/galery/atto3-exterior-07.jpg"),
    ("Cadillac", "Escalade", "https://upload.wikimedia.org/wikipedia/commons/2/23/Cadillac_Escalade_III_front.JPG"),
    ("Chevrolet", "Corvette Stingray", "https://www.apchevy.com/inventory/new-East%2BDundee-2025-Chevrolet-Corvette%2BStingray-3LT-1G1YC2D48S5112708/1.jpg"),
    ("Chery", "Tiggo 8 Pro", "https://static.autox.com/uploads/2022/05/Chery-Tiggo-8-Pro-front-three-quarter.jpg"),
    ("Chrysler", "Pacifica", "https://cdn.motor1.com/images/mgl/0ANk5/s1/2023-chrysler-pacifica.jpg"),
    ("Citroën", "C5 Aircross", "https://upload.wikimedia.org/wikipedia/commons/6/62/2022_Citroen_C5_Aircross_Facelift.jpg"),
    ("Cupra", "Formentor", "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Cupra_Formentor_IMG_3655.jpg/1200px-Cupra_Formentor_IMG_3655.jpg"), # Generic replacement
    ("Dodge", "Challenger Hellcat", "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Dodge_Challenger_SRT_Hellcat_Redeye_%282019%29_IMG_2887.jpg/1200px-Dodge_Challenger_SRT_Hellcat_Redeye_%282019%29_IMG_2887.jpg"), # Generic replacement
    ("Ferrari", "SF90 Stradale", "https://upload.wikimedia.org/wikipedia/commons/8/8e/2020_Ferrari_SF90_Stradale_%28Front%29.jpg"),
    ("Fiat", "500e", "https://upload.wikimedia.org/wikipedia/commons/5/54/2021_Fiat_500e_La_Prima_front.jpg"),
    ("Ford", "Mustang GT", "https://upload.wikimedia.org/wikipedia/commons/b/b4/2024_Ford_Mustang_GT_in_Yellow_Splash.jpg"),
    ("Force Motors", "Gurkha", "https://www.autocarindia.com/datastore/images/cms-originals/480x360/2024-Force-Gurkha-5-door-front-three-quarters.jpg"),
    ("Genesis", "G80", "https://upload.wikimedia.org/wikipedia/commons/2/24/Genesis_G80_3.5T_AWD.jpg"),
    ("Geely", "Coolray", "https://upload.wikimedia.org/wikipedia/commons/c/c5/Geely_Binyue_002.jpg"),
    ("GMC", "Hummer EV", "https://upload.wikimedia.org/wikipedia/commons/0/04/GMC_Hummer_EV_2022.jpg"),
    ("Great Wall Motors", "Tank 300", "https://www.thecarconnection.com/images/sized/960/24294/2023_gwm_tank_300_angularfront.jpg"),
    ("Honda", "Civic Type R", "https://upload.wikimedia.org/wikipedia/commons/f/f9/2023_Honda_Civic_Type_R_front_4.30.23.jpg"),
    ("Hyundai", "IONIQ 5", "https://upload.wikimedia.org/wikipedia/commons/0/09/2022_Hyundai_Ioniq_5_Ultimate_AWD.jpg"),
    ("Infiniti", "QX60", "https://upload.wikimedia.org/wikipedia/commons/a/a4/2022_Infiniti_QX60_SENSORY_3.5L_front_left.jpg"),
    ("Isuzu", "D-Max V-Cross", "https://cdni.autocarindia.com/ExtraImages/20210629022200_Isuzu-D-Max-V-Cross-front-three-quarter.jpg"),
    ("Jaguar", "F-TYPE", "https://upload.wikimedia.org/wikipedia/commons/d/d4/2019_Jaguar_F-Type_R-Dynamic_front.jpg"),
    ("Jeep", "Wrangler", "https://upload.wikimedia.org/wikipedia/commons/0/0f/Jeep_Wrangler_%28JL%29_in_Silver.jpg"),
    ("Kia", "EV6", "https://upload.wikimedia.org/wikipedia/commons/7/70/2022_Kia_EV6_GT-Line.jpg"),
    ("Lamborghini", "Revuelto", "https://cdn.motor1.com/images/mgl/0x0jPo/s1/lamborghini-revuelto-front-three-quarters.jpg"),
    ("Land Rover", "Defender", "https://upload.wikimedia.org/wikipedia/commons/0/04/2020_Land_Rover_Defender_110_SE_D180.jpg"),
    ("Lexus", "RX", "https://upload.wikimedia.org/wikipedia/commons/c/cf/2023_Lexus_RX_350h_Premium%2B_front.jpg"),
    ("Mahindra", "XUV700", "https://cdni.autocarindia.com/ExtraImages/20211102101919_XUV700.jpg"),
    ("Maruti Suzuki", "Grand Vitara", "https://cdni.autocarindia.com/ExtraImages/20220720040954_Maruti-Grand-Vitara-front-3-quarters.jpg"),
    ("Maserati", "MC20", "https://upload.wikimedia.org/wikipedia/commons/e/e1/Maserati_MC20_2022.jpg"),
    ("Mercedes-Benz", "S-Class", "https://upload.wikimedia.org/wikipedia/commons/b/b3/2021_Mercedes-Benz_S_500_AMG_Line_Plus.jpg"),
    ("Mini", "Cooper S", "https://cdn.motor1.com/images/mgl/YxVZrA/s1/2024-mini-cooper-s-front-quarter.jpg"),
    ("Mitsubishi", "Outlander", "https://upload.wikimedia.org/wikipedia/commons/2/2e/2022_Mitsubishi_Outlander_SE_AWD.jpg"),
    ("Nissan", "GT-R", "https://upload.wikimedia.org/wikipedia/commons/3/3f/2017_Nissan_GT-R_Premium_in_Pearl_White.jpg"),
    ("Opel", "Astra", "https://upload.wikimedia.org/wikipedia/commons/0/0c/Opel_Astra_L_1.2_Turbo_130_Elegance_%28cropped%29.jpg"),
    ("Peugeot", "408", "https://upload.wikimedia.org/wikipedia/commons/c/cf/Peugeot_408_2022_IMG_7125.jpg"),
    ("Porsche", "911 GT3", "https://upload.wikimedia.org/wikipedia/commons/1/19/2022_Porsche_911_GT3_%28992%29_in_Sapphire_Blue_Metallic.jpg"),
    ("Renault", "Kiger", "https://cdni.autocarindia.com/ExtraImages/20210203045046_Renault-Kiger.jpg"),
    ("Rolls-Royce", "Phantom", "https://upload.wikimedia.org/wikipedia/commons/e/e0/2023_Rolls-Royce_Phantom_Series_II.jpg"),
    ("Škoda", "Kodiaq", "https://upload.wikimedia.org/wikipedia/commons/7/75/2021_Skoda_Kodiaq_Style_facelift_front.jpg"),
    ("Subaru", "WRX", "https://upload.wikimedia.org/wikipedia/commons/f/fd/2022_Subaru_WRX_Limited_in_Solar_Orange_Pearl.jpg"),
    ("Suzuki", "Jimny", "https://cdni.autocarindia.com/ExtraImages/20230113053838_Maruti-Suzuki-Jimny-5-door.jpg"),
    ("Tata Motors", "Nexon", "https://cdni.autocarindia.com/ExtraImages/20230914120256_Tata-Nexon.jpg"),
    ("Tesla", "Model S Plaid", "https://upload.wikimedia.org/wikipedia/commons/4/44/Tesla_Model_S_Plaid.jpg"),
    ("Toyota", "Land Cruiser", "https://upload.wikimedia.org/wikipedia/commons/3/3f/2022_Toyota_Land_Cruiser_300_Sahara_ZX.jpg"),
    ("Volkswagen", "Golf R", "https://upload.wikimedia.org/wikipedia/commons/c/c3/Volkswagen_Golf_VIII_R_IMG_4303.jpg"),
]

# Read file
try:
    with open('lib/services/car_data.dart', 'r', encoding='utf-8') as f:
        content = f.read()
except Exception as e:
    # Try different encoding or just read roughly
    with open('lib/services/car_data.dart', 'r', encoding='latin-1') as f:
        content = f.read()

replacements = []
not_found = []

for brand, model, new_url in car_updates:
    # Match brand specially for Skoda
    if brand == "Škoda":
        brand_regex = r"brand: '.*koda'"
    else:
        brand_regex = f"brand: '{re.escape(brand)}'"
        
    model_regex = f"model: '{re.escape(model)}'"
    
    # Pattern: Look for brand... then model... then imageUrl.
    # We want to replace the whole imageUrl line.
    
    # Regex Explanation:
    # 1. (brand: 'Brand',[\s\S]*?model: 'Model',[\s\S]*?) -> specific car context (Group 1)
    # 2. (imageUrl: ')([^']+)(') -> The image URL line (Groups 2, 3, 4)
    
    regex = re.compile(
        f"({brand_regex},[\\s\\S]*?{model_regex},[\\s\\S]*?imageUrl: ')([^']+?)(')",
        re.MULTILINE
    )
    
    match = regex.search(content)
    if match:
        full_match = match.group(0)
        prefix = match.group(1)
        old_url = match.group(2)
        suffix = match.group(3)
        
        # Create replacement chunk
        # Constraint: StartLine/EndLine needed for multi_replace_file_content?
        # No, the tool uses TargetContent.
        # But wait, multi_replace uses StartLine and EndLine arguments.
        # I need to calculate line numbers!
        
        # Calculate line numbers
        start_index = match.start()
        end_index = match.end()
        
        pre_content = content[:start_index]
        start_line = pre_content.count('\n') + 1
        
        match_content = content[start_index:end_index]
        match_lines = match_content.count('\n')
        end_line = start_line + match_lines
        
        replacement = {
            "StartLine": start_line,
            "EndLine": end_line,
            "TargetContent": full_match,
            "ReplacementContent": prefix + new_url + suffix,
            "AllowMultiple": False
        }
        replacements.append(replacement)
    else:
        # Try flipping model/brand order locally just in case? No, standardized.
        not_found.append(f"{brand} {model}")

# Output result
print(json.dumps({
    "replacements": replacements,
    "not_found": not_found
}, indent=2))
