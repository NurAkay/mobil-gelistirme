from django.urls import path, include
from rest_framework.routers import DefaultRouter
from people.views import PersonViewSet

# Router: /api/persons ve /api/persons/{id} adreslerini otomatik oluşturur
router = DefaultRouter(trailing_slash=False)
router.register('persons', PersonViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
