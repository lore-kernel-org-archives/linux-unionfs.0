From: Zhang AiHua <zhangaihua1@huawei.com>
Subject: =?UTF-8?Q?retry=ef=bc=9a[PATCH]_fix_error:_a_bin_file_can_truncate_?=
 =?UTF-8?Q?itself_while_running_on_overlayfs?=
Date: Mon, 27 Jun 2016 09:06:54 +0800
Message-ID: <57707C2E.2080500@huawei.com>
References: <1466590388-4914-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:55771 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbcF0BJZ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 26 Jun 2016 21:09:25 -0400
In-Reply-To: <1466590388-4914-1-git-send-email-zhangaihua1@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org




-------- =D7=AA=B7=A2=B5=C4=CF=FB=CF=A2 --------
=D6=F7=CC=E2: [PATCH] fix error: a bin file can truncate itself while r=
unning on overlayfs
=C8=D5=C6=DA: Wed, 22 Jun 2016 18:13:08 +0800
=B7=A2=BC=FE=C8=CB: zhangaihua1@huawei.com
=CA=D5=BC=FE=C8=CB: linux-fsdevel@vger.kernel.org, linux-kernel@vger.ke=
rnel.org, linux-unionfs@vger.kernel.org
=B3=AD=CB=CD: Aihua Zhang <zhangaihua1@huawei.com>

=46rom: Aihua Zhang <zhangaihua1@huawei.com>

I wrote a testcase to truncate a bin file while it is running on overla=
yfs.

the mount:
/dev/mapper/fedora-home on /home type ext4 (rw,relatime,data=3Dordered)
overlay on /tmp type overlay (rw,relatime,lowerdir=3D/home/zah/lower,
		upperdir=3D/home/zah/upper,workdir=3D/home/zah/workdir)

the code cpp:
int main(int argc, char *argv[])
{
int status;
pthread_t thread;
int err;
char *ptr;

ptr =3D basename(argv[0]);
printf("%s\n",ptr);
errno =3D 0;

status =3D truncate(ptr, 4096);
printf("status:%d\n",status);
printf("errno:%d\n",errno);
printf("ETXTBSY:%d\n",ETXTBSY);

if ((-1 =3D=3D status) && (ETXTBSY =3D=3D errno))
{
printf("PASS\n");
return 0;
}

err =3D errno;
printf("err =3D %d\n", err);
printf("FAIL\n");
return 1;
}

I running the test on overlayfs, the result as below:
Bus error (core dumped)

and running the test on ext4, the result as below:
status:-1
errno:26
ETXTBSY:26
PASS

I add some log, and I find the inode is not correct on overlayfs,
and the inode->i_writecount is not correct also called by vfs_truncate-=
>
get_write_access(), the log as below:

Jun 22 09:50:38 kernel: [131.872920] deny_write_access: inode ino 64104=
618
Jun 22 09:50:38 kernel: [131.873109] deny_write_access: inode ino 64104=
618
Jun 22 09:50:38 kernel: [131.873110] __vma_link_file: inode ino 6410461=
8
Jun 22 09:50:38 kernel: [131.873112] allow_write_access: inode ino 6410=
4618
Jun 22 09:50:38 kernel: [131.873114] deny_write_access: inode ino 64104=
618
Jun 22 09:50:38 kernel: [131.873115] __vma_link_file: inode ino 6410461=
8
Jun 22 09:50:38 kernel: [131.873116] allow_write_access: inode ino 6410=
4618
Jun 22 09:50:38 kernel: [131.873162] allow_write_access: inode ino 6410=
4618
Jun 22 09:50:38 kernel: [131.873947] __vma_link_file: inode ino 6410461=
8
Jun 22 09:50:38 kernel: [131.874039] vfs_truncate: inode ino:24061

before vfs_truncate, the inode is point to upper filesystem(ext4),
and in vfs_truncate the inode is point to overlayfs.

So, I fix it by geting the real inode via ovl_d_select_inode.

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
  fs/open.c |   10 ++++++++--
  1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 93ae3cd..43b17d1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -67,10 +67,16 @@ int do_truncate(struct dentry *dentry, loff_t lengt=
h, unsigned int time_attrs,

  long vfs_truncate(const struct path *path, loff_t length)
  {
+	struct dentry *dentry =3D path->dentry;
  	struct inode *inode;
  	long error;

-	inode =3D path->dentry->d_inode;
+	if (dentry->d_flags & DCACHE_OP_SELECT_INODE) {
+		inode =3D dentry->d_op->d_select_inode(dentry, O_TRUNC);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+	} else
+		inode =3D dentry->d_inode;

  	/* For directories it's -EISDIR, for other non-regulars - -EINVAL */
  	if (S_ISDIR(inode->i_mode))
@@ -106,7 +112,7 @@ long vfs_truncate(const struct path *path, loff_t l=
ength)
  	if (!error)
  		error =3D security_path_truncate(path);
  	if (!error)
-		error =3D do_truncate(path->dentry, length, 0, NULL);
+		error =3D do_truncate(dentry, length, 0, NULL);

  put_write_and_out:
  	put_write_access(inode);
--=20
1.7.1


=2E
