Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794297898;
	b=mBL2wI4RGjGWTosFI8dIk+opyYzwQHiLY/GxE73zAM+QnK/PhzX7m44wbDDH8TvcCOf3
	 N1YbmI2cl3dIi8Zjy2N0XvjcPNoQsn9AsxgeNvj1NQyfKits+A+UewaWU3xvE0S2FJAWu
	 /dp0+42slMFTA0nOBNtf276sVPjETdf9Q6G2quhS/+6vmByPek0q74+iWLBhXSQ1FqWSn
	 3OCNDojkyFybC1q18giRn51RaqEMmSLGcgGSKn2C59YN6MfA6X6tb1rDn3FhGyTH9PYOn
	 kybn1UayVDsaEJOFBd+FHsufoy8KFpGJrCXXkT94Iep5Nxu6jDlhYSM4N5j2BDqw5Sw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794297898;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RaFRATRdJGKGjvX3uJXY0s/OhS2GhKkGePwOtrSiyv8=;
	b=s5+054DxMXyTm5B1nenJj1YbFXwtBm/mmS2MrUMT76REzm9q47Gj+xNKyjICwh5TznJf
	 CcP/90L5J4h9jBHxFaA9/jP1IujTIw2Ca2zTYsNeZPOaKGshs8E6YQfwObwtDHMEJHDZM
	 BFL3BUPZ9utiTj+eOt3ilOcZL9SUYvYyK8wiwjiMQGaDQdZt6zWBcwx3ZwoELPOjMBEEX
	 v6iS+Y7XeCaiSjeoDOqPQyrbERK4Bdp6+9kGbh5DTHyZJepWD1M2HSN0d9GprMuEfZ1EM
	 VS0KJA19fAJMccPVd2J7BCIQanmeb4sptFTYSQ9hcadf0Kqdx0G8POv9XK0iy4T3heQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L1Rea5A+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97997606A325;
	Tue, 10 Nov 2026 08:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L1Rea5A+
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794297897;
	b=F+J6igNpsoz7gbLn8ibk14oDGm2WAdnqGxcgcBwfhuNcGwt736JNZgZ0/kVaCkEbHLkM
	 NttWCqOl+oNUzMmY8MNmEf3bXrfha+nBMdprC9+vgGa/M3B8fxUlu1AcvLCCkG1WpIe+V
	 av/EWsv4CSjPOB2hHUX5EQMHiw6cq9CkSqpyPOotBFkrQZATkglk/ys+eaHDaAH2CZpKg
	 WUnegPqZ2+8UzGJMh/u/AkddNQVE5MxGbsFxLSxK/Wf6z9WZMrjXUg1DXScAduWvlZwVK
	 3NHqFWbivqdjj7kwmxZeGXseVNu4S4SC6Ecnb9sCDyzwQN5rf4oNbRrzBfhgS0Ni8ww==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794297897;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=RaFRATRdJGKGjvX3uJXY0s/OhS2GhKkGePwOtrSiyv8=;
	b=z2l8ys/m3MkLaCGw0x9V5UzyGNN2gElQUDd1aZCw13hzlv/AXwFCV63H4BuiHa7ixkna
	 XBDm6RCyMImJr83ijkXntd4E4DOrrRIQDNxgHAN6R54r2wizOsMaO4vs9eKn7p7nYHqg2
	 +rdWIaEgw4gfBsskcZN50UdBYWycZ78BrKO0tivF/me+4mMUV5dxZnFfMw2o1LTCmUJHh
	 Mkz9r7Wpk1sdR184KDly5CF00zI3dr9qj8DAGT5AyfWID0jKdLCeR4wOCCpDzJlpMr66c
	 OOc2EyaWxg7rdkuqBI58O8MGkENX47hDfDzFvZj/gMfw6qF9w8IG1t6Ub3DDsuo+yTQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2775D1F0089F;
	Tue, 10 Nov 2026 08:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794297897;
	bh=RaFRATRdJGKGjvX3uJXY0s/OhS2GhKkGePwOtrSiyv8=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=L1Rea5A+1BSKC8w7W8vl4Ocsbfd36RaUDTdXBxjecH6eLLG/8jApF7XnDyLYnd8YF
	 ooLgZJo2RuMHOC+BdnxFGd0mPk1r68/ga55GP2EF9XCcMkUH6HA4A+52c9XpLuwmHp
	 x2+k3/F20/oCKcg8yMUFLqLTfNNBdgfPdTN8Bf9L3VsnjLM4gSeHYOTQrc8TAgv2qY
	 mkgkn5Cc41QiOC3705TffXizSa+B4UYqHHgusrB0FY4/4WL0J0SiKeAJXLTAHmV7hb
	 zFjQul2EZdcJff2QhdYtUZ2dug2hbvYnp6ZiW0iPFeivmxFGso1CgZw7Zde2bxHdfk
	 H3SpV5u4/txlw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 92B7848A2F;
	Tue, 10 Nov 2026 08:04:55 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 10 Nov 2026 17:04:56 +0900
