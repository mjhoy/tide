all: tide

clean:
	rm -f tide

tide: tide.swift
	swiftc -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk -target x86_64-apple-macosx10.12 tide.swift
