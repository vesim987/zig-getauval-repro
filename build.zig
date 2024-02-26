const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "lib",
        .root_source_file = .{ .path = "lib.zig" },
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "exe",
        .root_source_file = .{ .path = "exe.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibC();
    exe.linkLibrary(lib);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run");
    run_step.dependOn(&run_cmd.step);
}
