From: <zyjzyj2000@gmail.com>
Subject: [PATCH 1/1] overlayfs: restrict structs visible in current code module
Date: Mon, 4 Jan 2016 17:42:50 +0800
Message-ID: <1451900570-28233-1-git-send-email-zyjzyj2000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:59245 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbcADJma (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 4 Jan 2016 04:42:30 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, zyjzyj2000@gmail.com

From: Zhu Yanjun <zyjzyj2000@gmail.com>

The structs ovl_cache_entry, ovl_dir_cache and ovl_dir_file
are only used in the file fs/overlayfs/readdir.c. As such,
the static keyword is inserted to define that object to be
only visible to the current code module during compilation.

Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
---
 fs/overlayfs/readdir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 70e9af5..362bc1c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -17,7 +17,7 @@
 #include <linux/cred.h>
 #include "overlayfs.h"
 
-struct ovl_cache_entry {
+static struct ovl_cache_entry {
 	unsigned int len;
 	unsigned int type;
 	u64 ino;
@@ -28,13 +28,13 @@ struct ovl_cache_entry {
 	char name[];
 };
 
-struct ovl_dir_cache {
+static struct ovl_dir_cache {
 	long refcount;
 	u64 version;
 	struct list_head entries;
 };
 
-struct ovl_readdir_data {
+static struct ovl_readdir_data {
 	struct dir_context ctx;
 	bool is_merge;
 	struct rb_root root;
@@ -45,7 +45,7 @@ struct ovl_readdir_data {
 	int err;
 };
 
-struct ovl_dir_file {
+static struct ovl_dir_file {
 	bool is_real;
 	bool is_upper;
 	struct ovl_dir_cache *cache;
-- 
1.7.9.5
