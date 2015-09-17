From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] ovl: add O_LARGEFILE flag when copyup files
Date: Thu, 17 Sep 2015 17:25:25 +0100
Message-ID: <28493.1442507125@warthog.procyon.org.uk>
References: <1441962405-22278-1-git-send-email-xuw2015@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbbIQQZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 17 Sep 2015 12:25:30 -0400
In-Reply-To: <1441962405-22278-1-git-send-email-xuw2015@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: xuw2015@gmail.com
Cc: dhowells@redhat.com, alkisg@gmail.com, miklos@szeredi.hu, linux-unionfs@vger.kernel.org

xuw2015@gmail.com wrote:

> From: George Wang <xuw2015@gmail.com>
>=20
> now ovl only use O_RDONLY for lower and O_WRONLY for upper file. But =
if
> the file size larger than MAX_NON_LFS(1UL << 31 -1), will suffer
> -EOVERFLOW. We should add O_LARGEFILE flag to make it work. Following
> script can reproduct it:
>=20
> work
> truncate: cannot open =E2=80=98work/sparse=E2=80=99 for writing: Valu=
e too large for
> defined data type
>=20
> Reported-by: Alkis Georgopoulos <alkisg@gmail.com>
> Signed-off-by: George Wang <xuw2015@gmail.com>

I just produced something that looks very similar.  I think it might be=
 better
to only add the flag if it's needed in case one of the upper or lower
filesystems rejects it.

Also, it might be worth adding an enablement switch.

David
---
commit 0b365f2143939fa30cac8cf6899ff33825a767c9
Author: David Howells <dhowells@redhat.com>
Date:   Thu Sep 17 17:14:48 2015 +0100

    overlayfs: Conditionally use O_LARGEFILE in ovl_copy_up()
   =20
    Open the lower file with O_LARGEFILE in ovl_copy_up() if the lower =
file is
    >=3D 4GiB in size.
   =20
    Reported-by: Ulrich Obergfell <uobergfe@redhat.com>
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 84d693d37428..89b4cb3773d7 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -76,16 +76,19 @@ static int ovl_copy_up_data(struct path *old, struc=
t path *new, loff_t len)
 	struct file *new_file;
 	loff_t old_pos =3D 0;
 	loff_t new_pos =3D 0;
-	int error =3D 0;
+	int error =3D 0, o_flag =3D 0;
=20
 	if (len =3D=3D 0)
 		return 0;
=20
-	old_file =3D ovl_path_open(old, O_RDONLY);
+	if (i_size_read(d_inode(old->dentry)) > MAX_NON_LFS)
+		o_flag |=3D O_LARGEFILE;
+=09
+	old_file =3D ovl_path_open(old, o_flag | O_RDONLY);
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
=20
-	new_file =3D ovl_path_open(new, O_WRONLY);
+	new_file =3D ovl_path_open(new, o_flag | O_WRONLY);
 	if (IS_ERR(new_file)) {
 		error =3D PTR_ERR(new_file);
 		goto out_fput;
