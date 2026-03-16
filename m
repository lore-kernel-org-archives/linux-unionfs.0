Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB7C34DB78
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Mar 2026 21:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773696983; cv=none; b=iBmh5sHkiWBAXKGLwKtQM/C/4snhsxjjnIhOLw5t/HHtW2Cg7B82mSTPLBu4UsKYhJEe1Kv/QZG8x4XRtg5jnHQtc0n6eDIeoF1zCSWDyc2vhsKehJ4EmJkFC6EQtcyEVUQquVI99BOuGfVfHzntZXESpEJI0txMgNcLX+ojF24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773696983; c=relaxed/simple;
	bh=ZHHsteO5AvuECau+jGB9nG1dY25l2SiYgEOKuw8Dlbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oJw+s9iVLdUna9xjfYS+RGkoWyQXJ8ftRlsbxPfKEPpOP/eRKxMTLiRbf1vmSV6Qrv8stfYikJlUaqvQnB6trYmgg8OHgZ+Uz9q5B1dDhLprYJbmlMcXC1sZUP1IXjH7g9YhV0Zy4l9BYJr9kRG/ZeDHp35goHyHZR7GnEF7/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Ftw2W6s/; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Ftw2W6s/"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5090c48de85so57886991cf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Mar 2026 14:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773696981; x=1774301781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UuAmGgbfl+JV2g5jci7AOV5QImEZLcznAUEhETM+f8o=;
        b=Ftw2W6s/R7WmEhemFD+epoWcOKvY0noPp8ClwdgCGW1KwGlLWrfXWJbkzMpZyDFbUd
         aEYzSWU1pl1UIDcKppkdvYZ3KCCPdQzbNY2guJkYf2Z3pzjwVfKc/IAbPZ0S+WwMukwE
         yXfGXLHfGaAw4Li7C0rsOzDpdSUQ5RPT1HpVKE5S8VvFuNe64OPGYHKAZSqeuG5KNcMS
         3aMmEfxIya9tqk8gahcJCTNDBKja1NzqJQ7CFsqXw07X/j6vZGF7UxvSsIfnNVh2rX7C
         xFESR4xhVIfZ5cXWyVfX9T70tqG6cLG0S9Ry1BPgA0qOIPh4ifdSrUIYqzaiz1t35DSQ
         91MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773696981; x=1774301781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UuAmGgbfl+JV2g5jci7AOV5QImEZLcznAUEhETM+f8o=;
        b=WTNgYJX1UOC8GybprESa0nucVzCinZKiDUxXtI9OCBSaeJ6d5i2sEaPWj8vMkrtZcL
         9XvVSx5gPmp0WIzQeSl8APzd8xTVE/Q3bsm3uDYzp6hpEM/jmBHR1DP/ChVRBlGs009a
         R2z9WjuGv4EWCT/c+8NFzidqnzsSMccTZlFTbRWT4Ml2f2UJp0PcQmEoPl5QNETSMXKK
         Z98IS1FBgCaF+D/+sIw5Vw4M+9w42vS8mXow7F3wRhgzKc7xe9pw4p2NhDY6vSZPy+Iw
         AfrKYE+db+UBuiyNAV0izE7jOHtNdhsyU8ofkgP83clQl3Vbu2WZyEtgzqVbawMMKcrS
         JlOA==
X-Forwarded-Encrypted: i=1; AJvYcCUIPhxbf/ly8x9+iTVtzfK9MFvPB+E7X3k6ZpIxVJT1PB3RwlMIx1D3N6UkV8HURbwm7yIDAJZcwUIEdeY3@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ9iXHYjWN0BErtNXrycB0TYO1zFeYTfb8RVHB6bpyEmnbZ25u
	tm23GdyWAC96Ljm8Dcyd6AGvQQj6XL6PlU6GbODxVSaIKN9VEJ3wbQMBjLtnMs5lbg==
