Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/5] open_by_handle: make -h (help) a valid option
Date: Thu, 29 Mar 2018 15:06:47 +0300
Message-Id: <1522325210-17900-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
References: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

All this does is suppress the "illegal value" message.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 78f7ef7..7dfb395 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,7 +27,7 @@
 
 /*
 
-usage: open_by_handle [-cludmrwapk] [<-i|-o> <handles_file>] <test_dir> [num_files]
+usage: open_by_handle [-cludmrwapkh] [<-i|-o> <handles_file>] <test_dir> [num_files]
 
 Examples:
 
@@ -109,7 +109,7 @@ struct handle {
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-cludmrwapk] [<-i|-o> <handles_file>] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludmrwapkh] [<-i|-o> <handles_file>] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
@@ -149,7 +149,7 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludmrwapki:o:")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwapkhi:o:")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
-- 
2.7.4
