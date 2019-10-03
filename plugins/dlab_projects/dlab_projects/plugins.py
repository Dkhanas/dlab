from flask import Blueprint
from flask_restful import Api

from dlab_core.plugins import BaseAPIPlugin
from dlab_projects.infrastructure.views import CreateProjectAPI, ProjectAPI

project_bp = Blueprint('project', __name__, url_prefix='/project')

api = Api(project_bp)


class ProjectAPIPlugin(BaseAPIPlugin):

    @staticmethod
    def add_routes(app):
        api.add_resource(CreateProjectAPI, '')
        api.add_resource(ProjectAPI,
                         '/<string:name>/status',
                         '/<string:name>',
                         '/<string:name>/<string:action>'
                         )

        app.register_blueprint(project_bp)
