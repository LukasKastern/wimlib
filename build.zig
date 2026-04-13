const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_wim = b.addLibrary(.{
        .name = "libwim",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });

    // Add source files
    lib_wim.addCSourceFiles(.{
        .files = &.{
            "src/add_image.c",
            "src/avl_tree.c",
            "src/blob_table.c",
            "src/compress.c",
            "src/compress_common.c",
            "src/compress_parallel.c",
            "src/compress_serial.c",
            "src/cpu_features.c",
            "src/decompress.c",
            "src/decompress_common.c",
            "src/delete_image.c",
            "src/dentry.c",
            "src/divsufsort.c",
            "src/encoding.c",
            "src/error.c",
            "src/export_image.c",
            "src/extract.c",
            "src/file_io.c",
            "src/header.c",
            "src/inode.c",
            "src/inode_fixup.c",
            "src/inode_table.c",
            "src/integrity.c",
            "src/iterate_dir.c",
            "src/join.c",
            "src/lcpit_matchfinder.c",
            "src/lzms_common.c",
            "src/lzms_compress.c",
            "src/lzms_decompress.c",
            "src/lzx_common.c",
            "src/lzx_compress.c",
            "src/lzx_decompress.c",
            "src/metadata_resource.c",
            "src/mount_image.c",
            "src/pathlist.c",
            "src/paths.c",
            "src/pattern.c",
            "src/progress.c",
            "src/reference.c",
            "src/registry.c",
            "src/reparse.c",
            "src/resource.c",
            "src/scan.c",
            "src/security.c",
            "src/sha1.c",
            "src/solid.c",
            "src/split.c",
            "src/tagged_items.c",
            "src/template.c",
            "src/textfile.c",
            "src/threads.c",
            "src/timestamp.c",
            "src/update_image.c",
            "src/util.c",
            "src/verify.c",
            "src/wim.c",
            "src/write.c",
            "src/xml.c",
            "src/xml_windows.c",
            "src/xmlproc.c",
            "src/xpress_compress.c",
            "src/xpress_decompress.c",
        },
        .flags = Flags,
        .language = .c,
    });

    // Add platform specific config
    if (target.result.os.tag == .windows) {
        lib_wim.addCSourceFiles(.{
            .files = WinPlatformFiles,
            .language = .c,
            .flags = Flags,
        });
        lib_wim.linkSystemLibrary("ntdll");
    } else {
        lib_wim.addCSourceFiles(.{
            .files = UnixPlatformFiles,
            .language = .c,
            .flags = Flags,
        });
    }
    lib_wim.addIncludePath(b.path("include/"));

    // Link libc
    lib_wim.linkLibC();

    b.installArtifact(lib_wim);
}

const Flags: []const []const u8 = &.{
    "-DPACKAGE_VERSION=\"1.14.5\"",
    "-std=c23",
    "-DHAVE_ALLOCA_H",
    "-D_POSIX_C_SOURCE",
    "-D_XOPEN_SOURCE",
};

const WinPlatformFiles: []const []const u8 = &.{
    "src/win32_common.c",
    "src/win32_apply.c",
    "src/win32_capture.c",
    "src/win32_replacements.c",
    "src/win32_vss.c",
};

const UnixPlatformFiles: []const []const u8 = &.{
    "src/unix_capture.c",
};
