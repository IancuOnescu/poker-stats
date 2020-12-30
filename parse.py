#!/usr/bin/python3
from os import mkdir, listdir
from re import split
import csv

def parse_game(game_name):
    print (f"[i] Parsing game {game_name}")
    path = f"data/{game_name}"
    hdb = open(f"{path}/hdb", "r")
    roster = open(f"{path}/hroster", "r")

    opath = f"parsed_data/{game_name}"
    try:
        mkdir(opath)
    except:
        pass
    try:
        mkdir(f"{opath}/pdb")
    except:
        pass


    with open(f"{opath}/hdb.csv", "w") as f:
        writer = csv.writer(f, delimiter=',')
        parse_hand_db(hdb, writer)

    with open(f"{opath}/hroster.csv", "w") as f:
        writer = csv.writer(f, delimiter=',')
        parse_roster(roster, writer)

    players = listdir(f"{path}/pdb")
    for player in players:
        with open(f"{path}/pdb/{player}", "r") as pdb:
            with open(f"{opath}/pdb/{player}.csv", "w") as f:
                writer = csv.writer(f, delimiter=',')
                parse_player_db(pdb, writer)

splitter = lambda s: [x for x in split('/| ', s.strip()) if x != '']

def parse_hand_db(hdb, out):
    header = ['timestamp', 'game_set', 'game', 'n_p_dealt',
                'n_p_see_flop', 'pot_sz_flop',
                'n_p_see_turn', 'pot_sz_turn',
                'n_p_see_river', 'pot_sz_river',
                'n_p_see_shtdw', 'n_p_sz_shtdw',
                'cards',
            ]
    cards_idx = header.index('cards')

    out.writerow(header)
    for line in hdb:
        line = splitter(line)
        line = [*line[:cards_idx], ' '.join(line[cards_idx:])]
        out.writerow(line)

def parse_roster(roster, out):
    header = ['timestamp', 'n_p', 'players']
    players_idx = header.index('players')

    for line in roster:
        line = splitter(line)
        line = [*line[:players_idx], ' '.join(line[players_idx:])]
        out.writerow(line)

def parse_player_db(pdb, out):
    header = ['p_name', 'timestamp', 'n_p_dealt', 'p_pos',
                'preflop', 'flop', 'turn', 'river',
                'p_bankroll', 'p_pot_sz', 'win', 'cards',
            ]
    cards_idx = header.index('cards')

    for line in pdb:
        line = splitter(line)
        line = [*line[:cards_idx], ' '.join(line[cards_idx:])]
        out.writerow(line)

for d in listdir("data"):
    try: mkdir(f"parsed_data/{d}")
    except: pass

    for dp in listdir(f"data/{d}"):
        try: mkdir(f"parsed_data/{d}/{dp}")
        except: pass

        try: parse_game(f"{d}/{dp}")
        except Exception as e: print (f"[-] Error: {e}")
