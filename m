Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v2 00/13] client-side support for "inter" SSC copy
Date: Wed, 24 Oct 2018 15:58:23 -0400
Message-Id: <20181024195837.35532-1-olga.kornievskaia@gmail.com>
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

v2:
-- VFS changes are to remove VFS check for same copy_file_range
functions before calling it. Instead add the appropriate checks
to the existing implementors of the copy_file_range.
-- Changed the check for the "intra" vs "inter" based on the
serverowner instead of the IPs and merged it with the 1st caller
patch
-- Addressed Anna's comments to ifdef the nfs42_copy_notify in
nfs42.h to make for proper compiling
-- Removed a leftover dprintk from the nfs42_ssc_open

Olga Kornievskaia (13):
  VFS permit cross device vfs_copy_file_range
  CIFS: add cross-device check for copy_file_range
  OverlayFS: add cross-device check for copy_file_range
  NFS: add cross file system check for copy_file_range
  VFS: Don't copy beyond the end of the file
  NFS NFSD defining nl4_servers structure needed by both
  NFS add COPY_NOTIFY operation
  NFS add ca_source_server<> to COPY
  NFS also send OFFLOAD_CANCEL to source server
  NFS inter ssc open
  NFS skip recovery of copy open on dest server
  NFS for "inter" copy treat ESTALE as ENOTSUPP
  NFS COPY handle ERR_OFFLOAD_DENIED

 Documentation/filesystems/porting |   7 ++
 Documentation/filesystems/vfs.txt |   6 +-
 fs/cifs/cifsfs.c                  |   2 +
 fs/nfs/nfs42.h                    |  15 ++-
 fs/nfs/nfs42proc.c                | 129 ++++++++++++++++++++++---
 fs/nfs/nfs42xdr.c                 | 193 +++++++++++++++++++++++++++++++++++++-
 fs/nfs/nfs4_fs.h                  |  10 ++
 fs/nfs/nfs4client.c               |   2 +-
 fs/nfs/nfs4file.c                 | 122 +++++++++++++++++++++++-
 fs/nfs/nfs4proc.c                 |   6 +-
 fs/nfs/nfs4state.c                |  14 +++
 fs/nfs/nfs4xdr.c                  |   1 +
 fs/overlayfs/file.c               |   3 +
 fs/read_write.c                   |  12 +--
 include/linux/nfs4.h              |  25 +++++
 include/linux/nfs_fs_sb.h         |   1 +
 include/linux/nfs_xdr.h           |  17 ++++
 17 files changed, 539 insertions(+), 26 deletions(-)

-- 
1.8.3.1
