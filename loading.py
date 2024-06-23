import os
import json
import duckdb
from datetime import datetime

# Define the input directory
input_dir = "/home/ahmed/work/datasets/Football/Extra_data/events/data/"

# Dictionaries to avoid communication with the database unless necessary
inserted_countries = {}
inserted_stadiums = {}
inserted_referees = {}
inserted_managers = {}
inserted_teams = {}
inserted_players = {}

# Connect to DuckDB
con = duckdb.connect('events.db')

# Debug flag
DEBUG = True
TRUNCATE = True

# Function to truncate all tables
def truncate_tables(con):
    tables = [
        'own_goal_against', 'offside', 'dispossessed', 'substitution', 'shot', 'pressure', 
        'player_off', 'pass', 'miscontrol', 'interception', 'injury_stoppage', 'goalkeeper', 
        'foul_won', 'foul_committed', 'duel', 'dribbled_past', 'dribble', 'clearance', 
        'carry', 'block', 'ball_recovery', 'ball_receipt', 'bad_behaviour', 'fiftyfifty', 
        'events', 'lineups', 'matches', 'players', 'teams', 'managers', 'referees', 
        'stadiums', 'competitions', 'countries'
    ]
    
    try:
        cursor = con.cursor()
        for table in tables:
            cursor.execute(f'DELETE FROM {table}')
        con.commit()
        # Print success message
        print("All tables truncated successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        cursor.close()

def convert_timestamp(timestamp_str):
    # Convert from ISO 8601 to DuckDB expected format
    return datetime.fromisoformat(timestamp_str).strftime('%Y-%m-%d %H:%M:%S')

# Function to print debug messages
def debug_print(message):
    if DEBUG:
        print(message)

# Function to insert countries if not exists
def insert_country(country):
    country_id = country['id']
    
    # Check if the country is already in the hashmap
    if country_id in inserted_countries:
        return country_id
    
    # If not in hashmap, check the database
    try:
        result = con.execute('SELECT country_id FROM countries WHERE country_id = ?', (country_id,)).fetchone()
        if result is None:
            try:
                con.execute('INSERT INTO countries (country_id, name) VALUES (?, ?)', (country_id, country['name']))
                # Add the country to the hashmap after insertion
                inserted_countries[country_id] = True
            except Exception as e:
                print(f"An error occurred while inserting country {country_id}: {e}")
        else:
            # Add the country to the hashmap if it exists in the database
            inserted_countries[country_id] = True
    except Exception as e:
        print(f"An error occurred while checking for country {country_id}: {e}")
    
    return country_id


if TRUNCATE:
    truncate_tables(con)

# Load competitions data
# Print loading message
print("Loading competitions data...")
with open(os.path.join(input_dir, 'competitions.json')) as f:
    competitions = json.load(f)


for comp in competitions:
    try:
        # Now insert the competition record
        con.execute('''
            INSERT INTO competitions (
                competition_id, season_id, country_name, competition_name, competition_gender,
                competition_youth, competition_international, season_name, match_updated,
                match_updated_360, match_available_360, match_available
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            comp['competition_id'], comp['season_id'], comp['country_name'], comp['competition_name'],
            comp['competition_gender'], comp['competition_youth'], comp['competition_international'],
            comp['season_name'], comp['match_updated'], comp['match_updated_360'],
            comp['match_available_360'], comp['match_available']
        ))
        debug_print(f"Inserted competition: {comp['competition_name']} for season {comp['season_name']}")
    except Exception as e:
        print(f"An error occurred while inserting competition data: {e}")
# Print completion message
print("Competitions data loaded successfully.")

# Load matches data
# Print loading message
print("Loading matches data...")
matches_dir = os.path.join(input_dir, 'matches')
for comp in competitions:
    comp_dir = os.path.join(matches_dir, str(comp['competition_id']))
    season_file = str(comp['season_id']) + '.json'
    season_path = os.path.join(comp_dir, season_file)
    with open(season_path) as f:
        matches = json.load(f)
        for match in matches:
            try:
                # Insert stadium data
                stadium_id = match['stadium']['id']
                stadium = match['stadium']
                if stadium_id not in inserted_stadiums:
                    country_id = insert_country(stadium['country'], )
                    con.execute('''
                        INSERT INTO stadiums (stadium_id, name, country_id)
                        VALUES (?, ?, ?)
                    ''', (stadium_id, stadium['name'], country_id))
                    # Add the stadium to the hashmap after insertion
                    inserted_stadiums[stadium_id] = True
            except Exception as e:
                debug_print(f"Error inserting stadium {stadium_id}: {e}")

            try:
                # Insert referee data
                referee_id = match['referee']['id']
                referee = match['referee']
                if referee_id not in inserted_referees:
                    country_id = insert_country(referee['country'])
                    con.execute('''
                        INSERT INTO referees (referee_id, name, nationality)
                        VALUES (?, ?, ?)
                    ''', (referee_id, referee['name'], country_id))
                    inserted_referees[referee_id] = True
            except Exception as e:
                debug_print(f"Error inserting referee {referee_id}: {e}")

            try:
                # Insert manager data
                manager_ids = [
                    (match['home_team']['managers'][0]['id'], match['home_team']['managers'][0]),
                    (match['away_team']['managers'][0]['id'], match['away_team']['managers'][0])
                ]
                for manager_id, manager in manager_ids:
                    try:
                        if manager_id not in inserted_managers:
                            country_id = insert_country(manager['country'])
                            con.execute('''
                                INSERT INTO managers (manager_id, name, birth_date, nationality)
                                VALUES (?, ?, ?, ?)
                            ''', (manager_id, manager['name'], manager['dob'], country_id))
                            inserted_managers[manager_id] = True
                    except Exception as e:
                        debug_print(f"Error inserting manager {manager_id}: {e}")
            except Exception as e:
                debug_print(f"Error processing match data: {e}")

            try:
                # Insert team data
                team_ids = [
                    (match['home_team']['home_team_id'], match['home_team'], match['home_team']['home_team_name']),
                    (match['away_team']['away_team_id'], match['away_team'], match['away_team']['away_team_name'])
                ]
                for team_id, team, team_name in team_ids:
                    try:
                        if team_id not in inserted_teams:
                            country_id = insert_country(team['country'])
                            con.execute('''
                                INSERT INTO teams (team_id, name, country_id)
                                VALUES (?, ?, ?)
                            ''', (team_id, team_name, country_id))
                            inserted_teams[team_id] = True
                    except Exception as e:
                        debug_print(f"Error inserting team {team_id}: {e}")
            except Exception as e:
                debug_print(f"Error processing match data: {e}")

            try:
                # Insert match data
                con.execute('''
                    INSERT INTO matches (
                        match_id, competition_id, season_id, match_date, kick_off,
                        home_team_id, away_team_id, home_score, away_score,
                        stadium_id, referee_id, home_team_manager_id, away_team_manager_id,
                        attendance, behind_closed_doors, neutral_ground, play_status,
                        match_status, match_status_360, match_week, last_updated, last_updated_360
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    match['match_id'], match['competition']['competition_id'], match['season']['season_id'], match['match_date'],
                    match['kick_off'], match['home_team']['home_team_id'], match['away_team']['away_team_id'], match['home_score'],
                    match['away_score'], stadium_id, referee_id, match['home_team']['managers'][0]['id'],
                    match['away_team']['managers'][0]['id'], match['attendance'], match['behind_closed_doors'],
                    match['neutral_ground'], match['play_status'], match['match_status'],
                    match['match_status_360'], match['match_week'], match['last_updated'], convert_timestamp(match['last_updated_360']
                )))
            except Exception as e:
                debug_print(f"Error inserting match {match['match_id']}: {e}")

# Print completion message
print("Matches data loaded successfully.")

# Load lineups data
# Print loading message
print("Loading lineups data...")
lineups_dir = os.path.join(input_dir, 'lineups')
for lineup_file in os.listdir(lineups_dir):
    match_id = os.path.splitext(lineup_file)[0]
    lineup_path = os.path.join(lineups_dir, lineup_file)
    with open(lineup_path) as f:
        lineups = json.load(f)
        for team in lineups:
            for player in team['lineup']:
                try:
                    player_id = player['player_id']
                    if player_id not in inserted_players:
                        country_id = insert_country(player['country'])
                        con.execute('''
                            INSERT INTO players (
                                player_id, name, birth_date, gender, player_nickname, country_id
                            ) VALUES (?, ?, ?, ?, ?, ?)
                        ''', (
                            player['player_id'], player['player_name'], player['birth_date'],
                            player['player_gender'], player.get('player_nickname'), country_id
                        ))
                        inserted_players[player_id] = True
                except Exception as e:
                    debug_print(f"Error inserting player {player['player_id']}: {e}")

                for position in player.get('positions', []):
                    try:
                        con.execute('''
                            INSERT INTO lineups (
                                match_id, team_id, player_id, height, weight,
                                jersey_number, position_id, position_name, from_time, to_time,
                                from_period, to_period, start_reason, end_reason
                            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                        ''', (
                            match_id, team['team_id'], player['player_id'],
                            player['player_height'], player['player_weight'], player['jersey_number'],
                            position['position_id'], position['position'], position['from'],
                            position['to'], position['from_period'], position['to_period'],
                            position['start_reason'], position['end_reason']
                        ))
                    except Exception as e:
                        debug_print(f"Error inserting lineup for player {player['player_id']}: {e}")

# Print completion message
print("Lineups data loaded successfully.")

# Load events data
# Print loading message
print("Loading events data...")
events_dir = os.path.join(input_dir, 'events_plus_match_id')
assisted_shot_updates = []  # Store assisted shot updates to be processed later
for event_file in os.listdir(events_dir):
    event_path = os.path.join(events_dir, event_file)
    with open(event_path) as f:
        events = json.load(f)
        for event in events:
            try:
                # Ensure 'related_events' is a list of UUIDs, converting if necessary
                related_events = event.get('related_events', [])
                if not isinstance(related_events, list):
                    related_events = json.loads(related_events)

                # Extract location_x and location_y if they exist, otherwise use None
                location = event.get('location', [None, None])
                location_x = location[0]
                location_y = location[1]

                # Insert event data
                con.execute('''
                    INSERT INTO events (
                        event_id, match_id, team_id, player_id, period, timestamp, type_id,
                        type_name, outcome, duration, minute, second, possession, possession_team_id,
                        play_pattern_id, play_pattern_name, under_pressure, off_camera, out, related_events,
                        obv_for_after, obv_for_before, obv_for_net, obv_against_after, obv_against_before,
                        obv_against_net, obv_total_net, location_x, location_y
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    event['id'], event['match_id'], event['team']['id'], event.get('player', {}).get('id', None), event['period'],
                    event['timestamp'], event['type']['id'], event['type']['name'], None, event.get('duration', None),
                    event['minute'], event['second'], event['possession'], event['possession_team']['id'],
                    event['play_pattern']['id'], event['play_pattern']['name'], event.get('under_pressure', None), event.get('off_camera', None),
                    event.get('out', None), related_events, event['obv_for_after'], event['obv_for_before'],
                    event['obv_for_net'], event['obv_against_after'], event['obv_against_before'], event['obv_against_net'],
                    event['obv_total_net'], location_x, location_y
                ))

                # Insert into specialized event tables
                if event['type']['name'] == '50_50':
                    outcome = event.get('outcome', {})
                    con.execute('''
                        INSERT INTO fiftyfifty (event_id, outcome_id, outcome_name, counterpress)
                        VALUES (?, ?, ?, ?)
                    ''', (event['id'], outcome.get('id'), outcome.get('name'), event.get('counterpress', None)))

                elif event['type']['name'] == 'Bad Behaviour':
                    card = event.get('card', {})
                    con.execute('''
                        INSERT INTO bad_behaviour (event_id, card_id, card_name)
                        VALUES (?, ?, ?)
                    ''', (event['id'], card.get('id'), card.get('name')))

                elif event['type']['name'] == 'Ball Receipt':
                    outcome = event.get('outcome', {})
                    con.execute('''
                        INSERT INTO ball_receipt (event_id, outcome_id, outcome_name)
                        VALUES (?, ?, ?)
                    ''', (event['id'], outcome.get('id'), outcome.get('name')))

                elif event['type']['name'] == 'Ball Recovery':
                    con.execute('''
                        INSERT INTO ball_recovery (event_id, offensive, recovery_failure)
                        VALUES (?, ?, ?)
                    ''', (event['id'], event.get('offensive', None), event.get('recovery_failure', None)))


                elif event['type']['name'] == 'Block':
                    con.execute('''
                        INSERT INTO block (event_id, deflection, offensive, save_block, counterpress)
                        VALUES (?, ?, ?, ?, ?)
                    ''', (event['id'], event.get('deflection', None), event.get('offensive', None), event.get('save_block', None), event.get('counterpress', None)))


                elif event['type']['name'] == 'Carry':
                    con.execute('''
                        INSERT INTO carry (event_id, end_location_x, end_location_y)
                        VALUES (?, ?, ?)
                    ''', (event['id'], event['carry']['end_location'][0], event['carry']['end_location'][1]))

                elif event['type']['name'] == 'Clearance':
                    body_part = event.get('body_part', {})
                    con.execute('''
                        INSERT INTO clearance (event_id, aerial_won, body_part_id, body_part_name)
                        VALUES (?, ?, ?, ?)
                    ''', (
                        event['id'], 
                        event.get('aerial_won', None), 
                        body_part.get('id', None), 
                        body_part.get('name', None)
                    ))

                elif event['type']['name'] == 'Dribble':
                    outcome = event['dribble'].get('outcome', {})
                    con.execute('''
                        INSERT INTO dribble (event_id, overrun, nutmeg, outcome_id, outcome_name, no_touch)
                        VALUES (?, ?, ?, ?, ?, ?)
                    ''', (event['id'], event.get('overrun', None), event.get('nutmeg', None), outcome.get('id'), outcome.get('name'), event.get('no_touch', None)))

                elif event['type']['name'] == 'Dribbled Past':
                    con.execute('''
                        INSERT INTO dribbled_past (event_id, counterpress)
                        VALUES (?, ?)
                    ''', (event['id'], event.get('counterpress', None)))

                elif event['type']['name'] == 'Duel':
                    outcome = event['duel'].get('outcome', {})
                    duel_type = event['duel'].get('type', {})
                    con.execute('''
                        INSERT INTO duel (event_id, counterpress, duel_type_id, duel_type_name, outcome_id, outcome_name)
                        VALUES (?, ?, ?, ?, ?, ?)
                    ''', (event['id'], event.get('counterpress', None), duel_type.get('id'), duel_type.get('name'), outcome.get('id'), outcome.get('name')))

                elif event['type']['name'] == 'Foul Committed':
                    card = event.get('card', {})
                    foul_committed = event.get('foul_committed', {})
                    foul_type = foul_committed.get('type', {})
                    con.execute('''
                        INSERT INTO foul_committed (event_id, counterpress, offensive, foul_type_id, foul_type_name, advantage, penalty, card_id, card_name)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ''', (
                        event['id'], 
                        event.get('counterpress', None), 
                        event.get('offensive', None), 
                        foul_type.get('id', None), 
                        foul_type.get('name', None), 
                        event.get('advantage', None), 
                        event.get('penalty', None), 
                        card.get('id', None), 
                        card.get('name', None)
                    ))

                elif event['type']['name'] == 'Foul Won':
                    con.execute('''
                        INSERT INTO foul_won (event_id, defensive, advantage, penalty)
                        VALUES (?, ?, ?, ?)
                    ''', (event['id'], event.get('defensive', None), event.get('advantage', None), event.get('penalty', None)))

                elif event['type']['name'] == 'Goalkeeper':
                    outcome = event['goalkeeper'].get('outcome', {})
                    position = event['goalkeeper'].get('position', {})
                    technique = event['goalkeeper'].get('technique', {})
                    body_part = event['goalkeeper'].get('body_part', {})
                    type_ = event['goalkeeper'].get('type', {})
                    con.execute('''
                        INSERT INTO goalkeeper (event_id, position_id, position_name, technique_id, technique_name, body_part_id, body_part_name, type_id, type_name, outcome_id, outcome_name)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ''', (event['id'], position.get('id'), position.get('name'), technique.get('id'), technique.get('name'), body_part.get('id'), body_part.get('name'), type_.get('id'), type_.get('name'), outcome.get('id'), outcome.get('name')))


                elif event['type']['name'] == 'Injury Stoppage':
                    con.execute('''
                        INSERT INTO injury_stoppage (event_id, in_chain)
                        VALUES (?, ?)
                    ''', (event['id'], event.get('in_chain', None)))


                elif event['type']['name'] == 'Interception':
                    outcome = event['interception'].get('outcome', {})
                    con.execute('''
                        INSERT INTO interception (event_id, outcome_id, outcome_name)
                        VALUES (?, ?, ?)
                    ''', (event['id'], outcome.get('id'), outcome.get('name')))


                elif event['type']['name'] == 'Miscontrol':
                    con.execute('''
                        INSERT INTO miscontrol (event_id, aerial_won)
                        VALUES (?, ?)
                    ''', (event['id'], event.get('aerial_won', None)))

                elif event['type']['name'] == 'Pass':
                    pass_info = event.get('pass', {})
                    outcome = pass_info.get('outcome', {})
                    recipient = pass_info.get('recipient', {})
                    height = pass_info.get('height', {})
                    body_part = pass_info.get('body_part', {})
                    type_ = pass_info.get('type', {})
                    assisted_shot_id = pass_info.get('assisted_shot_id')

                    # If assisted_shot_id exists, add it to the assisted_shot_updates list
                    if assisted_shot_id:
                        assisted_shot_updates.append((assisted_shot_id, event['id']))

                    con.execute('''
                        INSERT INTO pass (
                            event_id, recipient_id, recipient_name, length, angle, aerial_won,
                            height_id, height_name, end_location_x, end_location_y, assisted_shot_id,
                            backheel, deflected, miscommunication, cross_pass, cut_back, switch,
                            shot_assist, goal_assist, body_part_id, body_part_name, pass_type_id,
                            pass_type_name, outcome_id, outcome_name, technique_id, technique_name
                        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ''', (
                        event['id'], 
                        recipient.get('id'), 
                        recipient.get('name'), 
                        pass_info.get('length'), 
                        pass_info.get('angle'), 
                        pass_info.get('aerial_won', None), 
                        height.get('id'), 
                        height.get('name'),
                        pass_info.get('end_location', [None, None])[0], 
                        pass_info.get('end_location', [None, None])[1], 
                        assisted_shot_id, 
                        pass_info.get('backheel', None), 
                        pass_info.get('deflected', None), 
                        pass_info.get('miscommunication', None), 
                        pass_info.get('cross', None), 
                        pass_info.get('cut_back', None), 
                        pass_info.get('switch', None),
                        pass_info.get('shot_assist', None), 
                        pass_info.get('goal_assist', None), 
                        body_part.get('id'), 
                        body_part.get('name'), 
                        type_.get('id'), 
                        type_.get('name'), 
                        outcome.get('id'), 
                        outcome.get('name'), 
                        pass_info.get('technique', {}).get('id'), 
                        pass_info.get('technique', {}).get('name')
                    ))

                elif event['type']['name'] == 'Player Off':
                    con.execute('''
                        INSERT INTO player_off (event_id, permanent)
                        VALUES (?, ?)
                    ''', (event['id'], event.get('permanent', None)))

                elif event['type']['name'] == 'Pressure':
                    con.execute('''
                        INSERT INTO pressure (event_id, counterpress)
                        VALUES (?, ?)
                    ''', (event['id'], event.get('counterpress', None)))


                elif event['type']['name'] == 'Shot':
                    shot_info = event['shot']
                    outcome = shot_info.get('outcome', {})
                    technique = shot_info.get('technique', {})
                    body_part = shot_info.get('body_part', {})
                    type_ = shot_info.get('type', {})

                    # Ensure end_location has three elements
                    end_location = shot_info.get('end_location', [None, None, None])
                    if len(end_location) == 2:
                        end_location.append(None)

                    con.execute('''
                        INSERT INTO shot (event_id, key_pass_id, end_location_x, end_location_y, end_location_z, aerial_won, follows_dribble, first_time, freeze_frame, open_goal, one_on_one, statsbomb_xg, deflected, technique_id, technique_name, body_part_id, body_part_name, shot_type_id, shot_type_name, outcome_id, outcome_name)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ''', (
                        event['id'], 
                        shot_info.get('key_pass_id', None), 
                        end_location[0], 
                        end_location[1], 
                        end_location[2], 
                        shot_info.get('aerial_won', None), 
                        shot_info.get('follows_dribble', None),
                        shot_info.get('first_time', None), 
                        json.dumps(shot_info.get('freeze_frame', [])), 
                        shot_info.get('open_goal', None), 
                        shot_info.get('one_on_one', None), 
                        shot_info.get('statsbomb_xg'), 
                        shot_info.get('deflected', None), 
                        technique.get('id', None), 
                        technique.get('name', None),
                        body_part.get('id', None), 
                        body_part.get('name', None), 
                        type_.get('id', None), 
                        type_.get('name', None), 
                        outcome.get('id', None), 
                        outcome.get('name', None)
                    ))


                elif event['type']['name'] == 'Substitution':
                    outcome = event.get('outcome', {})
                    replacement = event['substitution']['replacement']
                    con.execute('''
                        INSERT INTO substitution (event_id, replacement_id, replacement_name, outcome_id, outcome_name)
                        VALUES (?, ?, ?, ?, ?)
                    ''', (event['id'], replacement['id'], replacement['name'], outcome.get('id'), outcome.get('name')))


                elif event['type']['name'] == 'Dispossessed':
                    con.execute('''
                        INSERT INTO dispossessed (event_id)
                        VALUES (?)
                    ''', (event['id'],))

                elif event['type']['name'] == 'Offside':
                    con.execute('''
                        INSERT INTO offside (event_id)
                        VALUES (?)
                    ''', (event['id'],))


                elif event['type']['name'] == 'Own Goal Against':
                    con.execute('''
                        INSERT INTO own_goal_against (event_id)
                        VALUES (?)
                    ''', (event['id'],))

            except Exception as e:
                debug_print(f"Error inserting event {event['id']}: {e}")

# Print completion message
print("Events data loaded successfully.")

# Process the assisted_shot_id updates
# Print progress message
print("Processing assisted shot updates...")
for shot_id, pass_id in assisted_shot_updates:
    try:
        con.execute('''
            UPDATE pass
            SET assisted_shot_id = ?
            WHERE event_id = ?
        ''', (shot_id, pass_id))
    except Exception as e:
        debug_print(f"Error updating pass event {pass_id} with assisted_shot_id {shot_id}: {e}")
# Print completion message
print("Assisted shot updates processed successfully.")

# Close the DuckDB connection
con.close()
