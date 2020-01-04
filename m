Return-Path: <James.Bottomley@hansenpartnership.com>
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 3/3] fs: expose shifting bind mount to userspace
Date: Sat,  4 Jan 2020 12:39:46 -0800
Message-Id: <20200104203946.27914-4-James.Bottomley@HansenPartnership.com>
In-Reply-To: <20200104203946.27914-1-James.Bottomley@HansenPartnership.com>
References: <20200104203946.27914-1-James.Bottomley@HansenPartnership.com>
To: linux-fsdevel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Christian Brauner <christian@brauner.io>, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Seth Forshee <seth.forshee@canonical.com>, linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, Eric Biederman <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, containers@lists.linux-foundation.org
List-ID: <linux-unionfs@vger.kernel.org>

This capability is exposed currently through the proposed new bind
API. To mark a mount for shifting, you add the allow-shift flag to the
properties, either by a reconfigure or a rebind.  Only real root on
the system can do this.  Once this is done, admin in a user namespace
(i.e. an unprivileged user) can take that mount point and bind it with
a shift in effect.

The way an admin marks a mount is:

pathfd = open("/path/to/shift", O_PATH);
fd = configfd_open("bind", O_CLOEXEC);
configfd_action(fd, CONFIGFD_SET_FD, "pathfd", NULL, pathfd);
configfd_action(fd, CONFIGFD_SET_FLAG, "allow-shift", NULL, 0);
configfd_action(fd, CONFIGFD_SET_FLAG, "detached", NULL, 0);
configfd_action(fd, CONFIGFD_CMD_CREATE, NULL, NULL, 0);
configfd_action(fd, CONFIGFD_GET_FD, "bindfd", &bindfd, O_CLOEXEC);

move_mount(bindfd, "", AT_FDCWD, "/path/to/allow", MOVE_MOUNT_F_EMPTY_PATH);

Technically /path/to/shift and /path/to/allow can be the same, which
basically installs a mnt at the path that allows onward traversal.

Then any mount namespace in a user namespace can do:

pathfd = open("/path/to/allow", O_PATH);
fd = configfd_open("bind", O_CLOEXEC);
configfd_action(fd, CONFIGFD_SET_FD, "pathfd", NULL, pathfd);
configfd_action(fd, CONFIGFD_SET_FLAG, "shift", NULL, 0);
configfd_action(fd, CONFIGFD_SET_FLAG, "detached", NULL, 0);
configfd_action(fd, CONFIGFD_CMD_CREATE, NULL, NULL, 0);
configfd_action(fd, CONFIGFD_GET_FD, "bindfd", &bindfd, O_CLOEXEC);

move_mount(bindfd, "", AT_FDCWD, "/path/to/mount", MOVE_MOUNT_F_EMPTY_PATH);

And /path/to/mount will have the uid/gid shifting bind mount installed.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 fs/bind.c           | 35 +++++++++++++++++++++++++++++++++++
 fs/mount.h          |  2 ++
 fs/namespace.c      |  1 +
 fs/proc_namespace.c |  4 ++++
 4 files changed, 42 insertions(+)

diff --git a/fs/bind.c b/fs/bind.c
index eea4e6cd5108..6b4668041248 100644
--- a/fs/bind.c
+++ b/fs/bind.c
@@ -21,6 +21,8 @@ struct bind_data {
 	bool		nodev:1;
 	bool		detached:1;
 	bool		recursive:1;
+	bool		shift:1;
+	bool		allow_shift:1;
 	struct file	*file;
 	struct file	*retfile;
 };
@@ -66,6 +68,25 @@ static int bind_set_flag(const struct configfd_context *cfc,
 		bd->nodev = true;
 	} else if (strcmp(p->key, "noexec") == 0) {
 		bd->noexec = true;
+	} else if (strcmp(p->key, "shift") == 0) {
+		struct mount *m;
+
+		if (!bd->file) {
+			logger_err(cfc->log, "can't shift without setting pathfd");
+			return -EINVAL;
+		}
+		m = real_mount(bd->file->f_path.mnt);
+		if (!m->allow_shift) {
+			logger_err(cfc->log, "pathfd doesn't allow shifting");
+			return -EINVAL;
+		}
+		bd->shift = true;
+	} else if (strcmp(p->key, "allow-shift") == 0) {
+		if (!capable(CAP_SYS_ADMIN)) {
+			logger_err(cfc->log, "must be root to set allow-shift");
+			return -EPERM;
+		}
+		bd->allow_shift = true;
 	} else if (strcmp(p->key, "recursive") == 0 &&
 		   cfc->op == CONFIGFD_CMD_CREATE) {
 		bd->recursive = true;
@@ -126,6 +147,8 @@ static int bind_get_mnt_flags(struct bind_data *bd, int mnt_flags)
 		mnt_flags |= MNT_NODEV;
 	if (bd->noexec)
 		mnt_flags |= MNT_NOEXEC;
+	if (bd->shift)
+		mnt_flags |= MNT_SHIFT;
 
 	return mnt_flags;
 }
@@ -143,6 +166,13 @@ static int bind_reconfigure(const struct configfd_context *cfc)
 	mnt_flags = bd->file->f_path.mnt->mnt_flags & MNT_ATIME_MASK;
 	mnt_flags = bind_get_mnt_flags(bd, mnt_flags);
 
+	if (bd->allow_shift) {
+		struct mount *m = real_mount(bd->file->f_path.mnt);
+
+		/* FIXME: this should be set with the reconfigure locking */
+		m->allow_shift = true;
+	}
+
 	return do_reconfigure_mnt(&bd->file->f_path, mnt_flags);
 }
 
@@ -183,6 +213,11 @@ static int bind_create(const struct configfd_context *cfc)
 
 		/* since this is a detached copy, we can do without locking */
 		f->f_path.mnt->mnt_flags |= mnt_flags;
+		if (bd->allow_shift) {
+			struct mount *m = real_mount(f->f_path.mnt);
+
+			m->allow_shift = true;
+		}
 	}
 
 	bd->retfile = f;
diff --git a/fs/mount.h b/fs/mount.h
index 711a4093e475..1da13decf93b 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -72,6 +72,8 @@ struct mount {
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	struct hlist_head mnt_pins;
 	struct hlist_head mnt_stuck_children;
+	/* shifting bind mount parameters */
+	bool allow_shift:1;
 } __randomize_layout;
 
 #define MNT_NS_INTERNAL ERR_PTR(-EINVAL) /* distinct from any mnt_namespace */
diff --git a/fs/namespace.c b/fs/namespace.c
index 3ae0124e9783..8266e9540595 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1038,6 +1038,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 
 	mnt->mnt.mnt_flags = old->mnt.mnt_flags;
 	mnt->mnt.mnt_flags &= ~(MNT_WRITE_HOLD|MNT_MARKED|MNT_INTERNAL);
+	mnt->allow_shift = old->allow_shift;
 
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_sb = sb;
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 273ee82d8aa9..bdf8d23cf42e 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -70,14 +70,18 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_SHIFT, ",shift" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
+	struct mount *rm = real_mount(mnt);
 
 	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
+	if (rm->allow_shift)
+		seq_puts(m, ",allow-shift");
 }
 
 static inline void mangle(struct seq_file *m, const char *s)
-- 
2.16.4
