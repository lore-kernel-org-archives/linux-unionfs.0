Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19074C9E0E
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359420; cv=none; b=X59rBKOsuPy94zDVqY0eaHbL6ECI6kw9A2LiVlUJ2Kk7lZ3kfuVPUQgKtOmqWtQ6UyO5WdyLHAogTySybW9VRTsDH0KV02KYJeOOpuHr0wNMSqc72K6c3akLmSVcw4wgIfyuRAmvEyE4eGSgXbF0kkt/H2zob29tigSacYYU8QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359420; c=relaxed/simple;
	bh=9WMHF+OHSITVcxou8oXsCNs7bqvndQmUaAq4mexKulc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odWgIOJPdUeWzk9Nz9CR0KSEo1FrVhpxhQW45jKY7BDg1C9OUF40IMyRs6oWrEQEOUVf7n1es+O/M70losZ4U+oiO7kql1/iIprDOZViBcU7nHZ80VOI5qqNKf/XPcXwGL6r8a9uXMhsxec8omGw827xKggZQO1X/0NeJgVb/TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IYdRQgvf; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYdRQgvf"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d46e4cdccso9790207b3.1
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 11:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790359417; x=1790964217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jQMqDoXS5hmMS94pm40dP6RGo8yiKpCUOJDdJtjp2gs=;
        b=IYdRQgvfuMeOmvrkILgOhtEo6bJ4/rNTSPyK2vFOFc+eWWD20PR/TxxHTIMAgFjqZ5
         ZswjzX8qhzMQ9dqrYHN7aWth4+pVDOF0inBoV9wO5pXUsNph5NLHgW9MVVONT+PfMmVR
         qP7AbGgH9kFISF/uqhCeicA9DSDBrkJZBztEZhoambxx5GMT8tPkPSli+AHJFgR5mh/n
         rWHa7ys7w2biFz0DRcMahrpaJ6uUMCHJaKo68fmXy8nuA6/jBjawu/zESfEo8AznwC8Y
         x94hCmJKvqhUQawNt8MHWKikOeGO6n9fa61x+LfMC4xoFiQ5G4Zirmy6agu/rJJLjTjA
         cMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790359417; x=1790964217;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jQMqDoXS5hmMS94pm40dP6RGo8yiKpCUOJDdJtjp2gs=;
        b=Q1yIDMlE/LpUq1nNmdYvUAgPpEpugmCp1etaMu1KfwYv31jG/nvidgmtEHrgZ35OmM
         drhLW+ySYJ30WZ9orAuvlTxQSabBYdXR1T/lffaNEHk38FjFwbTW63I0kN8hI1yiTz67
         cYVxvM9Rw5dPTnXRq2MKUXD9CxvAjijLLHK0B2CypNVI2Flb9gbwZppMC7KXXU0UNIio
         2TlCGWguokTftXJLfouaS9JYQP0FTVuDktocrscux/Cv0rPzcThwDsOmJj426XWSL6Ch
         /dl5QPwtgAa0Y7SDOjN0l2meCJdh1mtCRE/2M7kfke2R047cDLUe384QzCjpFxPafmeW
         Wj5A==
X-Forwarded-Encrypted: i=1; AKwUvByKQqM5ZXfOZgW2wsECy+YBD9r7d7PvqyaHbz7rzISZLiZ943rfi7McBv92kViWIBzKJ5S1dX1eWenkmxle@vger.kernel.org
X-Gm-Message-State: AFuF++nNUEm1Gqrf/EXFldWZYYkDxjv6A7rjpKj3zOxQH53bCeOuSaWU
	9n79nAD8VIm2oQWqJpldrtY/zM4cL3UZgbZ22b54bsw18BFxqQEKcC+O
