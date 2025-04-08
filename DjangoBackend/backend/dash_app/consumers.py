import json
from channels.generic.websocket import AsyncWebsocketConsumer

class UpdatesConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        # Optionally add the connection to a group if you want to broadcast messages
        await self.channel_layer.group_add("updates", self.channel_name)

    async def disconnect(self, close_code):
        # Remove the connection from the group on disconnect
        await self.channel_layer.group_discard("updates", self.channel_name)

    async def receive(self, text_data):
        data = json.loads(text_data)
        message = data.get("message", "")
        # Broadcast the message to the group
        await self.channel_layer.group_send(
            "updates",
            {
                "type": "send_update",
                "message": message
            }
        )

    async def send_update(self, event):
        # Send the update to the WebSocket client
        await self.send(text_data=json.dumps({
            "message": event["message"]
        }))
