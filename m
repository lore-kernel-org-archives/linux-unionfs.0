Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDDE22F01
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892717; cv=none; b=Kw9501lvkK9JBtpoK7dcSnwRGl4RvomrHHSfDBVStA4QvpX0vYSJx9tXYpJC5VNNXEDdVModQvxegcwZ+JdtFvm51Xk12VcM1i/I8DbS7IW2/npqaeFzcYN43/355XD3mHjky+GvRyOlSIf/EymnD8iLONuR2dbre4L7keHFCxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892717; c=relaxed/simple;
	bh=o67AANEOaaDmaW9WzNpQCZJDqZiiEfxqwrW/Av9TDlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Onp4N6WyySMdRVAX+YG7fT20KrG8LMulutPDyTcHCv7K6nXSiSTCqNAEri5QBR9di2VHMl87M2FrqjS5JhXlmTDhRyL1aebPDFUyou/vT+aPQptVufdQjXLkH8utEf84yfuBx6eUarg43E9snM1turQWk23hzTZ8i+7VVz+iCp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HxLS/ndh; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxLS/ndh"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7c23248f3a3so568627b3.1
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892715; x=1779497515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KLYnxOjuWihDf1OJ1uA3JEFFOQyrieXCrqDHfBzMay4=;
        b=HxLS/ndhXQunTXJDemsHPxLH/8lB3gOWOF/It+DUqx8tWQPTEgEopfRjeYdMsCFJsP
         SUdgUt5V7/EC9PmmFwdTY+EiRESdHIDo6C912kgfyiGMA8ts84wW8MnaG/vadPkQnRLt
         m0F3TRHd6aUC30tl48jyODgcZaNAY+E2K6K8X2D5LE7OZ282ORWwOSdrLgIkAKnBibSE
         7wjnMsiYvS6gNvj9xXNw7E0Scy0xGtxShWgLJ5Rw7ncFdSGY7zwndn0l+GOqpjdViMUp
         OLjYNMw5+Fe9dxRsvWsGf0DkJrZOYdyB4zVR8m4ttjMo2aTusoenlD69wBPBE+P+modW
         MQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892715; x=1779497515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLYnxOjuWihDf1OJ1uA3JEFFOQyrieXCrqDHfBzMay4=;
        b=gkZ97lTBIAMCAlpsctXr69fJdY3I7tY3p57jpCS0OZ3KAT3rocYdglrhiP+lWjmGIs
         y3TrcfvZnn76se7V29CuwTT3j7lK6PNOGSsRZoGJHIQesixDCdzUq9Zrf9SE5C+PZjoJ
         ue3dNpQWOt+Oae4fF9Q4/GY6u06GHIIDjKFfdLKzH8BHDdnkPeStUqiJPFJci/tn4uuh
         fP0xEh4IyL2AMrfUBb2+PVh8ohCa0TY9RrI2tqMICdjaTRD+Syw3n9FDzCjzJtOQktsP
         K+OPdmYHDRKXy8AjyQ9z7U/Tn12+ouQ5N1A8ZJsusM9mPkCOoHqlH/OHcUZ09oU710R6
         9Icg==
X-Forwarded-Encrypted: i=1; AFNElJ8hNjJLjltLQsifCW9jR62Qq0cXrp8ACN+hCZ0noV8XVZb+lE7EocdfwpHn1J6WI+0jhyVEzzn9h5PkTMbK@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7Y2L9iEStyrSOIDEq/1xIxeXqoiyuGI+uQu/+OY/il5cxSoEJ
	51U2bQzuA3RrBmgETXZMSMeQJ/v2Zw+R1NQtYVIr3TWr7/Yl2mKNr6wx
X-Gm-Gg: Acq92OGgfjmAvUJXq5Kln388YPE4wPvUSr6+CSZ/8+n7njVFZd1Fjfgvz/sM5LEHE4G
	Lzt4BR3Ka9AS9l7wAEJcHU++Y6POXqPQErJJy7VKsDcqxnMJmu1d7puU5FdRRKOHSslkkq0QXAl
	f3RXq8JQxdSoUwpz2ROFtOPL83zbHw2bfVayCdEhzoFn5y5BI7gfka/TwztMo0Ra2pb2DfyC2If
	wTDB8279IwemDa1JvDRfQdAfQmxLKNgOxf9fXKumpZEjoTvMBTaX9p/pxCTRUdppVu5dqLWyIDI
	evMNf++N9Ka72DmSJRxTk88SjY9UaVMx5Xdu+dUQ7QBmlxHF0DUq9yVW7C0ZxbBDU5IeQ5hzEYo
	iWEy8U7GNuyTIfksFeX1MKOzjuDBgNcOYRbZKTnYIZaxKuDyOAW+D4wU+jVinLD100i795fooUJ
	XRUjG0wRfv1HM88aWlJ52D2vyAwYWYLY4=
