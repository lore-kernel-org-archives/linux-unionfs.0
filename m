From: Colin King <colin.king@canonical.com>
Subject: [PATCH] ovl: create UUIDs for file systems that do not set the superblock UUID
Date: Wed,  6 Nov 2019 23:43:01 +0000
Message-ID: <20191106234301.283006-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Some file systems such as squashfs do not set the UUID in the
superblock resulting in a zero'd UUID.  In cases were two or more
of these file systems are overlayed on the lower layer we can hit
overlay corruption issues because identical zero'd overlayfs UUIDs
are impossible to differentiate between.  This can be fixed by
creating an overlayfs UUID based on the file system from the
superblock s_magic and s_dev fields.  (This currently seems like
enough information to be able create a UUID, but the could be
scope to use other super block fields such as the pointer s_fs_info
but may need some obfuscation).

This issue can be reproduced with the following commands:

mkdir -p /cdrom
mount -t iso9660 -o ro,noatime /dev/sr0 /cdrom
sleep 1
mkdir -p /cow
mount -t tmpfs -o 'rw,noatime,mode=755' tmpfs /cow
mkdir -p /cow/upper
mkdir -p /cow/work
modprobe -q -b overlay
modprobe -q -b loop
dev=$(losetup -f)
mkdir -p /filesystem.squashfs
losetup $dev /cdrom/casper/filesystem.squashfs
mount -t squashfs -o ro,noatime $dev /filesystem.squashfs
dev=$(losetup -f)
mkdir -p /installer.squashfs
losetup $dev /cdrom/casper/installer.squashfs
mount -t squashfs -o ro,noatime $dev /installer.squashfs
mkdir -p /root-tmp
mount -t overlay -o 'upperdir=/cow/upper,lowerdir=/installer.squashfs:/filesystem.squashfs,workdir=/cow/work' /cow /root-tmp

FILE=/root-tmp/etc/.pwd.lock

echo foo > $FILE
cat $FILE
sync
echo 3 > /proc/sys/vm/drop_caches
cat $FILE

The output from cat $FILE:
cat: /root-tmp/etc/.pwd.lock: Input/output error

dmesg reports:
[ 42.415432] overlayfs: invalid origin (etc/.pwd.lock, ftype=8000, origin ftype=4000).

BugLink: https://bugs.launchpad.net/bugs/1824407
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/overlayfs/copy_up.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index b801c6353100..a578db87936b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -231,6 +231,7 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 	void *buf;
 	int buflen = MAX_HANDLE_SZ;
 	uuid_t *uuid = &real->d_sb->s_uuid;
+	static const uuid_t z_uuid;
 
 	buf = kmalloc(buflen, GFP_KERNEL);
 	if (!buf)
@@ -272,7 +273,20 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 	if (is_upper)
 		fh->flags |= OVL_FH_FLAG_PATH_UPPER;
 	fh->len = fh_len;
-	fh->uuid = *uuid;
+
+	if (uuid_equal(uuid, &z_uuid)) {
+		/*
+		 * An zero'd uuid indicates the uuid in the super block was
+		 * not set by the file system, so fake one instead
+		 */
+		struct super_block *sb = real->d_sb;
+
+		memcpy(&fh->uuid.b[0], &sb->s_magic, 8);
+		memcpy(&fh->uuid.b[8], &sb->s_dev, 8);
+	} else {
+		fh->uuid = *uuid;
+	}
+
 	memcpy(fh->fid, buf, buflen);
 
 out:
-- 
2.20.1
