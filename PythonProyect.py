import pandas as pd
import openpyxl
import matplotlib.pyplot as plt
path = "C:\\Users\\Manjul\\Documents\\F\\apendice5.xlsx"
df1 = pd.read_excel(path, sheet_name= "1. ICA")
df = df1.drop(index=range(4))
nuevos_encabezados = df.iloc[0]
df = df[2:].rename(columns=nuevos_encabezados)
df = df[["Fecha","Expo Totales","Impo Totales","Saldo Comercial"]]
df = df.fillna(0)
df = df[df["Fecha"] != 0]
df['Variacion_Saldo'] = (df['Saldo Comercial'].pct_change() * 100)
df['Variacion_Expo'] = (df['Expo Totales'].pct_change() * 100)
df.round()
df = df.tail(8)
df.astype(int)

