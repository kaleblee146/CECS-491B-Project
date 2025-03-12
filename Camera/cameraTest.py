import cv2
# works just can't close the window effectively


# Open webcam
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()  # Read frame from webcam
    if not ret:
        break

    cv2.imshow("Webcam Feed", frame)  # Show frame

    # Exit on pressing 'q'
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
