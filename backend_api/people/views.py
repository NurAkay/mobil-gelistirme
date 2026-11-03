from rest_framework import viewsets
from .models import Person
from .serializers import PersonSerializer


# ModelViewSet: GET, POST, PUT, DELETE işlemlerinin hepsini hazır getirir
class PersonViewSet(viewsets.ModelViewSet):
    queryset = Person.objects.all()
    serializer_class = PersonSerializer
