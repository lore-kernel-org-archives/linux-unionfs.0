From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/5][RFC] Overlayfs SELinux Support
Date: Tue,  5 Jul 2016 11:50:49 -0400
Message-ID: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi,

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

Apart from hooks, also changed overlay code to not do getxattr checks on
underlying inode so that overlay inode selinux label does not fail
initializaiton.
 
Any feedback is welcome.

Thanks
Vivek

Vivek Goyal (5):
  security, overlayfs: provide copy up security hook for unioned files
  security,overlayfs: Provide security hook for copy up of xattrs for
    overlay file
  selinux: Pass security pointer to determine_inode_label()
  overlayfs: Correctly label newly created file over whiteout
  overlayfs: Use vfs_getxattr_noperm() for real inode

 fs/overlayfs/copy_up.c    | 16 ++++++++++
 fs/overlayfs/dir.c        | 10 ++++++
 fs/overlayfs/inode.c      |  7 +----
 fs/xattr.c                | 28 +++++++++++------
 include/linux/lsm_hooks.h | 41 ++++++++++++++++++++++++
 include/linux/security.h  | 28 +++++++++++++++++
 include/linux/xattr.h     |  1 +
 security/security.c       | 28 +++++++++++++++++
 security/selinux/hooks.c  | 80 ++++++++++++++++++++++++++++++++++++++++++-----
 9 files changed, 216 insertions(+), 23 deletions(-)

-- 
2.7.4
