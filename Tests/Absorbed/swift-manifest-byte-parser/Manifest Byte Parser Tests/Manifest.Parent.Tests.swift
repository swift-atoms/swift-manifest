#if Parser
import Manifest
import Testing

@Suite
struct `Manifest parent scanning preserves bytes and line limits` {
    @Test
    func `An absent parent directive returns nil`() {
        let content = """
            import Linter

            let manifest = Lint.Manifest(enabledRuleIDs: [])
            """
        #expect(Manifest.Parent.scan(in: content) == nil)
    }

    @Test
    func `An HTTPS parent URL is returned as bytes`() {
        let content = """
            // parent: https://raw.githubusercontent.com/swift-institute/.github/main/Lint.swift
            """
        let expected = Swift.Array(
            "https://raw.githubusercontent.com/swift-institute/.github/main/Lint.swift".utf8
        )
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `An HTTP parent URL is returned as bytes`() {
        let content = "// parent: http://example.com/Lint.swift\n"
        let expected = Swift.Array("http://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `A file parent URL is returned as bytes`() {
        let content = "// parent: file:///tmp/parent.swift\n"
        let expected = Swift.Array("file:///tmp/parent.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Leading spaces before a directive are ignored`() {
        let content = "    // parent: https://example.com/Lint.swift\n"
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Leading tabs before a directive are ignored`() {
        let content = "\t// parent: https://example.com/Lint.swift\n"
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `The scanner returns an unknown scheme unchanged`() {
        let content = "// parent: ftp://example.com/Lint.swift\n"
        let expected = Swift.Array("ftp://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `A parent directive after the first thirty lines is ignored`() {
        var lines: [Swift.String] = []
        for _ in 0..<31 {
            lines.append("// padding")
        }
        lines.append("// parent: https://example.com/Lint.swift")
        let content = lines.joined(separator: "\n")
        #expect(Manifest.Parent.scan(in: content) == nil)
    }

    @Test
    func `A parent directive on the thirtieth line is returned`() {
        var lines: [Swift.String] = []
        for _ in 0..<29 {
            lines.append("// padding")
        }
        lines.append("// parent: https://example.com/Lint.swift")
        let content = lines.joined(separator: "\n")
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `Trailing spaces are excluded from the parent value`() {
        let content = "// parent: https://example.com/Lint.swift   \n"
        let expected = Swift.Array("https://example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test
    func `An empty parent value returns nil`() {
        #expect(Manifest.Parent.scan(in: "// parent:   \n") == nil)
    }

    @Test
    func `The first nonempty parent directive wins`() {
        let content = """
            // parent: https://first.example.com/Lint.swift
            // parent: https://second.example.com/Lint.swift
            """
        let expected = Swift.Array("https://first.example.com/Lint.swift".utf8)
        #expect(Manifest.Parent.scan(in: content) == expected)
    }

    @Test(arguments: [1, 29, 30, 31], [false, true])
    func `The thirty line limit is independent of a trailing line feed`(
        lineNumber: Int,
        hasTrailingNewline: Bool
    ) {
        let value = "https://example.com/parent.swift"
        let source = Swift.String(repeating: "// padding\n", count: lineNumber - 1)
            + "// parent: " + value + (hasTrailingNewline ? "\n" : "")
        let expected: [Swift.UInt8]? = lineNumber <= 30 ? Swift.Array(value.utf8) : nil
        #expect(Manifest.Parent.scan(in: source) == expected)
    }

    @Test(arguments: [
        "https://例え.test/路径",
        "../e\u{301}/📁",
        "value\u{00A0}with\u{2028}separators",
    ])
    func `Unicode values retain their original UTF8 bytes`(value: Swift.String) {
        #expect(Manifest.Parent.scan(in: "// parent: " + value) == Swift.Array(value.utf8))
    }

    @Test(arguments: ["\u{00A0}", "\u{2003}"])
    func `Unicode whitespace does not indent a parent directive`(indentation: Swift.String) {
        #expect(Manifest.Parent.scan(in: indentation + "// parent: value") == nil)
    }

    @Test
    func `Carriage returns do not count as line delimiters`() {
        let value = "https://example.com/parent.swift"
        let source = Swift.String(repeating: "// padding\r", count: 31)
            + "\n// parent: " + value
        #expect(Manifest.Parent.scan(in: source) == Swift.Array(value.utf8))
    }

    @Test
    func `Empty directives do not hide a later nonempty value`() {
        let source = "// parent:\n\t// parent: \t\r\n// parent: chosen"
        #expect(Manifest.Parent.scan(in: source) == Swift.Array("chosen".utf8))
    }

    @Test(arguments: [
        "",
        "// Parent: value",
        "//parent: value",
        "prefix // parent: value",
        "/ parent: value",
        "// parent",
        "// paren: value",
    ])
    func `The directive marker must match exactly after ASCII indentation`(source: Swift.String) {
        #expect(Manifest.Parent.scan(in: source) == nil)
    }

    @Test(arguments: [" ", "\t", "\r"])
    func `ASCII value terminators exclude subsequent bytes`(terminator: Swift.String) {
        #expect(
            Manifest.Parent.scan(in: "// parent: first" + terminator + "second")
                == Swift.Array("first".utf8)
        )
    }
}
#endif
