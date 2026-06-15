Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50EB404BE1;
	Mon, 15 Jun 2026 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781537619; cv=none; b=pLTvpyUQUBiQyIeDmoqkTyh8RcAULiMm/PpnhRqbNqh7pbXg3BKPSKgMtlUNmYyPRXVFxB8zFTUSN7fiFN4C0j/zzsy1wp3OkuEtMywSRZPK8OvKCQyZYt1HVmtHGdwmNDU4aszLhvxgsnZrV5W5/rjuyvU6pscmU2DL3nD8pEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781537619; c=relaxed/simple;
	bh=/BwJwV7xSr+iRGPDOYiJLZVawjNzXRRbFo0JPbyqlaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o+j8kpbwbncRvqMN71ViqNjaeCB4WZbkd2PrHyqW2wIU1UJM9roVU/RN66pBZqOUUvV+omHuHrHHY36vcvBjsNRDgRaqYj48PlLgrENUNw7ekhDs7b4kgJPPXh3g/4smCagIjFnD5Tl3dArFhtrThrZV4+t6xdLFg2aPHRMlAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oi195w7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oi195w7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D072D1F000E9;
	Mon, 15 Jun 2026 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781537617;
	bh=exkQYL0xBTiFhhLzxxkcUE0ln80TrGqH9ZuV+0qqWH0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Oi195w7FmEAmlK6pQq3un6Oh23ma7mFwnWPbZLaAER5R3hyD7yZPIkwhPQpmx2lt0
	 Q6YqTdNT9N2nyI8F/mmM2EHazmrgZTZdESqF1qbVofsS/WcjTSMa3Az0+tArfLKCZp
	 4PWAbybjjslUa9JuJCF6S5Qt9KlhxUjGhnDmQbOXEdD/Guerip+HFXyqPhqiezN8iB
	 tTIQfRpodnZjARMeYHcxdk57g285gUsVPGPEoAcAwb6Y9l03qS4Fd7DksuIWaXVoq1
	 F6crCUbrYnEyxZzF9ecIatRmq9pFpi1yhMKmFYO6fnPRYk3qSgNIpscxLlh6ks/+h4
	 5bR1Rfl2TLlgw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 17:33:29 +0200
Subject: [PATCH 1/2] src/vfs: probe O_TMPFILE support on the base mount in
 the idmapped tests
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
In-Reply-To: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Zorro Lang <zlang@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fstests@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=2927; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/BwJwV7xSr+iRGPDOYiJLZVawjNzXRRbFo0JPbyqlaw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZSPsus3FZzs617PhMx/cXW3wE9Oe5LCvf7KEvIm4q+
 qWVMauzo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLzDBn++29rnLD3Vf0UDm2b
 mN0/tzHE3OqSu+Uz0/WV55MdsxUsohn+qXO4aHvM7nbb5Cdce+nyAe/EFOZoJo85nXv91e4LHWL
 hBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

openat_tmpfile_supported() in the idmapped mount tests probes O_TMPFILE
on the idmapped mount (open_tree_fd) as the test's fsuid -- but that
fsuid is not mapped by the idmapped mount under test, so it really asks
"can this unmapped caller create a tmpfile through this idmap?" instead
of "does the filesystem support O_TMPFILE?".

On overlayfs this is a false negative: the backing tmpfile ends up owned
by an unmapped id, overlayfs opens it with O_NOATIME and may_open()
returns -EPERM, so the tmpfile sub-tests are wrongly skipped.

O_TMPFILE support is a property of the filesystem, not of the idmapped
mount or the caller's mapping. Probe info->t_dir1_fd, the base mount
that the caller owns, exactly as the non-idmapped setgid tests already
do. The probe then succeeds on every filesystem and the tmpfile
sub-tests run as the mapped fsuid.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 src/vfs/idmapped-mounts.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
index ed9992f9..8f8441c9 100644
--- a/src/vfs/idmapped-mounts.c
+++ b/src/vfs/idmapped-mounts.c
@@ -3838,7 +3838,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 		goto out;
 	}
 
-	supported = openat_tmpfile_supported(open_tree_fd);
+	supported = openat_tmpfile_supported(info->t_dir1_fd);
 
 	pid = fork();
 	if (pid < 0) {
@@ -4014,7 +4014,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		goto out;
 	}
 
-	supported = openat_tmpfile_supported(open_tree_fd);
+	supported = openat_tmpfile_supported(info->t_dir1_fd);
 
 	pid = fork();
 	if (pid < 0) {
@@ -7733,7 +7733,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 		goto out;
 	}
 
-	supported = openat_tmpfile_supported(open_tree_fd);
+	supported = openat_tmpfile_supported(info->t_dir1_fd);
 
 	pid = fork();
 	if (pid < 0) {
@@ -7947,7 +7947,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
 		goto out;
 	}
 
-	supported = openat_tmpfile_supported(open_tree_fd);
+	supported = openat_tmpfile_supported(info->t_dir1_fd);
 
 	/*
 	 * Below we verify that setgid inheritance for a newly created file or
@@ -8181,7 +8181,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		goto out;
 	}
 
-	supported = openat_tmpfile_supported(open_tree_fd);
+	supported = openat_tmpfile_supported(info->t_dir1_fd);
 
 	pid = fork();
 	if (pid < 0) {
@@ -8536,7 +8536,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		goto out;
 	}
 
-	supported = openat_tmpfile_supported(open_tree_fd);
+	supported = openat_tmpfile_supported(info->t_dir1_fd);
 
 	/*
 	 * Below we verify that setgid inheritance for a newly created file or

-- 
2.47.3

