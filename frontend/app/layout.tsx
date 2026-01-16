import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Mikhail Zhukov - Digital Twin",
  description: "Automation Engineer & Manufacturing Leader | Digital Twin AI Assistant | Specializing in IWS, TPM, Lean, and AI-driven Industrial Digitalization",
  keywords: ["Mikhail Zhukov", "Automation Engineer", "Digital Twin", "Manufacturing", "IWS", "TPM", "Lean", "AI", "Industrial Digitalization"],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
