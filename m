From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] security, overlayfs: provide copy up security hook
 for unioned files
Date: Fri, 8 Jul 2016 09:42:58 -0400
Message-ID: <20160708134257.GB7732@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-2-git-send-email-vgoyal@redhat.com>
 <63906f0e-25cf-266b-6df9-18317f1e7c59@schaufler-ca.com>
 <20160707203329.GD11036@redhat.com>
 <2e7462e4-c84b-a6cf-74d3-35bf68048a61@schaufler-ca.com>
 <CAJfpegvQ8-fhdV-emzwhZX90k_Ray9imQTp0Cg5y+zRu3OAH3A@mail.gmail.com>
 <20160708124534.GA7732@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160708124534.GA7732@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>, David Howells <dhowells@redhat.com>, pmoore@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jul 08, 2016 at 08:45:34AM -0400, Vivek Goyal wrote:

[..]
> > >>> I don't much care for the way part of the credential manipulation
> > >>> is done in the caller and part is done the the security module.
> > >>> If the caller is going to restore the old state, the caller should
> > >>> save the old state.
> > 
> > Conversely if the SM is setting the state it should restore it.
> > This needs yet another hook, but that's fine, I think.
> > 
> > >> One advantage of current patches is that we switch to new creds only if
> > >> it is needed. For example, if there are no LSMs loaded,
> > >
> > > Point.
> > >
> > >>  then there is
> > >> no need to modify creds and make a switch to new creds.
> > >
> > > I'm not a fan of cred flipping. There are too many ways for it to go
> > > wrong. Consider interrupts. I assume you've ruled that out as a possibility
> > > in the caller, but I still think the practice is dangerous.
> > >
> > > I greatly prefer "create and set attributes" to "change cred, create and
> > > reset cred". I know that has it's own set of problems, including races
> > > and faking privilege.
> > 
> > Yeah, we've talked about this. The races can be eliminated by always
> > doing the create in a the temporary "workdir" area and atomically
> > renaming to the final destination after everything has been set up.
> > OTOH that has a performance impact that the cred flipping eliminates.
> > 
> > >> But if I start allocating new creds and save old state in caller, then
> > >> caller always has to do it (irrespective of the fact whether any LSM
> > >> modified the creds or not).
> > >
> > > It starts getting messy when I have two modules that want to
> > > change change the credential. Each module will have to check to
> > > see if a module called before it has allocated a new cred.
> > 
> > Doesn't seem to me too difficult: check if *credp == NULL and allocate
> > if so.  Can even invent a heper for this if needed.
> 
> Right. I like this approach. So cred allocation happens in LSM and
> switching to new creds and freeing of new creds is done by caller.
> 
> That way, if no new creds are allocated, then caller does not have to
> switch creds. Also all LSMs can work on single copy of newly allocated
> cred and modify it. Also all LSMs can check if creds have already been
> allocated otherwise allocate new one.

How about something like this. This should allow stacking modules nicely
at the same time if no LSMs are loaded or LSM decide not to allocate new
creds,there is no need to switch creds.


Subject: security, overlayfs: provide copy up security hook for unioned files

Provide a security hook to label new file correctly when a file is copied
up from lower layer to upper layer of a overlay/union mount.

This hook can prepare a new set of creds which are suitable for new file
creation during copy up. Caller will use new creds to create file and then
revert back to old creds and release new creds.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---

 fs/overlayfs/copy_up.c    |   18 ++++++++++++++++++
 include/linux/lsm_hooks.h |   11 +++++++++++
 include/linux/security.h  |    6 ++++++
 security/security.c       |    8 ++++++++
 security/selinux/hooks.c  |   21 +++++++++++++++++++++
 5 files changed, 64 insertions(+)

Index: rhvgoyal-linux/include/linux/lsm_hooks.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/lsm_hooks.h	2016-07-07 15:43:57.885498096 -0400
+++ rhvgoyal-linux/include/linux/lsm_hooks.h	2016-07-08 09:39:22.052676141 -0400
@@ -401,6 +401,15 @@
  *	@inode contains a pointer to the inode.
  *	@secid contains a pointer to the location where result will be saved.
  *	In case of failure, @secid will be set to zero.
+ * @inode_copy_up:
+ *	A file is about to be copied up from lower layer to upper layer of
+ *	overlay filesystem. Security module can prepare a set of new creds
+ *	and modify as need be and return new creds. Caller will switch to
+ *	new creds temporarily to create new file and release newly allocated
+ *	creds.
+ *	@src indicates the union dentry of file that is being copied up.
+ *	@new pointer to pointer to return newly allocated creds.
+ *	Returns 0 on success or a negative error code on error.
  *
  * Security hooks for file operations
  *
