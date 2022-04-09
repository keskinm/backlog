from server.db.queries import Queries


def create_database():
    Queries().reinitialize_database()


if __name__ == "__main__":
    create_database()
