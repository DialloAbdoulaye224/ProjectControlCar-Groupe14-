import streamlit as st
import pandas as pd
import requests
import plotly.express as px
import pytz  # Pour gérer les fuseaux horaires

# Définir l'URL du backend
backend_url = "http://192.168.191.178:5000"

# Fonction pour récupérer les données du backend Flask
@st.cache_data(ttl=60)  # Cache les résultats pendant 60 secondes
def fetch_data(endpoint):
    try:
        response = requests.get(f"{backend_url}/{endpoint}")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        st.error(f"Erreur lors de la récupération des données : {e}")
        return []

# Afficher l'image d'accueil avec une taille réduite
st.title("Visualisation des données des capteurs")
st.image("img.jpg", width=300)  # Réduire la largeur de l'image à 300 pixels

# Bouton pour rafraîchir les données
if st.button("Rafraîchir les données"):
    st.cache_data.clear()

# Récupérer toutes les données depuis le backend
all_data = fetch_data("data")

# Afficher les données en fonction du sensor_type sélectionné
if all_data:
    df = pd.DataFrame(all_data)
    
    # Convertir le timestamp en datetime et appliquer le fuseau horaire local
    df["timestamp"] = pd.to_datetime(df["timestamp"])
    
    # Supposons que les données sont en UTC, on convertit vers un fuseau horaire local (par exemple Europe/Paris)
    local_tz = pytz.timezone("Europe/Paris")
    df["timestamp"] = df["timestamp"].dt.tz_localize('UTC').dt.tz_convert(local_tz)

    st.subheader("Toutes les données des capteurs")
    st.write(df)

    # Liste des types de capteurs disponibles
    sensor_types = df["sensor_type"].unique()
    selected_sensor_type = st.selectbox("Sélectionner un type de capteur", sensor_types)

    # Filtrer les données en fonction du type de capteur sélectionné
    filtered_data = df[df["sensor_type"] == selected_sensor_type]

    if not filtered_data.empty:
        st.subheader(f"Données pour le capteur {selected_sensor_type}")

        # Trier les données par timestamp et sélectionner les dernières entrées
        filtered_data = filtered_data.sort_values(by="timestamp", ascending=True)

        # Afficher seulement les N dernières valeurs (par exemple 100 dernières valeurs)
        N = 100  # Ajuste ce nombre selon tes besoins
        recent_data = filtered_data.tail(N)

        # Créer un graphique avec Plotly pour les N dernières valeurs
        fig = px.line(recent_data, 
                      x='timestamp', 
                      y='value', 
                      title=f'Évolution des {N} dernières valeurs pour le capteur {selected_sensor_type}',
                      labels={'timestamp': 'Temps', 'value': 'Valeur'},
                      width=800, height=400)  # Taille du graphique

        # Personnaliser le graphique
        fig.update_layout(xaxis_title='Temps', yaxis_title='Valeur', title_x=0.5)

        # Afficher le graphique avec Plotly
        st.plotly_chart(fig)

    else:
        st.write(f"Aucune donnée pour le capteur de type '{selected_sensor_type}'.")

else:
    st.write("Aucune donnée disponible.")