X-Received: by 2002:a05:690c:6c87:b0:7c0:8028:11f7 with SMTP id 00721157ae682-7c959b9720amr74834237b3.6.1778892715333;
        Fri, 15 May 2026 17:51:55 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:3f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c9cf5da147sm15615097b3.20.2026.05.15.17.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:51:54 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 00/21] fuse: extend passthrough to inode operations
Date: Fri, 15 May 2026 17:39:43 -0700
Message-ID: <20260516004004.1455526-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series extends fuse passthrough to support inode operations (getattr +
setattr) and directory readdir.

The existing FUSE_PASSTHROUGH mode attaches a backing file to a fuse inode
only when a passthrough file is open. This series introduces
FUSE_PASSTHROUGH_INO, a stricter mode requiring one-to-one inode number
mapping, which allows attaching a backing file for the lifetime of the fuse
inode.

This is based off Amir's work. Patches 1-7 are from his git tree in [1].

For testing/debugging, this was done using the passthrough_hp server with the
changes in [2] applied.

This series was run through fstests using passthrough_hp in [2]. There were no
regressions seen compared to passthrough_hp --nopassthrough and an improvement
in generic 683, 684, and 685 (dropping suid/sgid) now passing. Compared to
passthrough_hp without inode operations passed through, generic tests 080 and
215 (mapped write timestamp updates) now pass.

This is on top of commit ea2ff881bb8e ("fuse: reduce attributes invalidated on
directory change") + a locally applied patch [3], in Miklos's fuse tree.

[1] https://github.com/amir73il/linux/commits/fuse-backing-inode-wip/
[2] https://github.com/joannekoong/libfuse/commits/extended_passthrough_v2/
[3] https://lore.kernel.org/fuse-devel/20260513231437.1806724-1-joannelkoong@gmail.com/T/#u

Changelog
---------
v1: https://lore.kernel.org/fuse-devel/CAOQ4uxjBZL6CY0mJEiHrw8aR28MHg5pU+Pfr9fUqGdKPDOdwcw@mail.gmail.com/T/
v1 -> v2:
- Address Amir's feedback (especially about not mixing cached io mode with
  passthrough mode, dropping the passthrough open patch, modeling some of the
  logic after overlayfs)
- Diff between v2 and v1 for Amir's patches 1-7:
  https://gist.github.com/joannekoong/451eb02e716fa6321a622a61a95aea04

Amir Goldstein (7):
  fuse: introduce FUSE_PASSTHROUGH_INO mode
  fuse: prepare for passthrough of inode operations
  fuse: prepare for readdir passthrough on directories
  fuse: implement passthrough for readdir
  fuse: prepare for long lived reference on backing file
  fuse: implement passthrough for getattr/statx
  fuse: prepare to setup backing inode passthrough on lookup

Joanne Koong (14):
  fuse: handle zero ops_mask in FUSE_DEV_IOC_BACKING_OPEN
  fuse: handle partial io passthrough for read/write, splice, and mmap
  fuse: prepare to cache statx attributes from entry replies
  fuse: clean up fuse_dentry_revalidate()
  fuse: add struct fuse_entry2_out and helpers for extended entry
    replies
  fuse: add passthrough lookup
  fuse: add passthrough support for entry creation
  fuse: add passthrough support for create+open
  fuse: allow backing_id=0 in open to inherit inode's backing file
  backing-inode: add backing_inode_copyattr()
  backing-inode: add backing_inode_setattr()
  fuse: add passthrough setattr
  fuse: use passthrough getattr in setattr suid/sgid handling
  docs: fuse: document extended passthrough (FUSE_PASSTHROUGH_INO)

 .../filesystems/fuse/fuse-passthrough.rst     | 126 ++++++
 fs/Makefile                                   |   2 +-
 fs/backing-inode.c                            |  97 +++++
 fs/fuse/backing.c                             |  64 ++-
 fs/fuse/cuse.c                                |   2 +-
 fs/fuse/dir.c                                 | 391 +++++++++++++-----
 fs/fuse/file.c                                |  37 +-
 fs/fuse/fuse_i.h                              |  83 +++-
 fs/fuse/inode.c                               |  27 +-
 fs/fuse/iomode.c                              | 122 +++++-
 fs/fuse/passthrough.c                         | 122 +++++-
 fs/fuse/readdir.c                             |   5 +-
 fs/overlayfs/inode.c                          |  66 +--
 fs/overlayfs/util.c                           |  33 +-
 include/linux/backing-inode.h                 |  18 +
 include/uapi/linux/fuse.h                     |  32 +-
 16 files changed, 969 insertions(+), 258 deletions(-)
 create mode 100644 fs/backing-inode.c
 create mode 100644 include/linux/backing-inode.h

-- 
2.52.0

