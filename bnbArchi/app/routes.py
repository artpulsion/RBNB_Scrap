from flask import render_template, flash, redirect, url_for, request, jsonify
from app import app, db
from app.models import Calendar, City, Flat, User, User_agent
import requests
import json

@app.route('/')
def home():
    return 'API ON'

@app.route('/add_city', methods=['POST'])
def add_city():
    data = request.get_json()
    city = City(gp_id=data.get('gp_id'), name=data.get('name'), lat=data.get('lat'), lng=data.get('lng') )
    db.session.add(city)
    db.session.commit()
    return jsonify(status='OK')


@app.route('/add_user_agent', methods=['POST'])
def add_user_agent():
    data = request.get_json()
    user_agent = User_agent(name=data.get('name'))
    db.session.add(user_agent)
    db.session.commit()
    return jsonify(status='OK')


@app.route('/add_flat', methods=['POST'])
def add_flat():
    data = request.get_json()
    flat = Flat( )
    db.session.add(flat)
    db.session.commit()
    return jsonify(status='OK')


@app.route('/add_user', methods=['POST'])
def add_user():
    data = request.get_json()
    user = User()
    db.session.add(user)
    db.session.commit()
    return jsonify(status='OK')


@app.route('/add_calendar', methods=['POST'])
def add_calendar():
    data = request.get_json()
    calendar = Calendar( )
    db.session.add(calendar)
    db.session.commit()
    return jsonify(status='OK')


