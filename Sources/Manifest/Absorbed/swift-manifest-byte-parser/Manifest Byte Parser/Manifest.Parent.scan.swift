#if Parser
internal import ASCII
internal import Cursor
internal import Parser

extension Manifest.Parent {

    public static func scan(
        in source: borrowing Swift.String
    ) -> [Swift.UInt8]? {
        var lineBuffer: [Swift.UInt8] = []
        lineBuffer.reserveCapacity(128)
        var lineCount = 0
        for byte in source.utf8 {
            if byte == 0x0A {
                if let urlBytes = parse(lineBuffer[...]) {
                    return urlBytes
                }
                lineCount += 1
                if lineCount >= 30 { return nil }
                lineBuffer.removeAll(keepingCapacity: true)
            } else {
                lineBuffer.append(byte)
            }
        }
        if lineCount < 30 {
            return parse(lineBuffer[...])
        }
        return nil
    }

    @inline(__always)
    private static func parse(
        _ line: Swift.ArraySlice<Swift.UInt8>
    ) -> [Swift.UInt8]? {
        var input = Array(line)[...]

        while let first = input.first,
            first == 0x20
                || first == 0x09
        {

            _ = input.next()
        }

        do {
            try [Swift.UInt8].Parser<Swift.ArraySlice<Swift.UInt8>>(
                Swift.Array("// parent:".utf8)
            ).parse(&input)
        } catch {
            return nil
        }

        while let first = input.first,
            first == 0x20
                || first == 0x09
        {

            _ = input.next()
        }

        var urlBytes: [Swift.UInt8] = []
        urlBytes.reserveCapacity(64)
        while let first = input.first {
            if first == 0x20
                || first == 0x09
                || first == 0x0D
            {
                break
            }
            urlBytes.append(first)

            _ = input.next()
        }
        return urlBytes.isEmpty ? nil : urlBytes
    }
}
#endif
