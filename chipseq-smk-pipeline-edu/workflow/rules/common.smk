import pandas as pd

configfile: 'config/config.yaml'

SAMPLES_DF = pd.read_csv(config['samples_table'], sep='\t')
SAMPLES_DF['Sample'] = [
    f'{SAMPLES_DF["GSM"][idx]}_{SAMPLES_DF["Cell"][idx]}_{SAMPLES_DF["Target"][idx]}'
    for idx in range(SAMPLES_DF.shape[0])
]
SAMPLES_DF.set_index(['Sample'], drop=True, inplace=True)