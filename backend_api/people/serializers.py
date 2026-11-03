from rest_framework import serializers
from .models import Person


# Serializer: Person nesnesini JSON'a, JSON'u Person nesnesine çevirir
class PersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = '__all__'
