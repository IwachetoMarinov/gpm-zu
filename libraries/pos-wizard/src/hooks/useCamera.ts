import {
  useRef,
  useState,
  useEffect,
  useCallback,
  type RefObject,
} from "react";
import type { CropRect } from "../types/idCardCapture";
import { cropVideoFrameToBlob } from "../lib/cropVideoFrameToBlob";

export type UseCameraResult = {
  videoRef: RefObject<HTMLVideoElement | null>;
  stream: MediaStream | null;
  isOpening: boolean;
  isActive: boolean;
  error: string | null;
  openCamera: () => Promise<void>;
  closeCamera: () => void;
  captureImage: (cropRect?: CropRect) => Promise<Blob | undefined>;
};

const REAR_CAMERA_CONSTRAINTS: MediaStreamConstraints = {
  audio: false,
  video: { facingMode: "environment" },
};

const FALLBACK_CAMERA_CONSTRAINTS: MediaStreamConstraints = {
  audio: false,
  video: true,
};

const stopStreamTracks = (mediaStream: MediaStream | null): void => {
  if (!mediaStream) {
    return;
  }

  for (const track of mediaStream.getTracks()) {
    track.stop();
  }
};

const mapCameraError = (error: unknown): string => {
  if (!(error instanceof DOMException) && !(error instanceof Error)) {
    return "An unexpected camera error occurred. Please try again.";
  }

  switch (error.name) {
    case "NotAllowedError":
    case "PermissionDeniedError":
      return "Camera permission was denied. Allow camera access in your browser settings and try again.";
    case "NotFoundError":
    case "DevicesNotFoundError":
      return "No camera was found on this device.";
    case "NotReadableError":
    case "TrackStartError":
      return "The camera is already in use by another application. Close other apps using the camera and try again.";
    case "SecurityError":
      return "Camera access requires HTTPS or localhost.";
    default:
      return "An unexpected camera error occurred. Please try again.";
  }
};

const requestCameraStream = async (): Promise<MediaStream> => {
  try {
    return await navigator.mediaDevices.getUserMedia(REAR_CAMERA_CONSTRAINTS);
  } catch (error) {
    if (
      error instanceof DOMException &&
      (error.name === "OverconstrainedError" ||
        error.name === "NotFoundError" ||
        error.name === "DevicesNotFoundError")
    ) {
      return navigator.mediaDevices.getUserMedia(FALLBACK_CAMERA_CONSTRAINTS);
    }

    try {
      return await navigator.mediaDevices.getUserMedia(
        FALLBACK_CAMERA_CONSTRAINTS,
      );
    } catch {
      throw error;
    }
  }
};

export const useCamera = (): UseCameraResult => {
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [isOpening, setIsOpening] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const closeCamera = useCallback(() => {
    stopStreamTracks(streamRef.current);
    streamRef.current = null;
    setStream(null);

    const video = videoRef.current;
    if (video) {
      video.srcObject = null;
    }

    setIsOpening(false);
    setError(null);
  }, []);

  const openCamera = useCallback(async () => {
    setError(null);

    if (!window.isSecureContext) {
      setError("Camera access requires HTTPS or localhost.");
      return;
    }

    if (!navigator.mediaDevices?.getUserMedia) {
      setError("This browser does not support camera access.");
      return;
    }

    setIsOpening(true);
    stopStreamTracks(streamRef.current);
    streamRef.current = null;
    setStream(null);

    try {
      const mediaStream = await requestCameraStream();
      streamRef.current = mediaStream;
      setStream(mediaStream);

      const video = videoRef.current;
      if (video) {
        video.srcObject = mediaStream;
        await video.play();
      }
    } catch (cameraError) {
      stopStreamTracks(streamRef.current);
      streamRef.current = null;
      setStream(null);

      if (videoRef.current) {
        videoRef.current.srcObject = null;
      }

      setError(mapCameraError(cameraError));
    } finally {
      setIsOpening(false);
    }
  }, []);

  const captureImage = useCallback(
    async (cropRect?: CropRect): Promise<Blob | undefined> => {
      const video = videoRef.current;

      if (!video || !streamRef.current) {
        setError(
          "The camera is not active. Open the camera before capturing an image.",
        );
        return undefined;
      }

      if (video.videoWidth === 0 || video.videoHeight === 0) {
        setError(
          "The camera preview is not ready yet. Wait a moment and try again.",
        );
        return undefined;
      }

      const region: CropRect = cropRect ?? {
        x: 0,
        y: 0,
        width: video.videoWidth,
        height: video.videoHeight,
      };

      if (region.width < 1 || region.height < 1) {
        setError("Unable to locate the ID card frame for cropping. Try again.");
        return undefined;
      }

      const blob = await cropVideoFrameToBlob(video, region);

      if (!blob) {
        setError("Unable to create an image from the camera preview.");
        return undefined;
      }

      setError(null);
      return blob;
    },
    [],
  );

  useEffect(() => {
    return () => {
      stopStreamTracks(streamRef.current);
      streamRef.current = null;
    };
  }, []);

  return {
    videoRef,
    stream,
    isOpening,
    isActive: stream !== null,
    error,
    openCamera,
    closeCamera,
    captureImage,
  };
};
