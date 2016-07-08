From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/7][V2] Overlayfs SELinux Support
Date: Fri,  8 Jul 2016 12:19:35 -0400
Message-ID: <1467994782-26474-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbcGHQUD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 8 Jul 2016 12:20:03 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, sds@tycho.nsa.gov, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org

Hi,

Please find attached the V2 of patches. I have take care of feedback from
round 1.

Following are the changes since V1.

- Broke down patches as mentioned by paul moore.

- Dropped last patch of the series where we skipped permission checks in
  ovl_getxattr(). Now there should not be any info leak. This means in
  some uncommon configurations (non-context mount where mounter can't do
  getattr on underlying file), overlay inode selinux label will be
  labeled unlabeled_t and there will be warning on console about this
  every time it happens.

- Modified security_inode_copy_up() and security_inode_copy_up_xattr() as
  mentioned by Casey.

Original description of patches follows.

Following are RFC patches to support SELinux with overlayfs. I started
with David Howells's latest posting on this topic and started modifying
patches. These patches apply on top of overlayfs-next branch of miklos
vfs git tree.

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

These patches can be pulled from my branch too.

https://github.com/rhvgoyal/linux/commits/overlayfs-selinux-mounter-next

Thanks to Dan Walsh, Stephen Smalley and Miklos Szeredi for numerous
conversation and ideas in helping figuring out what one reasonable
implementation might look like.

Dan Walsh has been writing tests for selinux overlayfs in selinux-testsuite.
These patches pass those tests except one. I think that test/policy need
to be fixed. 

https://github.com/rhatdan/selinux-testsuite/commits/master

Posting these patches for review and comments.

These patches introduce 3 new security hooks.

- security_inode_copy_up(), is called when a file is copied up. This hook
  prepares a new set of cred which is used for copy up operation. And
  new set of creds are prepared so that ->create_sid can be set appropriately
  and newly created file is labeled properly. 

  When a file is copied up, label of lower file is retained except for the
  case of context= mount where new file gets the label from context= option.

- security_inode_copy_up_xattr(), is called when xattrs of a file are
  being copied up. Before this we already called security_inode_copy_up()
  and created new file and copied up data. That means file already got
  labeled properly and there is no need to take SELINUX xattr of lower
  file and overwrite the upper file xattr. So this hook is used to avoid
  copying up of SELINUX xattr.

- dentry_create_files_as(), is called when a new file is about to be created.
  This hook determines what the label of the file should be if task had
  created that file in upper/ and sets create_sid accordingly in the passed
  in creds.

  Normal transition rules don't work for the case of context mounts as
  underlying file system is not aware of context option which only overlay
  layer is aware of. For non-context mounts, creation can happen in work/
  dir first and then file might be renamed into upper/, and it might get
  label based on work/ dir. So this hooks helps avoiding all these issues.

  When a new file is created in upper/, it gets its label based on transition
  rules. For the case of context mount, it gets the label from context=
  option.

Any feedback is welcome.

Thanks
Vivek
 
Vivek Goyal (7):
  security, overlayfs: provide copy up security hook for unioned files
  selinux: Implementation for inode_copy_up() hook
  security,overlayfs: Provide security hook for copy up of xattrs for
    overlay file
  selinux: Implementation for inode_copy_up_xattr() hook
  selinux: Pass security pointer to determine_inode_label()
  security, overlayfs: Provide hook to correctly label newly created
    files
  selinux: Implement dentry_create_files_as() hook

 fs/overlayfs/copy_up.c    | 25 +++++++++++++++
 fs/overlayfs/dir.c        | 10 ++++++
 include/linux/lsm_hooks.h | 36 ++++++++++++++++++++++
 include/linux/security.h  | 24 +++++++++++++++
 security/security.c       | 27 ++++++++++++++++
 security/selinux/hooks.c  | 78 +++++++++++++++++++++++++++++++++++++++++------
 6 files changed, 191 insertions(+), 9 deletions(-)

-- 
2.7.4
