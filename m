Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3660AC8EB;
	Sun,  2 Aug 2026 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785693655; cv=none; b=EhbBJurm0xdwDYEqrBwb58M3aSGmQcNqbdodcrLUUNraPkCfk76cjtULdkxLkZOEv7K3H4Ebs3uyz528WPfQvCCS8D2OTd0/86xm8fRFZhlF39nMCTbMVH58GqQIMJe9UN3xkIeJfddRbHK+70XPy9PhHnj9SbKpGsFn0GJZAY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785693655; c=relaxed/simple;
	bh=yhq9Fu4T1qU5Eg66CKyubI8uMlPD3dDLjZzzlC0UkhM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=RWcH8HGJmc2ClUbOVK5nfqbj8Mq0clrQ/hSIh4IcoxfoZnsDN7Odindg506Jm4NFl/hrl8p0gGaPqBsOlLZrsp9NrMcaZKiE0OSDi1WHph4wwQqZDCXtHWBxR8wAqlUOppckBzCfLqGZxvVwnrS73+K4yiZyRWk1kxYLmbkjycM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hir3URuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hir3URuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA071F000E9;
	Sun,  2 Aug 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693654;
	bh=aG5ekkfvn3A//KECMKgZl27slO76I4o4kDAK0PCOpLw=;
	h=From:Subject:Date:To:Cc;
	b=hir3URuDIttID8b5GJHAXggVkRnfATo9lrEzTpHHqRlEhyX0DQwT/JAE9Opz2z5Hf
	 sOs7KLGhrV7UZS+cmcoHUTrJjiTFFi5aeccZryrOTG1zP0WOAGX/1jCdgvLabOcUi9
	 3Qmt77+PiLlYr7qsqB3Z2FZQtMXmBt0zjUReR9oimQQbIfe03d8Aoj+NtP8J7V9Z0J
	 QXrY9rsbJLJ2qbsZNVRbQ5nTPzs1qXu0l/wUEE6juzjhyWtBi8OylIze2tKKW2S/Ay
	 SFHPgpyuNBWviQFvJ9Nv41P0/qqvq1ilNN0PYN2wTqY4mkNvfxMZ0zcL1t9Of/5tEl
	 Tk0v9VZRjV7/g==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] fs: don't warn when a mount is completed from another
 user namespace
Date: Sun, 02 Aug 2026 20:00:42 +0200
Message-Id: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMqFb2oC/yWM2wrCMBAFf6Xssysx3oK/IiKbuLHRkpZd2wql/
 25jH+dwZiZQlsQKl2oC4SFpavMCu00Foab8ZEyPhcEaezLOWBxbeWNMTXPXvmPBkSQjnSM5ezT
 WHfawqJ1wTN9/9npbWXv/4vAprfLwpIxeKIe6TEPU7WrM8w87PpWIlAAAAA==
X-Change-ID: 20260802-work-fill_super-warn-a7fa82502843
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Laurent Vivier <laurent@vivier.eu>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=1667; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yhq9Fu4T1qU5Eg66CKyubI8uMlPD3dDLjZzzlC0UkhM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlt1761vZrmk3uD7czkz4+dJXV/MDXkKflE//Rz9O51
 16TYX9NRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETCmBkZdoVcDNXWN3jFpjyV
 85zCT98J809OuBeeNatA+5bSzDOhhowM16Pb9obpl8W/W5N94PRz7Xs/RJj/ej7Zlz3rIJe2yOL
 rjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

fsopen() records the caller's user namespace in fc->user_ns and hands back
an ordinary file descriptor. The task that calls fsconfig(CMD_CREATE)
doesn't have to be the one that created the context, and mount_capable()
lets it through as long as the caller has CAP_SYS_ADMIN over fc->user_ns,
which anyone in an ancestor namespace does. So fc->user_ns !=
current_user_ns() is something an unprivileged user can arrange.

Both overlayfs and binfmt_misc WARN_ON() that. They're plain WARN_ON()s, so
it can be done in a loop to taint the kernel and flood the log, and it
panics a machine booted with panic_on_warn. Keep refusing the mount, just
stop warning about it. Overlayfs already spells the same check as a plain
error return in ovl_parse_param() for Opt_override_creds.

And add a selftest for both cases.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      ovl: don't warn when the mount is completed from another user namespace
      binfmt_misc: don't warn when the mount is completed from another user namespace
      selftests/filesystems: test completing a context from another user namespace

 fs/binfmt_misc.c                                   |   3 +-
 fs/overlayfs/super.c                               |   3 +-
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/fscontext_ns/Makefile    |  10 +
 .../filesystems/fscontext_ns/fscontext_ns_test.c   | 239 +++++++++++++++++++++
 5 files changed, 254 insertions(+), 2 deletions(-)
---
base-commit: c679ce3be6cb63763d68ab9b5d9d73ddc0a40762
change-id: 20260802-work-fill_super-warn-a7fa82502843

