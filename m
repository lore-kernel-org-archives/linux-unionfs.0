From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/7] open_by_handle: add filename to error reports
Date: Thu,  2 Nov 2017 12:15:33 +0200
Message-ID: <1509617739-15744-2-git-send-email-amir73il@gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This makes it easier to understand which of the tests
failed when testing on overlay lower and upper files.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 63ebdac..52973c6 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -156,7 +156,7 @@ int main(int argc, char **argv)
 		sprintf(fname2, "%s/link%06d", test_dir, i);
 		fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
 		if (fd < 0) {
-			printf("Warning (%s,%d), open(%s) failed.\n", __FILE__, __LINE__, fname);
+			strcat(fname, ": open");
 			perror(fname);
 			return EXIT_FAILURE;
 		}
@@ -164,7 +164,8 @@ int main(int argc, char **argv)
 		/* blow up leftovers hardlinks if they exist */
 		ret = unlink(fname2);
 		if (ret < 0 && errno != ENOENT) {
-			perror("unlink");
+			strcat(fname2, ": unlink");
+			perror(fname2);
 			return EXIT_FAILURE;
 		}
 	}
@@ -178,7 +179,8 @@ int main(int argc, char **argv)
 		handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
 		ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
 		if (ret < 0) {
-			perror("name_to_handle");
+			strcat(fname, ": name_to_handle");
+			perror(fname);
 			return EXIT_FAILURE;
 		}
 	}
@@ -193,7 +195,8 @@ int main(int argc, char **argv)
 		sprintf(fname2, "%s/link%06d", test_dir, i);
 		ret = link(fname, fname2);
 		if (ret < 0) {
-			perror("link");
+			strcat(fname2, ": link");
+			perror(fname2);
 			return EXIT_FAILURE;
 		}
 	}
@@ -204,14 +207,16 @@ int main(int argc, char **argv)
 		sprintf(fname2, "%s/link%06d", test_dir, i);
 		ret = unlink(fname);
 		if (ret < 0) {
-			perror("unlink");
+			strcat(fname, ": unlink");
+			perror(fname);
 			return EXIT_FAILURE;
 		}
 		/* with -d flag, delete the hardlink if it exists */
 		if (!nlink)
 			ret = unlink(fname2);
 		if (ret < 0 && errno != ENOENT) {
-			perror("unlink");
+			strcat(fname2, ": unlink");
+			perror(fname2);
 			return EXIT_FAILURE;
 		}
 	}
@@ -246,11 +251,13 @@ int main(int argc, char **argv)
 		} else if (!nlink && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
 			continue;
 		}
+		sprintf(fname, "%s/file%06d", test_dir, i);
 		if (fd >= 0) {
-			printf("open_by_handle(%d) opened an unlinked file!\n", i);
+			printf("open_by_handle(%s) opened an unlinked file!\n", fname);
 			close(fd);
 		} else {
-			printf("open_by_handle(%d) returned %d incorrectly on %s file!\n", i, errno,
+			printf("open_by_handle(%s) returned %d incorrectly on %s file!\n",
+					fname, errno,
 					nlink ? "a linked" : "an unlinked");
 		}
 		failed++;
-- 
2.7.4
