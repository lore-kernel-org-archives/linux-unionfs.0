Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F8C31F982
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 18:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778955811; cv=pass; b=Ek7QzLuv82yzuLBAB86lwnNrkRiJLYEtoEayv8wfWNXhLjaAEhiODSKyVLS5j1uZKS7dDEzJHZs0eI8tEPt6iBQNSjDAZ2+xcUBF0oAWouMbT1kZ5cvmWQmSaoFNbRiRSClvF3Urjt0QBNb0IKZg6TA7UyRlioz9fOPO3fK2pt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778955811; c=relaxed/simple;
	bh=dlaZaMjYGHSBvvJtkcgM7zyhaOtypavM7tG2mdOr0h4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MjQBC8un8K2vnnaHvSvvh2t34SQ57JZmpXq7GtPzNXlU+VErgqQBeRWG1dhnszIiUlsmUN+i4knOUu0UmJGvuZanhaadE/8EHX8b0x0rchrADapBno601u4hiPhcYcm2DZbUAKpKwXJdl0TYd6mO7Nx42SnknrTMEZC2WsrjxjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nuFaAO/E; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nuFaAO/E"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67bce1840f1so1722478a12.3
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 11:23:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778955808; cv=none;
        d=google.com; s=arc-20240605;
        b=I7gU0M4PW6K0b7nGJu2fKPLqi0/fl4O2Gez2c92qwH0WNgcySzZrFmCgAfODPD4rJt
         ZUdr1GMd4mfuIn7PK2e3Wq/4VCgv3mgIhQbqyTJtN7DSEloiN85Ap+5ApWkXG9aJOmFO
         dGmrGzTfid1N9y14cMYW2keFFAFG9kDqLkYqjnZ1yXagmYc7fIkJk5E0SUqcOBhY+6Yj
         +1fxe+sIDT3aN4Te0nKTZEI6bTvNNLkZ7KP0LIDQ0fT1+XgdT6/w6s2OC2UDotGq7D05
         dH652EzYPrnZa0qsvQqkBz4ax8j/WDCdpu3BOoes1zwpL1PSESy3cewZ6D8BHCWFgSxu
         INCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=It+QV09MsE8M5sBWkIqGfEYUQhdYrbZbFM1gOqRmevs=;
        fh=6zF016QXoVvzIuEa9EC3s5eg4Frj2NIgXq4HFIvoEDU=;
        b=V+QV2MkqQMAaQ6C1I3lpjGuEKtFP86s6hnurCx7rXcBaONeWI7BuU+YUTubAIL3zUC
         OOnKVS2kiTfIX2yGEHPRC/qXKEWPgXWoyaoLX1E/UomV3DeELdo+3izfPpT29213O7qL
         lj5zaod5YiV3SRkp4NvyOctnmNoWRJ9hGyLsoP/1jE2oIJ/0u8szpRApmtmT4gCyoEmd
         MREW/MAt4SuL/qfV8StYBi1UL9TuOJzaJAsGMWcfsZ1Igs08U6aH81PqxRpo4R/dCQln
         M7TAnRx8Q2dhML09sYGQDSCpfbUbHZKSiss5xQw+LmtRnl3KiWpYHOySkKEFvFKhjBNu
         FS5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778955808; x=1779560608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=It+QV09MsE8M5sBWkIqGfEYUQhdYrbZbFM1gOqRmevs=;
        b=nuFaAO/Eo9eoUF1BeMJdTDjvTvWSkY7ZfhfdIImThBmzf4RltDJ7YAvqxLZVMRFGOF
         poo/OH9aGvUzRRTF4qAy+ygXej6NBs1aKLOXYi+toEzmtPnUpywrQ4ouzyd+vKC1p1Kz
         qinn05R1DkeUW0iARsZlCqeUmvLfTqzWVNSpc9ck6Z0YozgQQy6Z/DWjUgfmFxKhT0pL
         fRLlfbIj2wvefnLK0Jh8b9/OA1dMkxCMXBG4lrMlNzHsrQREOfa23nSl1QMX92wDKWVz
         PZI2feP8LsXj89/jS+svXo7tu9AmaUQpdSSMF+cbDDE3OXbMR5n3C7wcanztfwRzwEqN
         Ky1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778955808; x=1779560608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=It+QV09MsE8M5sBWkIqGfEYUQhdYrbZbFM1gOqRmevs=;
        b=k/jsL4qX0eeLBmMd2FPkuEAyJtRstTYZDvGLZUP2KMaePDjRrL/rYAX2oYwk1/lRYW
         n6rNF8AG9M6yN/SCJW+/c7RgQayyAM7yzo/DdL98aFm6BFnyzYMBjlXDjSBXGcO4aZmf
         1F99c7atuAr/G+jLuxzW2MM6ezXsRLq/abgLHKfR/JCj0BqXUQJ9/v7lhgfmZxQnByG3
         txkdssDlA5bduPkMyJLo9XmtngoExkrWtoyXwQl3VJD8o/xNjHxlh8YKokp8vSnsIjUn
         z7x9722R5Qyai1yhWsGgfDIowX/ONB01+p/KOg6ZbVZqJ8fRkdWzzj7Bj66odq8APHFD
         1uJQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WrQvsAA8RgdBWT8UBrerbSrEIu80LuqjqHHi/rjq/mcv1MWH8m5lGHVPE9RXFANvyU7YNEdH4TN8KbhSY@vger.kernel.org
