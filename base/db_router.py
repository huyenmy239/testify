class DatabaseRouter:
    """
    A router to control all database operations on models.
    """

    def db_for_read(self, model, **hints):
        request = hints.get('request')
        if request:
            db_alias = request.session.get('server_info', 'default')
            return db_alias
        return 'default'

    def db_for_write(self, model, **hints):
        request = hints.get('request')
        if request:
            db_alias = request.session.get('server_info', 'default')
            return db_alias
        return 'default'

    def allow_relation(self, obj1, obj2, **hints):
        return True

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        return db == 'default'
