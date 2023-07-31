const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const opus_dep = b.dependency("opus", .{ .target = target, .optimize = optimize });
    const ogg_dep = b.dependency("ogg", .{ .target = target, .optimize = optimize });

    const lib = b.addStaticLibrary(.{
        .name = "opusfile",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.linkLibrary(opus_dep.artifact("opus"));
    lib.linkLibrary(ogg_dep.artifact("ogg"));
    lib.addIncludePath("include");
    lib.addCSourceFiles(&sources, &.{});
    lib.installHeadersDirectory("include", "");
    lib.installLibraryHeaders(opus_dep.artifact("opus"));
    lib.installLibraryHeaders(ogg_dep.artifact("ogg"));
    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "src/info.c",
    "src/internal.c",
    "src/opusfile.c",
    "src/stream.c",
};
