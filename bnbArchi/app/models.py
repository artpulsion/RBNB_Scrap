from app import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    bnb_user_id = db.Column(db.Integer, index=True, unique=True)
    name = db.Column(db.String(60), index=True, unique=True)

    flats = db.relationship('Flat', backref='user', lazy=True)

    def __repr__(self):
        return '<User id {}, Bnb user id {}, Name {}>'.format(self.id, self.bnb_user_id, self.name)    

class City(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    gp_id = db.Column(db.String(64), index=True)
    name = db.Column(db.String(120), index=True)
    lng = db.Column(db.Float)
    lat = db.Column(db.Float)

    flats = db.relationship('Flat', backref='city', lazy=True)

    def __repr__(self):
        return '<City id {}, Google place id {}, Name {}, Latitutde {}, Longitude {}>'.format(self.id, self.gp_id, self.name, self.lat, self.lng)    



class Flat(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    city_id = db.Column(db.Integer, index=True)
    user_id = db.Column(db.Integer, index=True)
    bnb_flat_id = db.Column(db.Integer, index=True, unique=True)
    name = db.Column(db.String(120), index=True, unique=True)

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    city_id = db.Column(db.Integer, db.ForeignKey('city.id'), nullable=False)

    calendars = db.relationship('Calendar', backref='flat', lazy=True)

    def __repr__(self):
        return '<Flat id {}, City id {}, User id {}, Bnb Flat id {}, Name {}, User id {}, City id {}>'.format(self.id, self. city_id, self.user_id, self.bnb_flat_id, self.name)    


class Calendar(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    flat_id = db.Column(db.Integer, index=True, unique=True)
    time_scraping = db.Column(db.Integer, index=True)
    day_scraping = db.Column(db.String(60))
    night_price = db.Column(db.Integer)
    scraping_location = db.Column(db.String(60))

    flat_id = db.Column(db.Integer, db.ForeignKey('flat.id'), nullable=False)

    def __repr__(self):
        return '<Calendar id {}, Flat id {}, Time scraping {}, Day scraping {}, Night price {}, Scraping location {}>'.format(self.id, self.flat_id, self.time_scraping, self.day_scraping, self.night_price, self.scraping_location)    



