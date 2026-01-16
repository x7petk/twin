import Twin from '@/components/twin';
import { Briefcase, MapPin, Sparkles } from 'lucide-react';

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50">
      <div className="container mx-auto px-4 py-8 md:py-12">
        <div className="max-w-5xl mx-auto">
          {/* Professional Header */}
          <div className="text-center mb-8 md:mb-12">
            <div className="inline-flex items-center justify-center w-20 h-20 md:w-24 md:h-24 mb-4 rounded-full bg-gradient-to-br from-blue-600 to-indigo-700 shadow-lg">
              <Sparkles className="w-10 h-10 md:w-12 md:h-12 text-white" />
            </div>
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-3 bg-gradient-to-r from-blue-600 to-indigo-700 bg-clip-text text-transparent">
              Mikhail Zhukov
            </h1>
            <div className="flex flex-col md:flex-row items-center justify-center gap-2 md:gap-4 text-gray-600 mb-4">
              <div className="flex items-center gap-1.5">
                <Briefcase className="w-4 h-4" />
                <span className="font-medium">Development Manager</span>
              </div>
              <span className="hidden md:inline">•</span>
              <div className="flex items-center gap-1.5">
                <MapPin className="w-4 h-4" />
                <span>Christchurch, New Zealand</span>
              </div>
            </div>
            <p className="text-lg text-gray-700 max-w-2xl mx-auto leading-relaxed">
              Automation Engineer & Manufacturing Leader | Connecting people, processes, and technology 
              to create intelligent operations that drive real business value.
            </p>
            <div className="flex flex-wrap justify-center gap-2 mt-4">
              <span className="px-3 py-1 text-xs font-medium bg-blue-100 text-blue-800 rounded-full">IWS</span>
              <span className="px-3 py-1 text-xs font-medium bg-indigo-100 text-indigo-800 rounded-full">TPM</span>
              <span className="px-3 py-1 text-xs font-medium bg-purple-100 text-purple-800 rounded-full">Lean</span>
              <span className="px-3 py-1 text-xs font-medium bg-pink-100 text-pink-800 rounded-full">AI/ML</span>
              <span className="px-3 py-1 text-xs font-medium bg-cyan-100 text-cyan-800 rounded-full">Digital Transformation</span>
            </div>
          </div>

          {/* Chat Interface */}
          <div className="h-[650px] md:h-[700px] mb-8">
            <Twin />
          </div>

          {/* Professional Footer */}
          <footer className="mt-12 pt-8 border-t border-gray-200">
            <div className="text-center text-sm text-gray-600">
              <p className="mb-2">
                <span className="font-semibold text-gray-800">Digital Twin AI Assistant</span>
              </p>
              <p className="text-gray-500">
                Specializing in Integrated Work Systems, Total Productive Maintenance, and AI-driven Industrial Digitalization
              </p>
            </div>
          </footer>
        </div>
      </div>
    </main>
  );
}