X-Gm-Message-State: AOJu0YzJwStA6htc22gFz/nTzwQaRbxthOltzaZmW44r0Oo6/qwgMwMI
	cRHkN63pNRuSircFPBs4IVt1fAG3XWjz/qNkVNDBKBoNfZyYZ5CN8pj9p6YM6+J0gXkFkDTYqFK
	9HnaXLbPHmxVNv+VlVEb03s83MN4v1tW5mbeREUc=
X-Gm-Gg: Acq92OHCF7rhgRuDIniVq9yeAfg7LZ1xY/dhfo5BesCfI71WLHi3RrJhf8/EGvxsAx7
	jpyzMrLtasXE9JWsEvzKzH6W2eafYlqez9AnLj/FbEcw5xTSNLGR26F9M1bmX0Foq1dkMkuWGfQ
	sa2zsOGvX2ULR7IjbekTd9IQIOhfyMxV7MxY86e8MQ3TYRdHTCqHNeurjQLtMy5tUbaeXB956oc
	w8M+GXcwyDUvXoQvES8V9dzNrQEsIypwnu1jXcgWfOQjQAdbU3c9oEqV+4072hnyyNhANuI2M8I
	ns5b/YHqUk+kgbdBVBldYJrW5OX46n7/AR6fxkIapA==
X-Received: by 2002:a17:907:c714:b0:bd0:7949:a931 with SMTP id
 a640c23a62f3a-bd517960723mr486726966b.27.1778955807457; Sat, 16 May 2026
 11:23:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-22-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-22-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 20:23:15 +0200
X-Gm-Features: AVHnY4KEqFF-tmSJ5Q4xZUuGfYOMSimRUfky7X86gDJA0PguS3v4tIo1QnoOx5g
Message-ID: <CAOQ4uxjg4ULPKC7K9PabXPOOT7J5i2EOnzsv5ABNP3R5Y9jdYQ@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] docs: fuse: document extended passthrough (FUSE_PASSTHROUGH_INO)
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:53=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add section about extended passthrough (FUSE_PASSTHROUGH_INO) mode.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  .../filesystems/fuse/fuse-passthrough.rst     | 126 ++++++++++++++++++
>  1 file changed, 126 insertions(+)
>
> diff --git a/Documentation/filesystems/fuse/fuse-passthrough.rst b/Docume=
ntation/filesystems/fuse/fuse-passthrough.rst
> index 2b0e7c2da54a..751d27c6fc5c 100644
> --- a/Documentation/filesystems/fuse/fuse-passthrough.rst
> +++ b/Documentation/filesystems/fuse/fuse-passthrough.rst
> @@ -25,6 +25,11 @@ operations.
>  Currently, passthrough is supported for operations like ``read(2)``/``wr=
ite(2)``
>  (via ``read_iter``/``write_iter``), ``splice(2)``, and ``mmap(2)``.
>
> +With the extended ``FUSE_PASSTHROUGH_INO`` mode, passthrough is also sup=
ported
> +for inode operations (getattr, setattr) and directory operations (readdi=
r).
> +In this mode, a backing file is attached to a fuse inode for its entire
> +lifetime.
> +
>  Enabling Passthrough
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> @@ -46,6 +51,127 @@ To use FUSE passthrough:
>       the ``backing_id`` to release the kernel's reference to the backing=
 file
>       when it's no longer needed for passthrough setups.
>
> +Extended Passthrough (FUSE_PASSTHROUGH_INO)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +``FUSE_PASSTHROUGH_INO`` is a stricter variant of ``FUSE_PASSTHROUGH`` i=
n
> +which the backing file inode number must match the fuse inode number, en=
forcing
> +a one-to-one mapping. The kernel offers this flag during ``FUSE_INIT`` i=
f
> +``CONFIG_FUSE_PASSTHROUGH`` is enabled and the architecture has 64-bit
> +``ino_t``. The daemon accepts by returning it back in the init reply.

