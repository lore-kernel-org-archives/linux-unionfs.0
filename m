Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v5 00/12] client-side support for "inter" SSC copy
Date: Mon, 29 Oct 2018 13:40:46 -0400
Message-Id: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

This patch series adds client-side support for doing NFSv4.2 "inter"
copy offload between different NFS servers.

In case of the "inter" SSC copy files reside on different servers and
thus under different superblocks and require that VFS removes the
restriction that src and dst files must be on the same superblock.

NFS's copy_file_range() determines if the copy is "intra" or "inter"
and for "inter" it sends the COPY_NOTIFY to the source server. Then,
it would send of an asynchronous COPY to the destination server. If
an application cancels an in-flight COPY, OFFLOAD_CANCEL is sent to
both of the servers.

This patch series also include necessary client-side additions that
are performed by the destination server. The server needs an NFS
open that represents a source file without doing an actual open.
Two function nfs42_ssc_open/nfs42_ssc_close() are introduced to
accomplish it that make use of the VFS's alloc_file_pseudo() to
represent an open.

Also this particular open is marked (NFS_SVC_SSC_COPY_STATE) so
that if the destination server ever to receive stateid errors on
this stateid, it knows not to initiate state recovery (in case
when source server reboots). The recovery must be done by the
client and a new copy must be initiated. Therefore, in this case
the recovery needs to fail with EIO.

v5:
-- in the VFS patches: 1. addressed use of file_inode, indentation,
2. Separated the cross-device checking relocation and ability to
fallback to do_splice_direct() into 2 patches. This NFS series has
only a requirement on the 1st VFS patch. 2nd VFS I propose as an
improvement but if it's deemed unnecessary, I'm OK with dropping
(I would need to change the man-page patch accordingly).
-- moved source offset check into NFS
-- reformatted NFS cross filesystem check to look better
-- I have added "Reviewed-by" to the commits but if I missed something
it was unintentional so please let me know.

Olga Kornievskaia (12):
  VFS: move cross device copy_file_range() check into filesystems
  VFS: generic cross-device copy_file_range() support for all
    filesystems
  NFS: validity check for source offset in copy_file_range
  NFS NFSD: defining nl4_servers structure needed by both
  NFS: add COPY_NOTIFY operation
  NFS: add ca_source_server<> to COPY
  NFS: also send OFFLOAD_CANCEL to source server
  NFS: inter ssc open
  NFS: skip recovery of copy open on dest server
  NFS: for "inter" copy treat ESTALE as ENOTSUPP
  NFS: COPY handle ERR_OFFLOAD_DENIED
  NFS: replace cross device check in copy_file_range

 Documentation/filesystems/porting |   7 ++
 fs/cifs/cifsfs.c                  |   3 +
 fs/nfs/nfs42.h                    |  15 ++-
 fs/nfs/nfs42proc.c                | 129 ++++++++++++++++++++++---
 fs/nfs/nfs42xdr.c                 | 193 +++++++++++++++++++++++++++++++++++++-
 fs/nfs/nfs4_fs.h                  |  10 ++
 fs/nfs/nfs4client.c               |   2 +-
 fs/nfs/nfs4file.c                 | 127 ++++++++++++++++++++++++-
 fs/nfs/nfs4proc.c                 |   6 +-
 fs/nfs/nfs4state.c                |  14 +++
 fs/nfs/nfs4xdr.c                  |   1 +
 fs/overlayfs/file.c               |   3 +
 fs/read_write.c                   |   9 +-
 include/linux/nfs4.h              |  25 +++++
 include/linux/nfs_fs_sb.h         |   1 +
 include/linux/nfs_xdr.h           |  17 ++++
 16 files changed, 537 insertions(+), 25 deletions(-)

-- 
1.8.3.1