@@ -1425,6 +1434,7 @@ union security_list_options {
 	int (*inode_listsecurity)(struct inode *inode, char *buffer,
 					size_t buffer_size);
 	void (*inode_getsecid)(struct inode *inode, u32 *secid);
+	int (*inode_copy_up) (struct dentry *src, struct cred **new);
 
 	int (*file_permission)(struct file *file, int mask);
 	int (*file_alloc_security)(struct file *file);
@@ -1696,6 +1706,7 @@ struct security_hook_heads {
 	struct list_head inode_setsecurity;
 	struct list_head inode_listsecurity;
 	struct list_head inode_getsecid;
+	struct list_head inode_copy_up;
 	struct list_head file_permission;
 	struct list_head file_alloc_security;
 	struct list_head file_free_security;
Index: rhvgoyal-linux/include/linux/security.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/security.h	2016-07-07 15:43:57.885498096 -0400
+++ rhvgoyal-linux/include/linux/security.h	2016-07-08 09:39:22.052676141 -0400
@@ -282,6 +282,7 @@ int security_inode_getsecurity(struct in
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(struct inode *inode, u32 *secid);
+int security_inode_copy_up(struct dentry *src, struct cred **new);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -758,6 +759,11 @@ static inline void security_inode_getsec
 	*secid = 0;
 }
 
+static inline int security_inode_copy_up(struct dentry *src, struct cred **new)
+{
+	return 0;
+}
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
Index: rhvgoyal-linux/security/security.c
===================================================================
--- rhvgoyal-linux.orig/security/security.c	2016-07-07 15:43:57.885498096 -0400
+++ rhvgoyal-linux/security/security.c	2016-07-08 09:39:22.052676141 -0400
@@ -727,6 +727,12 @@ void security_inode_getsecid(struct inod
 	call_void_hook(inode_getsecid, inode, secid);
 }
 
+int security_inode_copy_up(struct dentry *src, struct cred **new)
+{
+	return call_int_hook(inode_copy_up, 0, src, new);
+}
+EXPORT_SYMBOL(security_inode_copy_up);
+
 int security_file_permission(struct file *file, int mask)
 {
 	int ret;
@@ -1663,6 +1669,8 @@ struct security_hook_heads security_hook
 		LIST_HEAD_INIT(security_hook_heads.inode_listsecurity),
 	.inode_getsecid =
 		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
+	.inode_copy_up =
+		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
 	.file_permission =
 		LIST_HEAD_INIT(security_hook_heads.file_permission),
 	.file_alloc_security =
Index: rhvgoyal-linux/fs/overlayfs/copy_up.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/copy_up.c	2016-07-07 15:43:57.885498096 -0400
+++ rhvgoyal-linux/fs/overlayfs/copy_up.c	2016-07-08 09:39:22.052676141 -0400
@@ -246,6 +246,8 @@ static int ovl_copy_up_locked(struct den
 	struct dentry *upper = NULL;
 	umode_t mode = stat->mode;
 	int err;
+	const struct cred *old_creds = NULL;
+	struct cred *new_creds = NULL;
 
 	newdentry = ovl_lookup_temp(workdir, dentry);
 	err = PTR_ERR(newdentry);
@@ -258,10 +260,26 @@ static int ovl_copy_up_locked(struct den
 	if (IS_ERR(upper))
 		goto out1;
 
+	err = security_inode_copy_up(dentry, &new_creds);
+	if (err < 0) {
+		if (new_creds)
+			put_cred(new_creds);
+		goto out2;
+	}
+
+	if (new_creds)
+		old_creds = override_creds(new_creds);
+
 	/* Can't properly set mode on creation because of the umask */
 	stat->mode &= S_IFMT;
 	err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
 	stat->mode = mode;
+
+	if (new_creds) {
+		revert_creds(old_creds);
+		put_cred(new_creds);
+	}
+
 	if (err)
 		goto out2;
 
Index: rhvgoyal-linux/security/selinux/hooks.c
===================================================================
--- rhvgoyal-linux.orig/security/selinux/hooks.c	2016-07-08 09:39:24.261676141 -0400
+++ rhvgoyal-linux/security/selinux/hooks.c	2016-07-08 09:39:32.651676141 -0400
@@ -3270,6 +3270,26 @@ static void selinux_inode_getsecid(struc
 	*secid = isec->sid;
 }
 
+static int selinux_inode_copy_up(struct dentry *src, struct cred **new)
+{
+	u32 sid;
+	struct task_security_struct *tsec;
+	struct cred *new_creds = *new;
+
+	if (new_creds == NULL) {
+		new_creds = prepare_creds();
+		if (!new_creds)
+			return -ENOMEM;
+	}
+
+	tsec = new_creds->security;
+	/* Get label from overlay inode and set it in create_sid */
+	selinux_inode_getsecid(d_inode(src), &sid);
+	tsec->create_sid = sid;
+	*new = new_creds;
+	return 0;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -6056,6 +6076,7 @@ static struct security_hook_list selinux
 	LSM_HOOK_INIT(inode_setsecurity, selinux_inode_setsecurity),
 	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
 	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
+	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