IIUC, ino_t is now always 64-bit.

> +
> +Enabling Extended Passthrough
> +-----------------------------
> +
> +To use extended passthrough:
> +
> +  1. Follow steps 1-2 from `Enabling Passthrough`_ above. The daemon mus=
t
> +     also negotiate the ``FUSE_PASSTHROUGH_INO`` capability during
> +     ``FUSE_INIT``.
> +  2. When registering a backing file via ``FUSE_DEV_IOC_BACKING_OPEN``, =
set
> +     the ``ops_mask`` field in ``struct fuse_backing_map`` to declare wh=
ich
> +     operations should be passed through. At minimum,
> +     ``FUSE_PASSTHROUGH_OP_GETATTR`` must be set for any inode-level
> +     passthrough.
> +  3. When handling a ``LOOKUP``, ``CREATE``, ``MKNOD``, ``MKDIR``,
> +     ``SYMLINK``, or ``LINK`` request, the daemon responds with a
> +     ``fuse_entry2_out`` (instead of ``fuse_entry_out``). To enable
> +     passthrough on the inode, set ``backing_id`` to the id returned by
> +     ``FUSE_DEV_IOC_BACKING_OPEN``. Set ``backing_id`` to 0 for inodes
> +     that should not use passthrough. The ``nodeid`` in the response mus=
t
> +     be the backing file's inode number (``i_ino``). If they don't match=
,
> +     the kernel rejects the passthrough setup with ``-EIO``.
> +  4. When handling an ``OPEN`` request for a FUSE file, the daemon
> +     replies with the ``FOPEN_PASSTHROUGH`` flag set in
> +     ``fuse_open_out::open_flags`` and provides the corresponding ``back=
ing_id``
> +     in ``fuse_open_out::backing_id`` or leaves ``fuse_open_out::backing=
_id``
> +     blank. If the daemon would like to opt out of passthrough when the =
inode
> +     is already in passthrough mode, it may additionally set
> +     ``FOPEN_DIRECT_IO``, which will forward read/write operations direc=
tly to
> +     the daemon.
> +  5. The FUSE daemon should eventually call ``FUSE_DEV_IOC_BACKING_CLOSE=
`` with
> +     the ``backing_id`` to release the kernel's reference to the backing=
 file
> +     when it's no longer needed for passthrough setups.
> +
> +Passthrough Operations Mask
> +---------------------------
> +
> +When registering a backing file via ``FUSE_DEV_IOC_BACKING_OPEN``, the d=
aemon
> +sets ``ops_mask`` in ``struct fuse_backing_map`` to declare which operat=
ions
> +should be passed through::
> +
> +    FUSE_PASSTHROUGH_OP_READ
> +    FUSE_PASSTHROUGH_OP_WRITE
> +    FUSE_PASSTHROUGH_OP_READDIR
> +    FUSE_PASSTHROUGH_OP_GETATTR
> +    FUSE_PASSTHROUGH_OP_SETATTR
> +
> +Operations fall into two categories, which can be combined:
> +
> +**Inode operations** (getattr, setattr): Activated on lookup when the da=
emon
> +returns a ``backing_id`` in the ``fuse_entry2_out`` response. The backin=
g
> +file reference persists for the lifetime of the fuse inode. Getattr is t=
he
> +minimum required inode operation.
> +
> +**File operations** (read, write, readdir): Require the file to be opene=
d with
> +``FOPEN_PASSTHROUGH`` in the daemon's open response. Read and write can =
be set
> +independently for partial passthrough. If only one direction is set, the=
 other
> +falls back to direct IO and mmap is disabled.
> +
> +Extended Entry Reply
> +--------------------
> +
> +When ``FUSE_PASSTHROUGH_INO`` is negotiated, the kernel uses
> +``fuse_entry2_out`` instead of ``fuse_entry_out`` for entry responses.
> +This struct carries a ``backing_id`` and ``fuse_statx`` attributes inste=
ad
> +of ``fuse_attr``.
> +
> +When ``backing_id > 0``, the kernel associates the inode with the backin=
g file
> +for passthrough inode operations. Statx attributes are not cached becaus=
e
> +passthrough getattr fetches them directly from the backing inode.
> +
> +When ``backing_id =3D=3D 0`` (no passthrough), the statx attributes from=
 the reply
