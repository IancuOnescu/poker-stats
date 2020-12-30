from os import system, listdir, name

for e in listdir("raw_data"):
    if 'tgz' not in e: continue
    if name == 'nt': pass
    else: system(f'cd raw_data && tar -xvf {e} -C ../data')
    break
