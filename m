Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2A2C4321E
	for <linux-unionfs@archiver.kernel.org>; Wed, 17 Nov 2021 01:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1118063223
	for <linux-unionfs@archiver.kernel.org>; Wed, 17 Nov 2021 01:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhKQCBd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhKQCB3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Nov 2021 21:01:29 -0500
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D7BC061746
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Nov 2021 17:58:31 -0800 (PST)
Received: by mail-ua1-x949.google.com with SMTP id y21-20020ab025d5000000b002d3ca52eab5so569730uan.22
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Nov 2021 17:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=9mdj1xiFilRUGXvU812n33+uRIUP9YX8gtj4fBPRFjw=;
        b=W8pyuC1HxcZAjVNQCPNCuGecE0cLdPxdG7nuHrxoX9ik7vUw1GQP1Qt7xoBvDBARvH
         gKntoUZpyj7MbEvph3XSI+fRLv92alGE9XX0Ayq8JNgtxPFh6rmCUjDH5DIeGek1iblS
         HsIS+6KhO+iB0ujz7bu/jXoJeKwBQOLwZmgAyQCT4BwA3YczvovBxT8CiVIGkfp0bC2Y
         EpdcqnErSezyZX5hoPOWiv9uej5pYBkgJV1UmC4kVQDZsExCfU1fcctOnJxxx67WDiQg
         NakanBbHGP4OBoPCwUycj4zFqp1DDtesp7nqK6NMpUF1qLKxQGekG7OpBvAkQsA62N7u
         Gqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:cc;
        bh=9mdj1xiFilRUGXvU812n33+uRIUP9YX8gtj4fBPRFjw=;
        b=TVX3svkU8WRlOcScCSeZQ8IeT+vUv4CW5cHQsAB2RIOfYEKmwlM+zvum+iJ4/EpE2N
         MhmwhXFhik6sElHqIiwmbIJn+qihUhM5RfQoJHYkADNkpnmnfU5+MLiCbiMxPJJn2ZgC
         AdPP4zHOW1iFItW/iRC9uM/GxB/9H8L+qax38a/xgUNJot9d9DB+VHwGVLiz0B7XrIl+
         IgCUk6kfDNfKG5rhYpJB2Dn1PxvSxyolZJWHlKReae0cyiq2vbob8Oa678bUWmY3LGeA
         fAvsSGXRtntu5n6BYaUjlq0JYDBcyU4/jN1DgpdDJQiWuYlTdKhVBwfdjAh/Ux1qdJEz
         hAQg==
X-Gm-Message-State: AOAM530kcLaYfxqSj9MM2PcmOVuXeni8NieCyExk4oV8k/ZIxddMJ/y9
        susUCz9nhuTh6AEAFd1puVtM5irO+Gb/
X-Google-Smtp-Source: ABdhPJzOPEJhhk8qQLNAKND//YRmpRQ5IOvlvzPpDzsncg3WQZRB04JIW7X2cz5bx2lTtV30v7/5bmKQKyTX
X-Received: from dvandertop.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2862])
 (user=dvander job=sendgmr) by 2002:a05:6122:8d6:: with SMTP id
 22mr82551467vkg.21.1637114310621; Tue, 16 Nov 2021 17:58:30 -0800 (PST)
Date:   Wed, 17 Nov 2021 01:58:04 +0000
In-Reply-To: <20211117015806.2192263-1-dvander@google.com>
Message-Id: <20211117015806.2192263-3-dvander@google.com>
Mime-Version: 1.0
References: <20211117015806.2192263-1-dvander@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v19 2/4] overlayfs: handle XATTR_NOSECURITY flag for get xattr method
From:   David Anderson <dvander@google.com>
Cc:     David Anderson <dvander@google.com>,
        Mark Salyzyn <salyzyn@android.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com,
        Miklos Szeredi <miklos@szeredi.hu>,
        Jonathan Corbet <corbet@lwn.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Amir Goldstein <amir73il@gmail.com>, linux-doc@vger.kernel.org,
        selinux@vger.kernel.org, paulmoore@microsoft.com,
        Luca.Boccassi@microsoft.com
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Because of the overlayfs getxattr recursion, the incoming inode fails
to update the selinux sid resulting in avc denials being reported
against a target context of u:object_r:unlabeled:s0.

Solution is to respond to the XATTR_NOSECURITY flag in get xattr
method that calls the __vfs_getxattr handler instead so that the
context can be read in, rather than being denied with an -EACCES
when vfs_getxattr handler is called.

For the use case where access is to be blocked by the security layer.

The path then would be security(dentry) ->
__vfs_getxattr({dentry...XATTR_NOSECURITY}) ->
handler->get({dentry...XATTR_NOSECURITY}) ->
__vfs_getxattr({realdentry...XATTR_NOSECURITY}) ->
lower_handler->get({realdentry...XATTR_NOSECURITY}) which
would report back through the chain data and success as expected,
the logging security layer at the top would have the data to
determine the access permissions and report back to the logs and
the caller that the target context was blocked.

