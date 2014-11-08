From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
Date: Sat, 8 Nov 2014 19:27:23 +0100
Message-ID: <20141108192723.444cecd2@gmail.com>
References: <20141107170242.GA333@tucsk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/CZvCRgycISBJtD/4VoRv0JL"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20141107170242.GA333@tucsk>
Sender: linux-security-module-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "A. Wan" <jm@mokwan.com>, Patrick Frisch <patrick@frischux.de>, Aaron Campbell <aaron@arbor.net>
List-Id: linux-unionfs@vger.kernel.org

--MP_/CZvCRgycISBJtD/4VoRv0JL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

EL Fri, 7 Nov 2014 18:02:42 +0100
Miklos Szeredi <miklos@szeredi.hu> escrigu=C3=A9:

> This is the first iteration of the patch, and quite possibly buggy.
> Testing and review is welcome.
>=20
Hello,

I did light tests on this patch applied to kernel 3.18-rc3, it works.

Observations:

- option lowerdirs is an extended case of lowerdir,
then we can use only a name for that option and discard the other,
for compatibility with older versions may be lowerdir.

- overlayfs changes fast the mount options that we should specify,
an overlayfs version number will help the implementer to control it.

- limit filesystem depth by a kernel config parameter, allowing nomax.

- print more detailed error message

Following patches are included to better explain some points,
you can use the idea and make your best,

Regards,

Jordi Pujol

--MP_/CZvCRgycISBJtD/4VoRv0JL
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=54-overlayfs-version.patch

 modinfo --field=version overlayfs
 busybox modinfo -F version /lib/modules/$(uname -r)/kernel/fs/overlayfs.ko | awk '{print $NF}'
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -23,6 +23,7 @@
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(OVERLAYFS_VERSION);
 
 #define OVERLAYFS_SUPER_MAGIC 0x794c764f
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -9,6 +9,8 @@
 
 #include <linux/kernel.h>
 
+#define OVERLAYFS_VERSION   "25"
+
 struct ovl_entry;
 
 enum ovl_path_type {

--MP_/CZvCRgycISBJtD/4VoRv0JL
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=55-param-print-err-msg.patch

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -728,7 +728,10 @@ static int ovl_fill_super(struct super_b
 	}
 	if (!ufs->config.upperdir &&
 	    !ufs->config.lowerdir && !ufs->config.lowerdirs) {
-		pr_err("overlayfs: no 'upperdir', 'lowerdir' or 'lowerdirs' specified\n");
+		pr_err("overlayfs: missing%s%s%s\n",
+			ufs->config.upperdir ? "" : " upperdir",
+			ufs->config.lowerdir ? "" : " lowerdir",
+			ufs->config.lowerdirs ? "" : " lowerdirs");
 		goto out_free_config;
 	}
 

--MP_/CZvCRgycISBJtD/4VoRv0JL
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=53-fs__limit_filesystem_stacking_depth-kconfig.patch

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -246,12 +246,6 @@ struct iattr {
  */
 #include <linux/quota.h>
 
-/*
- * Maximum number of layers of fs stack.  Needs to be limited to
- * prevent kernel stack overflow
- */
-#define FILESYSTEM_MAX_STACK_DEPTH 2
-
 /** 
  * enum positive_aop_returns - aop return codes with specific semantics
  *
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -44,6 +44,12 @@ config INIT_ENV_ARG_LIMIT
 	  Maximum of each of the number of arguments and environment
 	  variables passed to init from the kernel command line.
 
+config FILESYSTEM_MAX_STACK_DEPTH
+	int "Maximum number of layers of fs stack"
+	default 2
+	help
+	  Maximum number of layers of fs stack.  Needs to be limited to
+	  prevent kernel stack overflow. Set to 0 for no limit.
 
 config CROSS_COMPILE
 	string "Cross-compiler tool prefix"
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -568,8 +568,9 @@ static struct dentry *ecryptfs_mount(str
 	s->s_magic = ECRYPTFS_SUPER_MAGIC;
 	s->s_stack_depth = path.dentry->d_sb->s_stack_depth + 1;
 
-	rc = -EINVAL;
-	if (s->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+	if (CONFIG_FILESYSTEM_MAX_STACK_DEPTH > 0 &&
+	s->s_stack_depth > CONFIG_FILESYSTEM_MAX_STACK_DEPTH) {
+		rc = -EINVAL;
 		pr_err("eCryptfs: maximum fs stacking depth exceeded\n");
 		goto out_free;
 	}
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -818,7 +818,8 @@ static int ovl_fill_super(struct super_b
 	}
 
 	err = -EINVAL;
-	if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
+	if (CONFIG_FILESYSTEM_MAX_STACK_DEPTH > 0 &&
+	sb->s_stack_depth > CONFIG_FILESYSTEM_MAX_STACK_DEPTH) {
 		pr_err("overlayfs: maximum fs stacking depth exceeded\n");
 		goto out_put_lowerpath;
 	}

--MP_/CZvCRgycISBJtD/4VoRv0JL--