Subject: [PATCH] overlay/077: check a stale entry in an impure dir on any
 hash seed
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261110-ovl077-stale-next-v1-1-948a5a434ae2@samsung.com>
X-B4-Tracking: v=1; b=H4sIACfQ8moC/x3MQQqAIBBA0avErBtwgrK6SrSQGmsgLFREkO6et
 HyL/wsE9sIB5qaA5yRBbldBbQPbadzBKHs1dKobiEjhnS6lNYZoLkbHOaKxZKZxY009Qe0ez1b
 y/1zW9/0A4eMTKmMAAAA=
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Hungyu Lin <dennylin0707@gmail.com>, 
 linux-unionfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794297895; l=11091;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=OLCueKykNIIjER7cHa0BSvlgWhhRdwwf3tOaDlx9BaE=;
 b=97oPpS9XEj9T1lXCGWs92ZVwYdHxAAaWF+D7Otu9J99sSYSxKQfzvSmeOt1WOQiQ8txzPN1Tb
 xYDvPkzlkC4AuVSm/bVxoSvV2o0QD4DcTLnb4ArAupbEDk890hssBu2
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

overlay/077 already fails on a stale entry in an impure upper dir, but
only when the dir hash order puts the removed file where ext4 keeps it
between getdents calls. ext4 returns the entry that did not fit in the
previous buffer first in the next call, even after it was removed.

Add a bare "-" and a bare "=" argument to t_dir_offset2. They remove or
recreate the entry the next getdents call returns first. The old fd may
list a recreated name with the st_ino of the old or the new file.

Use both on a new impure dir that only has entries with origin. The
existing impure dir also has o0, which has no origin. If the next entry
is o0, its d_ino is the same whether it is stale or not, and the case
is not checked.

With an ext4 upper, overlay/077 now fails on every hash seed until the
kernel fix "ovl: skip stale entries in impure dir iteration" is applied.

Link: https://lore.kernel.org/linux-unionfs/CAGEkeHcg06kHshHQ=9U6Yrs_wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com/
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Please hold this patch until the kernel fix is accepted. With this
change, overlay/077 fails on every ext4 run of a kernel without it.
The fix is "ovl: skip stale entries in impure dir iteration":
https://lore.kernel.org/linux-unionfs/20261110-ovl-impure-stale-v1-1-1a4c2039e89d@samsung.com/
---
 src/t_dir_offset2.c | 126 +++++++++++++++++++++++++++++++++++++++++++++++++---
 tests/overlay/077   |  25 ++++++++++-
 2 files changed, 143 insertions(+), 8 deletions(-)

diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
index 026bc8f3..621255e6 100644
--- a/src/t_dir_offset2.c
+++ b/src/t_dir_offset2.c
@@ -10,6 +10,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <limits.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <stdint.h>
@@ -31,13 +32,63 @@ struct linux_dirent64 {
 
 static uint64_t d_off_history[HISTORY_LEN];
 static uint64_t d_ino_history[HISTORY_LEN];
+static char next_name[NAME_MAX + 1];
 
 void usage()
 {
 	fprintf(stderr, "usage: t_dir_offset2: <dir> [[bufsize] [-|+]<filename> [-v]]\n");
+	fprintf(stderr, "       t_dir_offset2: <dir> bufsize -|= [-v]\n");
+	fprintf(stderr, "  a bare - removes, a bare = recreates, the entry\n"
+			"  the next getdents returns\n");
 	exit(EXIT_FAILURE);
 }
 
+/*
+ * Find the entry that the next getdents call on fd returns first: read one
+ * entry from a second fd at the same offset. ext4 with a hashed dir keeps
+ * the entry that did not fit in the previous buffer and returns it in the
+ * next call even after it was removed, so removing or recreating this
+ * entry gets a stale entry on any hash seed.
+ */
+static int find_next_entry(const char *dir, int fd)
+{
+	char buf[BUF_SIZE];
+	struct linux_dirent64 *d;
+	off_t off = lseek(fd, 0, SEEK_CUR);
+	int fd3, nread, bpos;
+
+	if (off == -1) {
+		perror("lseek");
+		return -1;
+	}
+	fd3 = open(dir, O_RDONLY | O_DIRECTORY);
+	if (fd3 < 0) {
+		perror("open");
+		return -1;
+	}
+	if (lseek(fd3, off, SEEK_SET) != off) {
+		perror("lseek");
+		close(fd3);
+		return -1;
+	}
+	while ((nread = syscall(SYS_getdents64, fd3, buf, sizeof(buf))) > 0) {
+		for (bpos = 0; bpos < nread; bpos += d->d_reclen) {
+			d = (struct linux_dirent64 *) (buf + bpos);
+			if (!strcmp(d->d_name, ".") || !strcmp(d->d_name, ".."))
+				continue;
+			snprintf(next_name, sizeof(next_name), "%s", d->d_name);
+			close(fd3);
+			return 0;
+		}
+	}
+	if (nread < 0)
+		perror("getdents");
+	else
+		fprintf(stderr, "no entry after the first getdents\n");
+	close(fd3);
+	return -1;
+}
+
 int main(int argc, char *argv[])
 {
 	int fd, fd2 = -1;
@@ -50,7 +101,8 @@ int main(int argc, char *argv[])
 	int retval = EXIT_SUCCESS;
 	const char *filename = NULL;
 	int exists = 0, found = 0;
-	int modify = 0, verbose = 0;
+	int modify = 0, verbose = 0, next = 0, recreate = 0;
+	uint64_t old_ino = 0;
 
 	if (argc > 2) {
 		bufsize = atoi(argv[2]);
@@ -61,13 +113,21 @@ int main(int argc, char *argv[])
 
 		if (argc > 3) {
 			filename = argv[3];
-			/* +<filename> creates, -<filename> removes */
+			/*
+			 * +<filename> creates, -<filename> removes, a bare -
+			 * removes and a bare = recreates the entry that the
+			 * next getdents returns
+			 */
 			if (filename[0] == '+')
 				modify = 1;
 			else if (filename[0] == '-')
 				modify = -1;
+			else if (!strcmp(filename, "="))
+				modify = recreate = 1;
 			if (modify)
 				filename++;
+			if ((modify < 0 || recreate) && !filename[0])
+				next = 1;
 			if (argc > 4 && !strcmp(argv[4], "-v"))
 				verbose = 1;
 		}
@@ -81,7 +141,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (filename) {
+	if (filename && !next) {
 		exists = !fstatat(fd, filename, &st, AT_SYMLINK_NOFOLLOW);
 		if (!exists && errno != ENOENT) {
 			perror("fstatat");
@@ -100,8 +160,52 @@ int main(int argc, char *argv[])
 		if (modify && fd2 < 0 && total == 0) {
 			printf("getdents at offset 0 returned %d bytes\n", nread);
 
-			/* create/unlink entry after first getdents */
-			if (modify > 0) {
+			if (next) {
+				if (find_next_entry(argv[1], fd))
+					exit(EXIT_FAILURE);
+				filename = next_name;
+			}
+
+			/* create/unlink/recreate entry after first getdents */
+			if (recreate) {
+				/*
+				 * Keep the old inode open so that the new file
+				 * cannot get its inode number. The old fd may
+				 * still list the old file with its old st_ino.
+				 */
+				int flags = O_PATH | O_NOFOLLOW;
+				int ofd = openat(fd, filename, flags);
+				struct stat ost;
+				int nfd;
+
+				if (ofd < 0) {
+					perror("openat");
+					exit(EXIT_FAILURE);
+				}
+				if (fstat(ofd, &ost) < 0) {
+					perror("fstat");
+					exit(EXIT_FAILURE);
+				}
+				old_ino = ost.st_ino;
+				if (unlinkat(fd, filename, 0) < 0) {
+					perror("unlinkat");
+					exit(EXIT_FAILURE);
+				}
+				nfd = openat(fd, filename, O_CREAT | O_EXCL,
+					     0600);
+				if (nfd < 0) {
+					perror("openat");
+					exit(EXIT_FAILURE);
+				}
+				if (fstat(nfd, &st) < 0) {
+					perror("fstat");
+					exit(EXIT_FAILURE);
+				}
+				close(nfd);
+				close(ofd);
+				exists = 1;
+				printf("recreated entry %s\n", filename);
+			} else if (modify > 0) {
 				if (openat(fd, filename, O_CREAT, 0600) < 0) {
 					perror("openat");
 					exit(EXIT_FAILURE);
@@ -109,6 +213,11 @@ int main(int argc, char *argv[])
 				exists = 1;
 				printf("created entry %s\n", filename);
 			} else if (modify < 0) {
+				if (next && fstatat(fd, filename, &st,
+						    AT_SYMLINK_NOFOLLOW)) {
+					perror("fstatat");
+					exit(EXIT_FAILURE);
+				}
 				if (unlinkat(fd, filename, 0) < 0) {
 					perror("unlinkat");
 					exit(EXIT_FAILURE);
@@ -164,8 +273,13 @@ int main(int argc, char *argv[])
 					       i, d->d_name, (long long int)d->d_ino,
 					       (long long int)d->d_off);
 				if (!strcmp(filename, d->d_name)) {
+					/* the old fd may list it stale */
+					int stale = fd != fd2 && old_ino &&
+						    d->d_ino == old_ino;
+
 					found = 1;
-					if (st.st_ino && d->d_ino != st.st_ino) {
+					if (!stale && st.st_ino &&
+					    d->d_ino != st.st_ino) {
 						fprintf(stderr, "entry %s has inconsistent d_ino (%lld != %lld)\n",
 								filename,
 								(long long int)d->d_ino,
diff --git a/tests/overlay/077 b/tests/overlay/077
index 00de0825..6426bc26 100755
--- a/tests/overlay/077
+++ b/tests/overlay/077
@@ -9,6 +9,7 @@
 # This is a regression test for kernel commits:
 # 65cd913ec9d9 ("ovl: invalidate readdir cache on changes to dir with origin")
 # 9011c2791e63 ("ovl: skip stale entries in merge dir cache iteration")
+# xxxxxxxxxxxx ("ovl: skip stale entries in impure dir iteration")
 #
 . ./common/preamble
 _begin_fstest auto quick dir
@@ -20,6 +21,8 @@ _fixed_by_kernel_commit 65cd913ec9d9 \
 	"ovl: invalidate readdir cache on changes to dir with origin"
 _fixed_by_kernel_commit 9011c2791e63 \
 	"ovl: skip stale entries in merge dir cache iteration"
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"ovl: skip stale entries in impure dir iteration"
 
 _require_scratch_nocheck
 
@@ -40,16 +43,20 @@ create_files() {
 _scratch_mkfs
 
 # Create test area with a merge dir, a "former" merge dir,
-# a pure upper dir and impure upper dir. For each case, overlayfs
+# a pure upper dir and two impure upper dirs. For each case, overlayfs
 # readdir cache is used a bit differently.
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 
-mkdir -p $lowerdir/merge $lowerdir/former $upperdir/pure $upperdir/impure
+mkdir -p $lowerdir/merge $lowerdir/former $upperdir/pure $upperdir/impure \
+	$upperdir/impure2
 # Lower files in merge dir are listed first
 create_files $lowerdir/merge m
 # Files to be moved into impure upper dir
 create_files $lowerdir o
+# Files to be moved into another impure upper dir, which only has entries
+# with origin
+create_files $lowerdir n
 # File to be moved into former merge dir to make it impure
 touch $lowerdir/f100
 
@@ -61,6 +68,7 @@ create_files $SCRATCH_MNT/former f
 touch $SCRATCH_MNT/merge/m100
 # Move copied up files so readdir will need to lookup origin d_ino
 mv $SCRATCH_MNT/o* $SCRATCH_MNT/impure/
+mv $SCRATCH_MNT/n* $SCRATCH_MNT/impure2/
 mv $SCRATCH_MNT/f100 $SCRATCH_MNT/former/
 
 # Remove the lower directory and mount overlay again to create
@@ -84,6 +92,19 @@ $here/src/t_dir_offset2 $SCRATCH_MNT/impure $bufsize "+o0" 2>&1 >> $seqres.full
 echo -e "\nRemove file in impure upper dir:" >> $seqres.full
 $here/src/t_dir_offset2 $SCRATCH_MNT/impure $bufsize  "-o100" 2>&1 >> $seqres.full || \
 	echo "Found unlinked file in impure upper dir (see $seqres.full for details)"
+# Remove the entry that the next getdents call returns first. An ext4 upper
+# with a hashed dir returns it even after it was removed, so this checks the
+# stale entry case on every hash seed, not only when ext4 happens to keep the
+# removed file.
+echo -e "\nRemove next file in impure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/impure2 $bufsize "-" 2>&1 >> $seqres.full || \
+	echo "Found unlinked next file in impure upper dir (see $seqres.full for details)"
+# Recreate the entry that the next getdents call returns first. A new fd
+# must list the name with the d_ino of the new file. The old fd may list it,
+# with the d_ino of the old or the new file.
+echo -e "\nRecreate next file in impure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/impure2 $bufsize "=" 2>&1 >> $seqres.full || \
+	echo "Missing recreated next file in impure upper dir (see $seqres.full for details)"
 
 # Check readdir cache invalidate on merge dir
 echo -e "\nCreate file in merge dir:" >> $seqres.full

---
base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
change-id: 20261110-ovl077-stale-next-af1a98ce7151

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