For selinux this would solve the cosmetic issue of the selinux log
and allow audit2allow to correctly report the rule needed to address
the access problem.

Check impure, opaque, origin & meta xattr with no sepolicy audit
(using __vfs_getxattr) since these operations are internal to
overlayfs operations and do not disclose any data.  This became
an issue for credential override off since sys_admin would have
been required by the caller; whereas would have been inherently
present for the creator since it performed the mount.

This is a change in operations since we do not check in the new
ovl_do_getxattr function if the credential override is off or not.
Reasoning is that the sepolicy check is unnecessary overhead,
especially since the check can be expensive.

Because for override credentials off, this affects _everyone_ that
underneath performs private xattr calls without the appropriate
sepolicy permissions and sys_admin capability.  Providing blanket
support for sys_admin would be bad for all possible callers.

For the override credentials on, this will affect only the mounter,
should it lack sepolicy permissions. Not considered a security
problem since mounting by definition has sys_admin capabilities,
but sepolicy contexts would still need to be crafted.

It should be noted that there is precedence, __vfs_getxattr is used
in other filesystems for their own internal trusted xattr management.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Signed-off-by: David Anderson <dvander@google.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-team@android.com
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-doc@vger.kernel.org
Cc: selinux@vger.kernel.org
Cc: paulmoore@microsoft.com
Cc: Luca.Boccassi@microsoft.com

v19 - rebase

v18 - correct inode argument to __vfs_getxattr

v17 - rebase and add inode argument to __vfs_getxattr

v16 - rebase and merge internal getxattr operations patch

v15 - revert to v13 because xattr_gs_args rejected.

v14 - rebase to use xattr_gs_args.

v13 - rebase to use __vfs_getxattr flags option.

v12 - Added back to patch series as get xattr with flag option.

v11 - Squashed out of patch series and replaced with per-thread flag
      solution.

v10 - Added to patch series as __get xattr method.
---
 fs/overlayfs/inode.c     | 5 +++--
 fs/overlayfs/overlayfs.h | 6 ++++--
 fs/overlayfs/super.c     | 4 ++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1f36158c7dbe..49bfa33bb682 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -386,7 +386,7 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 }
 
 int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
-		  void *value, size_t size)
+		  void *value, size_t size, int flags)
 {
 	ssize_t res;
 	const struct cred *old_cred;
@@ -394,7 +394,8 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		ovl_i_dentry_upper(inode) ?: ovl_dentry_lower(dentry);
 
 	old_cred = ovl_override_creds(dentry->d_sb);
-	res = vfs_getxattr(&init_user_ns, realdentry, name, value, size);
+	res = __vfs_getxattr(&init_user_ns, realdentry, d_inode(realdentry),
+			     name, value, size, flags);
 	revert_creds(old_cred);
 	return res;
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2cd5741c873b..3fcd62e72aad 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -187,7 +187,9 @@ static inline ssize_t ovl_do_getxattr(struct ovl_fs *ofs, struct dentry *dentry,
 				      size_t size)
 {
 	const char *name = ovl_xattr(ofs, ox);
-	int err = vfs_getxattr(&init_user_ns, dentry, name, value, size);
+	struct inode *ip = d_inode(dentry);
+	int err = __vfs_getxattr(&init_user_ns, dentry, ip, name, value, size,
+				 XATTR_NOSECURITY);
 	int len = (value && err > 0) ? err : 0;
 
 	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) = %i\n",
@@ -496,7 +498,7 @@ int ovl_permission(struct user_namespace *mnt_userns, struct inode *inode,
 int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 		  const void *value, size_t size, int flags);
 int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
-		  void *value, size_t size);
+		  void *value, size_t size, int flags);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu);
 int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 359aa5772cb7..973644af1288 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1006,7 +1006,7 @@ ovl_posix_acl_xattr_get(const struct xattr_handler *handler,
 			struct dentry *dentry, struct inode *inode,
 			const char *name, void *buffer, size_t size, int flags)
 {
-	return ovl_xattr_get(dentry, inode, handler->name, buffer, size);
+	return ovl_xattr_get(dentry, inode, handler->name, buffer, size, flags);
 }
 
 static int __maybe_unused
@@ -1087,7 +1087,7 @@ static int ovl_other_xattr_get(const struct xattr_handler *handler,
 			       const char *name, void *buffer, size_t size,
 			       int flags)
 {
-	return ovl_xattr_get(dentry, inode, name, buffer, size);
+	return ovl_xattr_get(dentry, inode, name, buffer, size, flags);
 }
 
 static int ovl_other_xattr_set(const struct xattr_handler *handler,
-- 
2.34.0.rc1.387.gb447b232ab-goog

