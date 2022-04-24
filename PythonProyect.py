import pandas as pd
import numpy as np

calendario = pd.read_excel("Calendario.xlsx")
CategoriaProducto = pd.read_excel("CategoriaProducto.xlsx")
Descuentos = pd.read_excel("Descuentos.xlsx")
Pedidos = pd.read_excel("Pedidos.xlsx")
Producto = pd.read_excel("Producto.xlsx")

#Consulta con condiciones
print(Producto[(Producto["Categoría"] == "Libro") & (Producto["Tamaño de Empaque"] == "Mediano")])
#Cantidad de producto por categoría
print(Producto.groupby("Categoría").size())
#Descuentos por orden de Mayor a Menor
print(Descuentos["Descuento"].sort_values(ascending=False))
#Actualizacion de datos
CategoriaProducto.loc[CategoriaProducto["SKU"]=="B01", "Precio de Venta"] = 191
print(CategoriaProducto.head(5))
#Describe
print(Pedidos.describe())
#Joins
CombinacionInner = pd.merge(CategoriaProducto,Producto)
print(CombinacionInner[["SKU","Precio de Venta","Categoría"]][CombinacionInner["Categoría"]=="Blue"])
CombinacionInner2 = pd.merge(CategoriaProducto,Producto,how="inner", on=["SKU"])
print(CombinacionInner2[["SKU","Precio de Venta","Categoría"]][CombinacionInner2["Categoría"]=="Blue"])
