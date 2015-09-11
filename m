From: xuw2015@gmail.com
Subject: [PATCH] ovl: add O_LARGEFILE flag when copyup files
Date: Fri, 11 Sep 2015 17:06:45 +0800
Message-ID: <1441962405-22278-1-git-send-email-xuw2015@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbbIKJGw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 11 Sep 2015 05:06:52 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: alkisg@gmail.com, miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>

=46rom: George Wang <xuw2015@gmail.com>

now ovl only use O_RDONLY for lower and O_WRONLY for upper file. But if
the file size larger than MAX_NON_LFS(1UL << 31 -1), will suffer
-EOVERFLOW. We should add O_LARGEFILE flag to make it work. Following
script can reproduct it:

work
truncate: cannot open =E2=80=98work/sparse=E2=80=99 for writing: Value =
too large for
defined data type

Reported-by: Alkis Georgopoulos <alkisg@gmail.com>
Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/overlayfs/copy_up.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 84d693d..e8ed965 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -81,11 +81,11 @@ static int ovl_copy_up_data(struct path *old, struc=
t path *new, loff_t len)
 	if (len =3D=3D 0)
 		return 0;
=20
-	old_file =3D ovl_path_open(old, O_RDONLY);
+	old_file =3D ovl_path_open(old, O_RDONLY | O_LARGEFILE);
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
=20
-	new_file =3D ovl_path_open(new, O_WRONLY);
+	new_file =3D ovl_path_open(new, O_WRONLY | O_LARGEFILE);
 	if (IS_ERR(new_file)) {
 		error =3D PTR_ERR(new_file);
 		goto out_fput;
--=20
1.8.3.1