X-Gm-Gg: AYBFou3LvGvGn0v96eBnj5KskaO7sLIX6pimM8Pl8Mb9prrtAqrDVhba3KfzB/VeyOw
	nUUgvTYUZsXHTdh2NB7UkhooIfQI/9RI9eIfxqiPTfbpLNIL2ndU8DPsxxZpOZVxoK1X24IEor7
	eENdF8vBX1bPIG/8HBEQC1Frmrr42Fi5PTtrPT5Gu2PgWozAD2tdSW7/hUqrFXtwu5PxSXBwg/e
	KnAx/bxM+rQ3oY0bmZRRg+mE1zmRQyFP+boegsF+r9Ojjes1DHtBDNCMFyJByZsBDgFb58HlKFr
	SDj2uGOdgU4XgVeTTeVGvANl8xLESskCxhiMWpIEBvCBctGRqt5tghLO4r+7rbO0WkMWvq9gg95
	HsL/1P4cilOjOWMUk34P2ZM1Bww3GjjTP0Gy47dYC3EUOAxqv/Gzj3QnFO7Z6Y8zuhU258EieOe
	/GyL/uh6s2+bGFrAyMZdiYEgrpaG/cYExDLZyHsktnAouG5VYdHsDS9tKd69R7K73k/D1vS162y
	H4=
X-Received: by 2002:a05:690e:b4b:b0:672:a678:da59 with SMTP id 956f58d0204a3-6740c2a76c3mr1631246d50.108.1790359416590;
        Fri, 25 Sep 2026 11:03:36 -0700 (PDT)
Received: from suesslenovo ([71.132.185.69])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6740efb13fasm1359157d50.18.2026.09.25.11.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 11:03:36 -0700 (PDT)
Date: Fri, 25 Sep 2026 14:03:05 -0400
From: Justin Suess <utilityemal77@gmail.com>
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: mic@digikod.net, gnoack@google.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	dlemoal@kernel.org, hch@lst.de, axboe@kernel.dk, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, dhowells@redhat.com, code@tyhicks.com, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	hirofumi@mail.parknet.co.jp, cel@kernel.org, jlayton@kernel.org, neil@brown.name, 
	okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, miklos@szeredi.hu, 
	amir73il@gmail.com, senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com, 
	zohar@linux.ibm.com, roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com, 
	eric.snowberg@oracle.com, stephen.smalley.work@gmail.com, omosnacek@gmail.com, 
	casey@schaufler-ca.com, nanx95726@gmail.com, djwong@kernel.org, daniel@iogearbox.net, 
	linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netfs@lists.linux.dev, ecryptfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	xiujianfeng@huawei.com, lujialin4@huawei.com
Subject: Re: [PATCH RFC -next 00/12] landlock: Add READ_METADATA and
 WRITE_METADATA access rights
Message-ID: <araxO4ze0KZBz756@suesslenovo>
References: <20260924104831.1081137-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924104831.1081137-1-caixinchen1@huawei.com>

On Thu, Sep 24, 2026 at 06:48:19PM +0800, Cai Xinchen wrote:
> This series adds two new Landlock filesystem access rights,
> LANDLOCK_ACCESS_FS_READ_METADATA and LANDLOCK_ACCESS_FS_WRITE_METADATA,
> which control access to file and directory metadata such as inode
> attributes (mode, ownership, timestamps), extended attributes and POSIX
> ACLs.  It picks up the work from the "landlock: add chmod and chown
> support" series [1] and follows the coarse-grained grouping discussed in
> that thread [2]: instead of separate chmod/chown rights, metadata
> operations are grouped into one read and one write right.
> 
> Landlock evaluates access rights on a per-path basis, but the metadata
> related LSM hooks (inode_getattr, inode_setattr, inode_setxattr,
> inode_getxattr, inode_listxattr, inode_removexattr, inode_set_acl,
> inode_get_acl, inode_remove_acl) only receive the dentry of the accessed
> object.  Patches 1-7 therefore first pass struct path instead of dentry
> through the metadata-related VFS helpers and LSM hooks.  This is a pure
> refactoring with no behavior change, split so that every patch builds
> and works on its own:
>
I like these patches, but is the ability to read metadata already
sorta controlled by LANDLOCK_ACCESS_FS_READ_DIR on the parent
directory?

