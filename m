From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/9][V3] Overlayfs SELinux Support
Date: Wed, 13 Jul 2016 10:44:46 -0400
Message-ID: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu, sds@tycho.nsa.gov, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi All,

Please find attached the V3 of patches. Changes since V2 are as follows.

- Fixed the build issue with CONFIG_SECURITY=n.

- Dan Walsh was writing more tests for selinux-testsuite and noted couple
  of issues. I have fixed those issues and added two more patches in series.

  1. We are resetting MAY_WRITE check for lower inode assuming file will
     be coiped up. But this is not true for special_file() as these files
     are not copied up. So checks should not be reset in case of special
     file.

  2. We are resetting MAY_WRITE check for lower inode assuming file will
     be copied up. But this also should mean that mounter has permission
     to MAY_READ lower file for copy up to succeed. So add MAY_READ
     check while resetting MAY_WRITE.

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
These patches pass those tests now

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


Vivek Goyal (9):
  security, overlayfs: provide copy up security hook for unioned files
  selinux: Implementation for inode_copy_up() hook
  security,overlayfs: Provide security hook for copy up of xattrs for
    overlay file
  selinux: Implementation for inode_copy_up_xattr() hook
  selinux: Pass security pointer to determine_inode_label()
  security, overlayfs: Provide hook to correctly label newly created
    files
  selinux: Implement dentry_create_files_as() hook
  overlayfs: Dilute permission checks on lower only if not special file
  overlayfs: Append MAY_READ when diluting write checks

 fs/overlayfs/copy_up.c    | 25 +++++++++++++++
 fs/overlayfs/dir.c        | 10 ++++++
 fs/overlayfs/inode.c      |  9 ++++--
 include/linux/lsm_hooks.h | 36 ++++++++++++++++++++++
 include/linux/security.h  | 24 +++++++++++++++
 security/security.c       | 27 ++++++++++++++++
 security/selinux/hooks.c  | 78 +++++++++++++++++++++++++++++++++++++++++------
 7 files changed, 198 insertions(+), 11 deletions(-)

-- 
2.7.4
