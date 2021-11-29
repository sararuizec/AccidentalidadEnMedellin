from flask import Flask, render_template, request
import pandas as pd
import numpy as np

app = Flask(__name__, template_folder='template')


@app.route('/')
def home():
    return render_template('home.html')


@app.route('/visualizacion', methods=["GET", "POST"])  ##{{ url_for('viasializacion')}}
def viasializacion():

    df = pd.read_csv("db-acc-med.csv", sep = ";", encoding = 'unicode_escape')
    clases = df["CLASE"].sort_values()
    clases = clases.drop_duplicates().values
    rows = df.head(n=10).values

    if request.method == 'POST':
        Fini = request.form["Dstart"]
        Fend = request.form["Dend"]
        typeacc = request.form["typeAcc"]

        df["FECHA2"] = pd.to_datetime(df["FECHA"], format="%d/%m/%Y")

        date1 = pd.to_datetime(Fini, format="%Y/%m/%d")
        date2 = pd.to_datetime(Fend, format="%Y/%m/%d")
        filtro1 =df["FECHA2"]>=date1
        filtro2 = df["FECHA2"]<=date2
        filtro = filtro1 & filtro2

        if(typeacc == "NA"):
            rows = df[filtro]
        else:
            tacc = df["CLASE"] == typeacc
            filtro = filtro & tacc
            rows = df[filtro]
        
        rows = rows.values

    return render_template('/visual.html', datos=rows, op=clases)


@app.route('/prediccion', methods=["GET", "POST"])  ##{{ url_for('prediccion')}}
def prediccion():
    return render_template('predic.html')


@app.route('/referencias')
def referencias():
    return render_template('ref.html')


@app.route('/reporte-tecnico')
def reporteT():
    return render_template('report.html')


@app.route('/agrupacion', methods=["GET", "POST"])
def agrupacion():
    return render_template('agrup.html')


if __name__ == '__main__':
    app.run(debug=True)