X-Gm-Gg: ATEYQzw4OAtfQlgFVM/EOU/7nTUonaITMeTxOg5Jmo4VqfsSppZlQjQib4Nxhk46QA5
	wZ3tEMwHkgS+NJ7EDFnl7L2DdZBSojntaO/JlGZ9X1lXIXPN77csXNTasOcRuRi13L0NVm+YtPZ
	N+cAS1iFw8165yXuFcM7NYbIS4XhRiKJ7RSX0tqCJuSgrsw2jdVXYJnt1aGsle5MI+Sk3vOTl5g
	f+Xt7LzMnDuvXt/BDSHOsW1cTlQtE2pfddAmhkO5WgnCExoiK+vuNganq/hPwb+MPqe0uHsAgXB
	60gvCGqf+l5Ysm2UWmvz6pkbe/Nob2BIlDk7O1N42XaLUnpHjAlvq3z+AUhsasxK/hwGmG9TYy+
	sDU3+pxJeaDF2BKsjxFewLmBHqDiuimM450jUHIf+LhUhl82znaEk3Y4mO2EafDwnUeIG0EnvTP
	bT5WmlRejWUijFQK2PcrnsboR/4KTcsR3DJ+z/mJ6OsOcLhsy3Xq7ZyCjPDY9u7I6XdwT3
X-Received: by 2002:a05:622a:199d:b0:509:99c:2cbc with SMTP id d75a77b69052e-50957e1106cmr194434801cf.63.1773696981096;
        Mon, 16 Mar 2026 14:36:21 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5094a03556csm105356641cf.2.2026.03.16.14.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 14:36:20 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 0/3] Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Mon, 16 Mar 2026 17:35:55 -0400
Message-ID: <20260316213606.374109-5-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing mmap() and mprotect() LSM access control points for the
overlayfs filesystem are incomplete in that they do not cover both the
user and backing files.  This patchset corrects this through the addition
of a new backing file specific LSM hook, security_mmap_backing_file(),
a new user path file associated with a backing file that can be used by
LSMs in the security_file_mprotect() code path, and the associated
SELinux code changes.

The security_mmap_backing_file() hook is intended to allow LSMs to apply
access controls on mmap() operations accessing a backing file, similar to
the security_mmap_file() for user files.  Due to the details around the
accesses and the desire to distinguish between the two types of accesses,
a new LSM hook was needed.  More information on this new hook can be
found in the associated patch.

The new user path file replaces the existing user path stored in the
backing file.  This change was necessary to support LSM based access
controls in the mprotect() code path where only one file is accessible
via the vma->vm_file field.  Unfortunately, storing a reference to the
user file inside the backing file does not work due to the cyclic
ref counting so a stand-in was necessary, the new user O_PATH file.
This new O_PATH file is intended to be representative of the original
user file and can be used by LSMs to make access control decisions based
on both the backing and user files.

The SELinux changes in this patchset involve making use of the new
security_mmap_backing_file() hook and updating the existing mprotect()
access controls to take into account both the backing and user files.
These changes preserve the existing SELinux approach of allowing access
on overlayfs files if the current task has the necessary rights to the
user file and the mounting process has the necessary rights to the
underlying backing file.

--
Amir Goldstein (1):
      backing_file: store user_path_file

Paul Moore (2):
      lsm: add the security_mmap_backing_file() hook
      selinux: fix overlayfs mmap() and mprotect() access checks

 fs/backing-file.c             |   28 +++++---
 fs/erofs/ishare.c             |   12 ++-
 fs/file_table.c               |   53 +++++++++++++---
 fs/fuse/passthrough.c         |    3 
 fs/internal.h                 |    5 -
 fs/overlayfs/dir.c            |    3 
 fs/overlayfs/file.c           |    1 
 include/linux/backing-file.h  |   29 ++++++++-
 include/linux/file_ref.h      |   10 ---
 include/linux/lsm_audit.h     |    2 
 include/linux/lsm_hook_defs.h |    2 
 include/linux/security.h      |   10 +++
 security/security.c           |   25 +++++++
 security/selinux/hooks.c      |  108 ++++++++++++++++++++++++++++------
 14 files changed, 231 insertions(+), 60 deletions(-)

