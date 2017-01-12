From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Thu, 12 Jan 2017 11:00:56 +0100
Message-ID: <20170112100056.GF27207@veci.piliscsaba.szeredi.hu>
References: <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk>
 <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
 <20161111002756.GP19539@ZenIV.linux.org.uk>
 <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
 <20161111154034.GR19539@ZenIV.linux.org.uk>
 <CAOQ4uxgU3Pv_SRJhfOGVevuGop=fQ=rPK01UO0ccgy1yEM_hJA@mail.gmail.com>
 <20161111172737.GS19539@ZenIV.linux.org.uk>
 <CAJfpeguTOvO9P+khKxOX_-SBjePzeLqUqQ2B9sBszjamD3wWvA@mail.gmail.com>
 <CAOQ4uxhrGRPg68SRQhyS=_PEe9SO9fkFv_=GUSELr_A=HSH0FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32957 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdALKBB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Jan 2017 05:01:01 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so2541981wme.0
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Jan 2017 02:01:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhrGRPg68SRQhyS=_PEe9SO9fkFv_=GUSELr_A=HSH0FQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Konstantin Khlebnikov <koct9i@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 12, 2017 at 07:42:22AM +0200, Amir Goldstein wrote:
> I think you suggested here to use a waitqueue for pending copyups?
> Did you mean a waitqueue per overlay parent directory inode or
> did you mean something else?

Something like this:

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index d14bca1850d9..a46e7e53cd7a 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -27,6 +27,7 @@ struct ovl_fs {
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
+	wait_queue_head_t copyup_wq;
 };
 
 /* private information held for every overlayfs dentry */
@@ -38,6 +39,7 @@ struct ovl_entry {
 			u64 version;
 			const char *redirect;
 			bool opaque;
+			bool copying;
 		};
 		struct rcu_head rcu;
 	};
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 952286f4826c..4e2b2c485165 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -263,3 +263,32 @@ struct file *ovl_path_open(struct path *path, int flags)
 {
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
+
+int ovl_copy_up_start(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_entry *oe = dentry->d_fsdata;
+	int err;
+
+	spin_lock(&ofs->copyup_wq.lock);
+	err = wait_event_interruptible_locked(ofs->copyup_wq, !oe->copying);
+	if (!err) {
+		if (oe->__upperdentry)
+			err = 1; /* Already copied up */
+		else
+			oe->copying = true;
+	}
+	spin_unlock(&ofs->copyup_wq.lock);
+
+	return err;
+}
+
+void ovl_copy_up_end(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	spin_lock(&ofs->copyup_wq.lock);
+	oe->copying = false;
+	spin_unlock(&ofs->copyup_wq.lock);
+}
