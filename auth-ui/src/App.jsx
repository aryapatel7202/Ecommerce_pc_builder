import React, { useEffect, useRef, useState } from "react";
import Cropper from "cropperjs";
import "cropperjs/dist/cropper.css";

export default function App() {
  const API_BASE_URL = "http://localhost:6969/api/users";

  // form switching
  const [view, setView] = useState("login"); // 'login' | 'register' | 'forgot'

  // message box
  const [msg, setMsg] = useState({ text: "", type: "" }); // type: 'success' | 'error' | ''
  const showMessage = (text, type = "success") => {
    setMsg({ text, type });
    clearTimeout(showMessage._t);
    showMessage._t = setTimeout(() => setMsg({ text: "", type: "" }), 5000);
  };

  // login state
  const [loginEmailUser, setLoginEmailUser] = useState("");
  const [loginPassword, setLoginPassword] = useState("");

  // register state
  const [regUsername, setRegUsername] = useState("");
  const [regEmail, setRegEmail] = useState("");
  const [regPassword, setRegPassword] = useState("");
  const [regConfirm, setRegConfirm] = useState("");
  const [regOtp, setRegOtp] = useState("");
  const [regOtpVisible, setRegOtpVisible] = useState(false);

  // forgot state
  const [forgotEmail, setForgotEmail] = useState("");
  const [forgotOtpVisible, setForgotOtpVisible] = useState(false);
  const [forgotOtp, setForgotOtp] = useState("");
  const [forgotPassword, setForgotPassword] = useState("");
  const [forgotConfirm, setForgotConfirm] = useState("");

  // profile pic crop state
  const [previewUrl, setPreviewUrl] = useState(
    "https://placehold.co/100x100/E2E8F0/4A5568?text=Upload"
  );
  const [croppedBlob, setCroppedBlob] = useState(null);
  const [cropOpen, setCropOpen] = useState(false);

  const inputFileRef = useRef(null);
  const cropImgRef = useRef(null);
  const cropperRef = useRef(null);

  // --- utils (same validations) ---
  const validateUsername = (u) => {
    const regex = /^[a-z][a-z0-9]*$/;
    if (!regex.test(u))
      return {
        ok: false,
        msg:
          "Username must start with a lowercase letter and contain only alphanumeric characters.",
      };
    return { ok: true };
  };
  const validateEmail = (e) => {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!regex.test(e))
      return { ok: false, msg: "Enter a valid email (e.g., user@domain.com)." };
    return { ok: true };
  };
  const validatePassword = (p) => {
    if (p.length < 8) return { ok: false, msg: "Password must be 8+ characters." };
    if (!/[A-Z]/.test(p))
      return { ok: false, msg: "Password must contain at least one capital letter." };
    if (!/[!@#$%^&*()_\+\-=[\]{};':\"\\|,.<>/?]/.test(p))
      return { ok: false, msg: "Password must contain at least one special character." };
    return { ok: true };
  };

  // initial token check
  useEffect(() => {
    const token = localStorage.getItem("token");
    const expiry = localStorage.getItem("token_expiry");
    if (token && expiry && Date.now() < parseInt(expiry, 10)) {
      window.location.href = "new_home.html";
    }
  }, []);

  // cleanup cropper on unmount
  useEffect(() => {
    return () => {
      if (cropperRef.current) {
        cropperRef.current.destroy();
        cropperRef.current = null;
      }
    };
  }, []);

  // --- cropper handlers ---
  const onFileChange = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const url = URL.createObjectURL(file);
    setCropOpen(true);
    setTimeout(() => {
      if (cropperRef.current) {
        cropperRef.current.destroy();
        cropperRef.current = null;
      }
      if (cropImgRef.current) {
        cropImgRef.current.src = url;
        cropperRef.current = new Cropper(cropImgRef.current, {
          aspectRatio: 1,
          viewMode: 1,
          dragMode: "move",
          autoCropArea: 0.8,
          movable: true,
          zoomable: true,
          cropBoxMovable: false,
          cropBoxResizable: false,
          guides: false,
          center: false,
          background: false,
          toggleDragModeOnDblclick: false,
        });
      }
    }, 0);
  };

  const confirmCrop = () => {
    if (!cropperRef.current) return;
    cropperRef.current
      .getCroppedCanvas({ width: 256, height: 256, imageSmoothingQuality: "high" })
      .toBlob((blob) => {
        if (!blob) return;
        setCroppedBlob(blob);
        const croppedUrl = URL.createObjectURL(blob);
        setPreviewUrl(croppedUrl);
        closeCrop();
      }, "image/jpeg");
  };

  const closeCrop = () => {
    setCropOpen(false);
    if (cropperRef.current) {
      cropperRef.current.destroy();
      cropperRef.current = null;
    }
    if (inputFileRef.current) inputFileRef.current.value = "";
  };

  const removePhoto = () => {
    setPreviewUrl("https://placehold.co/100x100/E2E8F0/4A5568?text=Upload");
    setCroppedBlob(null);
    if (inputFileRef.current) inputFileRef.current.value = "";
  };

  // --- submit handlers ---
  const handleLogin = async (e) => {
  e.preventDefault();
  const loginInput = loginEmailUser.trim();
  const isEmail = loginInput.includes("@");
  const payload = isEmail
    ? { email: loginInput, password: loginPassword }
    : { username: loginInput, password: loginPassword };

  try {
    const res = await fetch(`${API_BASE_URL}/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });

    if (res.ok) {
      const data = await res.json();
      localStorage.setItem("token", data.token);
      localStorage.setItem("token_expiry", data.expiry);
      localStorage.setItem("username", data.username);
      localStorage.setItem("profile_picture", data.prof_pict || "null");
      localStorage.setItem("userid", data.userId);
      showMessage("Login successful! Redirecting...", "success");
      window.location.href = "/new_home.html";
    } else {
      const msg = await res.text();  // <— show backend reason
      showMessage(msg || "Login failed! Invalid username/email or password.", "error");
    }
  } catch (err) {
    console.error(err);
    showMessage("Error connecting to server.", "error");
  }
};
  const requestRegisterOtp = async () => {
    const u = validateUsername(regUsername);
    if (!u.ok) return showMessage(u.msg, "error");
    const em = validateEmail(regEmail);
    if (!em.ok) return showMessage(em.msg, "error");
    try {
      const res = await fetch(`${API_BASE_URL}/request-otp-register`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username: regUsername, email: regEmail }),
      });
      if (res.ok) {
        showMessage("OTP sent to email.", "success");
        setRegOtpVisible(true);
      } 
      else {
        const msg = await res.text();
        showMessage(msg || "Email already registered.", "error");
      }
    } catch {
      showMessage("Error connecting to server.", "error");
    }
  };

  const completeRegistration = async () => {
    const pw = validatePassword(regPassword);
    if (!pw.ok) return showMessage(pw.msg, "error");
    if (!regOtp) return showMessage("Enter OTP from your email.", "error");
    if (regPassword !== regConfirm)
      return showMessage("Passwords do not match.", "error");

    const formData = new FormData();
    formData.append("username", regUsername);
    formData.append("email", regEmail);
    formData.append("otp", regOtp);
    formData.append("password", regPassword);
    if (croppedBlob) formData.append("profile_picture", croppedBlob, "profile.jpg");

    try {
      const res = await fetch(`${API_BASE_URL}/verify-otp-register`, {
        method: "POST",
        body: formData,
      });
      if (res.ok) {
        showMessage("Registration successful! Please login.", "success");
        setView("login");
      } else {
        const msg = await res.text();
        showMessage(msg || "OTP verification failed or expired", "error");
      }
    } catch (err) {
      console.error(err);
      showMessage("Error connecting to server.", "error");
    }
  };

  const requestForgotOtp = async () => {
    const em = validateEmail(forgotEmail);
    if (!em.ok) return showMessage(em.msg, "error");
    try {
      const res = await fetch(`${API_BASE_URL}/request-otp`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: forgotEmail }),
      });
      if (res.ok) {
        showMessage("OTP sent to your email.", "success");
        setForgotOtpVisible(true);
      } else {
        const msg = await res.text();
        showMessage(msg || "Email not registered.", "error");
      }
    } catch {
      showMessage("Error connecting to server.", "error");
    }
  };

  const resetPassword = async () => {
    const pw = validatePassword(forgotPassword);
    if (!pw.ok) return showMessage(pw.msg, "error");
    if (!forgotOtp) return showMessage("Enter OTP sent to your email.", "error");
    if (forgotPassword !== forgotConfirm)
      return showMessage("Passwords do not match.", "error");

    try {
      const verify = await fetch(`${API_BASE_URL}/verify-otp`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: forgotEmail, otp: forgotOtp }),
      });
      if (!verify.ok) {
        const msg = await verify.text();
        showMessage(msg || "OTP incorrect or expired", "error");
        return;
      }
      const res = await fetch(`${API_BASE_URL}/reset-password`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: forgotEmail, password: forgotPassword }),
      });
      if (res.ok) {
        showMessage("Password reset successful! Please log in.", "success");
        setView("login");
      } else {
        const msg = await res.text();
        showMessage(msg || "Failed to reset password", "error");
      }
    } catch {
      showMessage("Error connecting to server.", "error");
    }
  };

  return (
    <div className="bg-gradient-to-br from-gray-900 via-blue-900 to-indigo-900 min-h-screen flex items-center justify-center p-4">
      <div className="bg-slate-100 p-8 rounded-xl shadow-2xl w-full max-w-sm transition-all duration-300 hover:shadow-lg hover:scale-[1.01]">
        {/* Message */}
        {msg.text ? (
          <div
            className={`mb-6 p-4 rounded-lg text-sm transition-all duration-300 ${
              msg.type === "error"
                ? "bg-red-100 text-red-700"
                : "bg-green-100 text-green-700"
            }`}
          >
            {msg.text}
          </div>
        ) : null}

        <h2 className="text-3xl font-bold text-center text-gray-800 mb-6">
          {view === "login" ? "Login" : view === "register" ? "Register" : "Reset Password"}
        </h2>

        {/* LOGIN */}
        {view === "login" && (
          <form onSubmit={handleLogin}>
            <div className="relative mb-4">
              <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect width="20" height="16" x="2" y="4" rx="2" />
                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
              </svg>
              <input
                value={loginEmailUser}
                onChange={(e) => setLoginEmailUser(e.target.value)}
                type="text"
                placeholder="Email or Username"
                required
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
              />
            </div>
            <div className="relative mb-6">
              <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
              <input
                value={loginPassword}
                onChange={(e) => setLoginPassword(e.target.value)}
                type="password"
                placeholder="Password"
                required
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
              />
            </div>
            <button type="submit" className="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors shadow-lg">
              Login
            </button>
            <div className="mt-4 text-center text-sm">
              <div className="text-blue-600 font-medium cursor-pointer hover:underline mb-2" onClick={() => setView("register")}>
                Don't have an account? Register
              </div>
              <div className="text-blue-600 font-medium cursor-pointer hover:underline" onClick={() => setView("forgot")}>
                Forgot password?
              </div>
            </div>
          </form>
        )}

        {/* REGISTER */}
        {view === "register" && (
          <div>
            <div className="flex justify-center mb-6">
              <div className="relative">
                <label>
                  <div
                    onClick={() => inputFileRef.current?.click()}
                    style={{ backgroundImage: `url('${previewUrl}')` }}
                    className="w-[100px] h-[100px] rounded-full bg-center bg-cover cursor-pointer border-4 border-gray-300 transition-all hover:border-blue-500 hover:brightness-90"
                    title="Click to upload a profile picture"
                  />
                </label>
                <input
                  ref={inputFileRef}
                  type="file"
                  accept="image/png, image/jpeg, image/gif"
                  className="hidden"
                  onChange={onFileChange}
                />
                {croppedBlob && (
                  <button
                    type="button"
                    title="Remove photo"
                    onClick={removePhoto}
                    className="absolute -top-1 -right-1 bg-red-500 text-white p-1 rounded-full hover:bg-red-600 transition-colors"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                      <line x1="18" y1="6" x2="6" y2="18"></line>
                      <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                  </button>
                )}
              </div>
            </div>

            <div className="relative mb-4">
              <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
                <circle cx="12" cy="7" r="4" />
              </svg>
              <input
                value={regUsername}
                onChange={(e) => setRegUsername(e.target.value)}
                type="text"
                placeholder="Username"
                required
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
              />
            </div>
            <div className="relative mb-4">
              <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect width="20" height="16" x="2" y="4" rx="2" />
                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
              </svg>
              <input
                value={regEmail}
                onChange={(e) => setRegEmail(e.target.value)}
                type="email"
                placeholder="Email"
                required
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
              />
            </div>
            <div className="relative mb-4">
              <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
              <input
                value={regPassword}
                onChange={(e) => setRegPassword(e.target.value)}
                type="password"
                placeholder="Password"
                required
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
              />
            </div>
            <div className="relative mb-6">
              <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
              <input
                value={regConfirm}
                onChange={(e) => setRegConfirm(e.target.value)}
                type="password"
                placeholder="Confirm Password"
                required
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
              />
            </div>

            <button
              type="button"
              onClick={requestRegisterOtp}
              className="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors shadow-lg"
            >
              Send OTP
            </button>

            {regOtpVisible && (
              <>
                <div className="relative mt-6 mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="m22 2-7 20-4-9-9-4 20-7Z" />
                    <path d="M15 15l-4-4" />
                  </svg>
                  <input
                    value={regOtp}
                    onChange={(e) => setRegOtp(e.target.value)}
                    type="text"
                    placeholder="Enter OTP"
                    className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
                  />
                </div>
                <button
                  type="button"
                  onClick={completeRegistration}
                  className="w-full bg-green-500 text-white py-3 rounded-lg font-semibold hover:bg-green-600 transition-colors shadow-lg"
                >
                  Complete Registration
                </button>
              </>
            )}

            <div className="mt-6 text-center text-sm">
              <div className="text-blue-600 font-medium cursor-pointer hover:underline" onClick={() => setView("login")}>
                Already have an account? Login
              </div>
            </div>
          </div>
        )}

        {/* FORGOT PASSWORD */}
        {view === "forgot" && (
          <div>
            <div className="relative mb-4">
              <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect width="20" height="16" x="2" y="4" rx="2" />
                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
              </svg>
              <input
                value={forgotEmail}
                onChange={(e) => setForgotEmail(e.target.value)}
                type="email"
                placeholder="Enter Email"
                required
                className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
              />
            </div>
            <button
              type="button"
              onClick={requestForgotOtp}
              className="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors shadow-lg"
            >
              Request OTP
            </button>

            {forgotOtpVisible && (
              <>
                <div className="relative mt-6 mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="m22 2-7 20-4-9-9-4 20-7Z" />
                    <path d="M15 15l-4-4" />
                  </svg>
                  <input
                    value={forgotOtp}
                    onChange={(e) => setForgotOtp(e.target.value)}
                    type="text"
                    placeholder="Enter OTP"
                    className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
                  />
                </div>
                <div className="relative mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                  </svg>
                  <input
                    value={forgotPassword}
                    onChange={(e) => setForgotPassword(e.target.value)}
                    type="password"
                    placeholder="New Password"
                    className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
                  />
                </div>
                <div className="relative mb-6">
                  <svg xmlns="http://www.w3.org/2000/svg" className="absolute top-1/2 left-3 -translate-y-1/2 text-gray-400" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                  </svg>
                  <input
                    value={forgotConfirm}
                    onChange={(e) => setForgotConfirm(e.target.value)}
                    type="password"
                    placeholder="Confirm Password"
                    className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
                  />
                </div>
                <button
                  type="button"
                  onClick={resetPassword}
                  className="w-full bg-green-500 text-white py-3 rounded-lg font-semibold hover:bg-green-600 transition-colors shadow-lg"
                >
                  Reset Password
                </button>
              </>
            )}

            <div className="mt-6 text-center text-sm">
              <div className="text-blue-600 font-medium cursor-pointer hover:underline" onClick={() => setView("login")}>
                Back to Login
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Crop Modal */}
      {cropOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-sm flex flex-col max-h-[90vh]">
            <h3 className="text-xl font-bold p-4 text-center text-gray-800 border-b border-gray-200 flex-shrink-0">
              Adjust Photo
            </h3>
            <div className="p-4 flex-grow overflow-y-auto relative">
              <img ref={cropImgRef} alt="To crop" className="max-w-full block" />
              <button
                title="Choose a different photo"
                onClick={() => inputFileRef.current?.click()}
                className="absolute top-6 left-6 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75 transition-colors"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M21 12a9 9 0 0 1-9 9a9.75 9.75 0 0 1-6.74-2.74L3 16" />
                  <path d="M3 7v9a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8" />
                  <path d="M3 16h4v-4" />
                  <path d="M21 8h-4v4" />
                </svg>
              </button>
              <button
                title="Cancel cropping"
                onClick={closeCrop}
                className="absolute top-6 right-6 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75 transition-colors"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <line x1="18" y1="6" x2="6" y2="18"></line>
                  <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
              </button>
            </div>
            <div className="flex justify-end p-4 bg-gray-50 border-t border-gray-200 flex-shrink-0">
              <button
                onClick={confirmCrop}
                type="button"
                className="px-8 py-2 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 transition-colors"
              >
                Save
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
