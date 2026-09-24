from firebase_admin import firestore, initialize_app, messaging
from firebase_functions import firestore_fn


initialize_app()


@firestore_fn.on_document_created(document="orders/{orderId}")
def notify_user_after_purchase(event: firestore_fn.Event[firestore_fn.DocumentSnapshot]) -> None:
    """
    Se dispara automáticamente cuando se crea una orden en Firestore.
    Envía una notificación PUSH al usuario via FCM.
    """
    order_snapshot = event.data
    if order_snapshot is None:
        print(f"No data in event for order")
        return

    order = order_snapshot.to_dict() or {}
    user_id = order.get("userId")
    
    if not user_id:
        print(f"❌ Orden {order_snapshot.id} sin userId")
        return

    db = firestore.client()
    
    # Obtener datos del usuario
    user_snapshot = db.collection("users").document(str(user_id)).get()
    if not user_snapshot.exists:
        print(f"❌ Usuario {user_id} no encontrado")
        return

    user = user_snapshot.to_dict() or {}
    
    # Obtener token FCM del usuario
    device_token = user.get("deviceToken")
    if not device_token or not isinstance(device_token, str):
        print(f"❌ Usuario {user_id} sin token FCM válido")
        return

    # Preparar datos de la notificación
    order_total = order.get("total", 0)
    order_id_short = order_snapshot.id[:8]

    # Enviar notificación PUSH
    try:
        response = messaging.send(
            messaging.Message(
                notification=messaging.Notification(
                    title="¡Compra Realizada! 🎉",
                    body=f"Tu orden #{order_id_short} por €{order_total} ha sido confirmada",
                ),
                data={
                    "sale_id": order_snapshot.id,  # ✅ Para deep linking a OrderDetailView
                    "feature": "order_details",
                    "total": str(order_total),
                    "status": order.get("status", "completed"),
                },
                token=device_token,
            )
        )
        print(f"✅ Notificación PUSH enviada para orden {order_snapshot.id}: {response}")
    except Exception as e:
        print(f"❌ Error enviando notificación para orden {order_snapshot.id}: {str(e)}")