> +are cached normally.
> +
> +A negative ``backing_id`` is treated as an error. The kernel sends
> +``FUSE_FORGET`` for the returned nodeid and fails the operation.
> +
> +IO Mode State Machine
> +---------------------
> +
> +The ``iocachectr`` field in ``struct fuse_inode`` prevents conflicting a=
ccess
> +modes on the same inode (page-cache I/O and passthrough I/O cannot coexi=
st)::
> +
> +    iocachectr > 0    Cached mode
> +    iocachectr =3D=3D 0   Idle. No files open, no passthrough

More accurately, no open files in caching or passthough.
files open with FOPEN_DIRECT_IO may exist and they
do not deny entering either caching or passthrough iomode.

> +    iocachectr < 0    Uncached/passthrough mode
> +
> +Each open file in passthrough mode holds one reference (``iocachectr--``=
).
> +The inode-level passthrough setup holds one additional long-lived refere=
nce
> +if the backing has inode ops (getattr/setattr). This long-lived referenc=
e is
> +released on inode eviction.
> +
> +Cached mode and passthrough mode are mutually exclusive. Attempting eith=
er
> +while the other is active returns ``-ETXTBSY``.
> +
> +For directories, the same mechanism arbitrates between cached readdir
> +(``FOPEN_CACHE_DIR``) and passthrough readdir. A directory opened withou=
t
> +``FOPEN_CACHE_DIR`` and without ``FOPEN_PASSTHROUGH`` is treated as dire=
ct I/O
> +and does not affect io mode.
> +
> +Things to note
> +--------------
> +
> +- ``FUSE_PASSTHROUGH_INO`` requires 64-bit ``ino_t``.

Not relevant I think.

> +- Readdirplus does not set up inode passthrough. Inodes created via read=
dirplus
> +  use normal FUSE operations until a fresh lookup occurs.
> +- An inode's backing association is set once and cannot be changed.
> +- Passthrough and cached I/O cannot coexist on the same inode.
> +- If any inode operations are passed through, this means all opened file=
s need
> +  to set the ``FOPEN_PASSTHROUGH`` flag in the open response, even if re=
ads
> +  and writes are not passed through. If reads and writes are not passed
> +  through, they will go directly to the daemon.

I had not considered this.
Setting OP_GETATTR/SETATTR in LOOKUP without any OP_RW bits
and then requiring that the server open files with FOPEN_PASSTHROUGH
with the backing_id sounds strange -
I understand why it was done this way, but for users this could be perplexi=
ng.

The thing is that if the server is only doing GETATTR passthrough there is =
not
really a reason to deny open file in caching mode (I think?).

The limitation that requires FOPEN_PASSTHROUGH is encoded in
fuse_file_cached_io_open()
    fuse_is_io_cache_wait()
        !fuse_inode_backing()

We have two options.

Either we decide that server passing through GETATTR and opening
files in caching mode is not interesting to support (for now) and then just
maybe we need to better document the reason that server needs to
use FOPEN_PASSTHROUGH despite not doing io passthrough.

Or we relax the limitation w.r.t cached io mode, something like this
(completely untested most likely broken based or earlier review
suggestion regarding fuse_passthrough_op):

Thanks,
Amir.

diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index c5f3e2201c6ab..7c33e7a974f6c 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -20,7 +20,8 @@ static inline bool fuse_is_io_cache_wait(struct inode *in=
ode)
        struct fuse_inode *fi =3D get_fuse_inode(inode);

        return S_ISREG(inode->i_mode) &&
-               READ_ONCE(fi->iocachectr) < 0 && !fuse_inode_backing(fi);
+               READ_ONCE(fi->iocachectr) < 0 &&
+               !fuse_passthrough_op(inode, FUSE_PASSTHROUGH_RW_OPS);
 }

 /*
@@ -54,7 +55,7 @@ int fuse_file_cached_io_open(struct inode *inode,
struct fuse_file *ff)
         * Check if inode entered passthrough io mode while waiting for par=
allel
         * dio write completion.
         */
-       if (fuse_inode_backing(fi)) {
+       if (fuse_passthrough_op(inode, FUSE_PASSTHROUGH_RW_OPS)) {
                clear_bit(FUSE_I_CACHE_IO_MODE, &fi->state);
                spin_unlock(&fi->lock);
                return -ETXTBSY;
@@ -285,7 +286,8 @@ int fuse_file_io_open(struct file *file, struct
inode *inode)
         * which is already open for passthrough.
         */
        err =3D -EINVAL;
-       if (fuse_inode_backing(fi) && !(ff->open_flags & FOPEN_PASSTHROUGH)=
)
+       if (fuse_passthrough_op(inode, FUSE_PASSTHROUGH_RW_OPS) &&
+           !(ff->open_flags & FOPEN_PASSTHROUGH))
                goto fail;

        /*