The one case I see this being different is:

1. if you wanted to grant read access to the file, but not metadata
read access, but I can't think of any usecase for being able to read
the contents of a file, but not the metadata. (see below)

2. If you had the absolute path already and didn't need READ_DIR.

I see introducing this READ_METADATA as causing potential
hard-to-diagnose issues.

Say you handle READ_METADATA and READ_FILE, but only grant READ_FILE.

The program can technically open the file with the READ_FILE permission,
but it may error out because the stat() on it beforehand failed.
It's pretty common for programs to do that kind of thing (stat before
open), like for checking for config files (strace bash and you see it
stat .profile, /etc/profile)

There may be other bugs, because being able to set permissions to read
a file *but not read it's metadata* isn't possible currently in posix
acl and userspace may not work well if that assumption no longer holds.

So maybe WRITE_METADATA is good enough?

Interested in your thoughts,
Justin
>   1: notify_change() and its callers
>   2: inode_setsecctx hook (must come before 3: the SELinux and Smack
>      implementations call __vfs_setxattr_locked internally)
>   3: xattr helpers, which also drops a redundant EVM xattr size sanity
>      check whose vfs_getxattr() call only has a dentry and therefore
>      cannot be migrated to the new path-based signature
>   4: POSIX ACL helpers
>   5: inode_setattr hook
>   6: inode xattr hooks
>   7: inode POSIX ACL hooks
> 
> Two deliberate scoping decisions for this refactor:
> 
> - The hooks consistently take struct path rather than struct file.  The
>   VFS call sites involved (chmod(2), chown(2), utimensat(2), xattr(2)
>   and ACL syscalls) operate on paths, and several of them (lstat(2),
>   lchown(2), llistxattr(2), ...) have no struct file to begin with.
> 
> - struct inode_operations->setattr still receives (idmap, dentry, attr).
>   Only the VFS boundary (notify_change()) and the LSM hook layer see the
>   path, which keeps the refactor contained to fs/attr.c and the LSM
>   infrastructure instead of touching every filesystem.
> 
> Patches 8-12 then implement the new rights, their tests, the sandboxer
> sample and the documentation.  Semantics:
> 
> - READ_METADATA covers stat(2) and friends, getxattr(2) and friends,
>   listxattr(2) and friends, and POSIX ACL reads.
> - WRITE_METADATA covers chmod(2), chown(2), utimensat(2), setxattr(2),
>   removexattr(2) and friends, and POSIX ACL set and remove.
> - Only explicit metadata changes requested by user space are restricted.
>   Implicit changes performed by the kernel (e.g. timestamp updates on
>   write(2), size changes on truncate(2)) are not, and neither are
>   chmod(2)/chown(2) calls that change nothing (e.g. chown(2) with
>   (-1, -1), which never reaches the hook), matching the SELinux
>   inode_setattr behavior.
> - Kernel-internal accesses performed with override_creds() (e.g.
>   overlayfs, cachefiles) and kernel threads without a Landlock domain
>   (e.g. nfsd, ksmbd) are not restricted.
> 
> The Landlock ABI version is incremented from 11 to 12.
> 
> The series is based on linux-next commit 5c4d4169604b ("Add linux-next
> specific files for 20260921").
> 
> Testing: each patch has been built for aarch64 (gcc, -Werror) and the
> landlock selftests (445 tests, including the new ones) pass in QEMU on
> aarch64; base_test reports ABI v12.
> 
> [1] https://lore.kernel.org/all/20220827111215.131442-1-xiujianfeng@huawei.com/
> [2] https://lore.kernel.org/all/abc960a1-e66e-792e-6869-cfd201c29dbe@digikod.net/
> 
> Assisted-by: opencode: glm-5.3
> 
> Cai Xinchen (12):
>   fs: pass struct path to notify_change()
>   LSM: pass struct path to the inode_setsecctx hook
>   fs: pass struct path to xattr helpers
>   fs: pass struct path to POSIX ACL helpers
>   LSM: pass struct path to the inode_setattr hook
>   LSM: pass struct path to the inode xattr hooks
>   LSM: pass struct path to the inode posix acl hooks
>   landlock: Add READ_METADATA and WRITE_METADATA access rights
>   landlock: Implement metadata access hooks
>   selftests/landlock: Add tests for metadata access rights
>   samples/landlock: Add metadata rights to sandboxer
>   Documentation: Update landlock doc for metadata rights
> 
>  Documentation/userspace-api/landlock.rst     |  11 +-
>  drivers/base/devtmpfs.c                      |   6 +-
>  drivers/block/zloop.c                        |   4 +-
>  fs/attr.c                                    |  20 +-
>  fs/cachefiles/interface.c                    |   6 +-
>  fs/cachefiles/xattr.c                        |  32 +-
>  fs/coredump.c                                |   2 +-
>  fs/ecryptfs/inode.c                          |  34 +-
>  fs/exfat/file.c                              |   3 +-
>  fs/fat/file.c                                |   3 +-
>  fs/inode.c                                   |   7 +-
>  fs/internal.h                                |  17 +-
>  fs/namei.c                                   |   7 +-
>  fs/nfsd/nfs4ctl.h                            |   4 +-
>  fs/nfsd/nfs4state.c                          |  14 +-
>  fs/nfsd/nfs4xdr.c                            |   2 +-
>  fs/nfsd/state.h                              |   2 +-
>  fs/nfsd/vfs.c                                |  73 +++--
>  fs/open.c                                    |  18 +-
>  fs/overlayfs/copy_up.c                       |   4 +-
>  fs/overlayfs/inode.c                         |   4 +-
>  fs/overlayfs/overlayfs.h                     |  39 ++-
>  fs/overlayfs/xattrs.c                        |  13 +-
>  fs/posix_acl.c                               |  46 +--
>  fs/smb/server/smb2pdu.c                      |  77 ++---
>  fs/smb/server/smb_common.c                   |   2 -
>  fs/smb/server/smbacl.c                       |  21 +-
>  fs/smb/server/tests/smbacl_kunit.c           |   6 +-
>  fs/smb/server/vfs.c                          | 111 +++----
>  fs/smb/server/vfs.h                          |  39 +--
>  fs/smb/server/vfs_cache.c                    |   3 +-
>  fs/utimes.c                                  |   3 +-
>  fs/xattr.c                                   |  96 +++---
>  include/linux/fs.h                           |   6 +-
>  include/linux/landlock.h                     |   4 +-
>  include/linux/lsm_hook_defs.h                |  29 +-
>  include/linux/posix_acl.h                    |  21 +-
>  include/linux/security.h                     |  65 ++--
>  include/linux/xattr.h                        |  22 +-
>  include/uapi/linux/landlock.h                |  26 +-
>  samples/landlock/sandboxer.c                 |  17 +-
>  security/commoncap.c                         |  22 +-
>  security/integrity/evm/evm_crypto.c          |   8 +-
>  security/integrity/evm/evm_main.c            |  36 ++-
>  security/integrity/ima/ima_appraise.c        |  17 +-
>  security/landlock/fs.c                       |  86 ++++++
>  security/landlock/limits.h                   |   2 +-
>  security/landlock/syscalls.c                 |   2 +-
>  security/security.c                          |  99 +++---
>  security/selinux/hooks.c                     |  49 +--
>  security/smack/smack_lsm.c                   |  62 ++--
>  tools/testing/selftests/landlock/base_test.c |   2 +-
>  tools/testing/selftests/landlock/fs_test.c   | 309 ++++++++++++++++++-
>  53 files changed, 999 insertions(+), 614 deletions(-)
> 
> -- 
> 2.18.0.huawei.25
> 
> 
