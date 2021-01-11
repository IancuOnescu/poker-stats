from os import system, listdir, name, mkdir

try: mkdir('data')
except: pass

for e in listdir("raw_data"):
    if 'tgz' not in e: continue
    if name == 'nt': pass
    else: system(f'cd raw_data && tar -xvf {e} -C ../data')
