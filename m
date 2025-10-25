Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA93301701;
	Sat, 25 Oct 2025 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409420; cv=none; b=Qedt2p8A7DOM9g4gPKUFm0pXJa6WtCFchC+J1v4N9CiTXIK8KUPKJMXswrPCqyDj9EU7ORlxVViYUY7Zjw3QnKEkZVfGxKmAxCJs7Y1PSnEZ2UG0d+9/RxDU+kw3aSw6cTb+RUXcJp6gmXq10n24GWRSyJq4HV6eBQEaHahsyvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409420; c=relaxed/simple;
	bh=6kxn7BdwEMMDC2EWcp2m7UI6yGQ+VpOpXsUKaM6G13g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HM0Njnh1Z/luEtrxiL5gjkSsfCUcRVGFlmTHQ6V1DLAOJimC80SL7r8nQsJXYMVOIngU0mmib9sIxti2OMV9O3rbKIy+i7vty2dq9jatcRK+6AcepoHXwnWsjr55PX508A25jaIdcGiQ8pjIuxUAohq9QR6VHbq+JRmdvE76/44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cfbryb7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cfbryb7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F668C4CEF5;
	Sat, 25 Oct 2025 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409420;
	bh=6kxn7BdwEMMDC2EWcp2m7UI6yGQ+VpOpXsUKaM6G13g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cfbryb7kVKhMmn4lk+2Y1hr6D3HTvGD9G8JZLnto9p/sLnAw+qJ6PVNsynPOQUiOs
	 gbzFS3NaGq37PTK+3mG9LNuzm4EyCp7wesWW3noIvDjLuS49+AxAkuAQW6BbjALuZ+
	 RoKPoIUio5g47VS82rKtcRczOD6Tbnhm3r81umePRGyN4Xc3/A4JEvVvxaZppx+SNy
	 w9+sRoDMTSGvCMkUmJyYwgkdTDZUguKG8x38Haf8txhAuCfy0LixEVvfk4Dj0Gx6dI
	 3tNpS8MNevjxuAUqduZYvhRVIX8+cLzUWb1E+a9gQVLLNR9fSgBmDhdTW309VtQsY8
	 wB8dV/wZHbWjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Neil Brown <neil@brown.name>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] ovl: make sure that ovl_create_real() returns a hashed dentry
Date: Sat, 25 Oct 2025 11:59:08 -0400
Message-ID: <20251025160905.3857885-317-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit ad1423922781e6552f18d055a5742b1cff018cdc ]

e8bd877fb76bb9f3 ("ovl: fix possible double unlink") added a sanity
check of !d_unhashed(child) to try to verify that child dentry was not
unlinked while parent dir was unlocked.

This "was not unlink" check has a false positive result in the case of
casefolded parent dir, because in that case, ovl_create_temp() returns
an unhashed dentry after ovl_create_real() gets an unhashed dentry from
ovl_lookup_upper() and makes it positive.

To avoid returning unhashed dentry from ovl_create_temp(), let
ovl_create_real() lookup again after making the newdentry positive,
so it always returns a hashed positive dentry (or an error).

This fixes the error in ovl_parent_lock() in ovl_check_rename_whiteout()
after ovl_create_temp() and allows mount of overlayfs with casefolding
enabled layers.

Reported-by: André Almeida <andrealmeid@igalia.com>
Closes: https://lore.kernel.org/r/18704e8c-c734-43f3-bc7c-b8be345e1bf5@igalia.com/
Suggested-by: Neil Brown <neil@brown.name>
Reviewed-by: Neil Brown <neil@brown.name>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `ovl_parent_lock()` now fails whenever the child dentry is unhashed
  (fs/overlayfs/util.c:1552-1560), which is exactly what happens for
  casefolded workdirs: `ovl_create_temp()` returns the unhashed dentry
  to `ovl_check_rename_whiteout()`, the sanity check at
  `ovl_parent_lock(workdir, temp)` (fs/overlayfs/super.c:575-584) hits
  `-EINVAL`, and overlayfs refuses to mount. That is a major user-
  visible regression caused by the earlier sanity check addition.
- The patch guarantees that `ovl_create_real()` only hands back hashed
  dentries: after the existing error gate (fs/overlayfs/dir.c:215), the
  new block detects `d_unhashed(newdentry)` and re-issues
  `ovl_lookup_upper()` while the parent lock is still held, replacing
  the unhashed instance with a freshly looked-up, hashed, positive
  dentry (fs/overlayfs/dir.c:218-237). This removes the false positive
  from `ovl_parent_lock()` and lets casefolded overlays mount again.
- The extra lookup only runs in the rare unhashed case, uses existing
  helpers, and preserves the previous cleanup path via `dput(newdentry)`
  and error propagation (fs/overlayfs/dir.c:234-239). All direct users
  of `ovl_create_real()`—temp/workdir setup (fs/overlayfs/dir.c:251,
  fs/overlayfs/copy_up.c:550, fs/overlayfs/dir.c:414) and generic upper
  creation (fs/overlayfs/dir.c:362)—benefit without behavioural changes
  elsewhere.
- Scope is limited to overlayfs; no ABI or architectural changes; the
  fix addresses a regression introduced by e8bd877fb76b and restores a
  broken workflow. That is exactly the sort of targeted bug fix we want
  in stable.

Given the severity (overlayfs + casefold mount broken) and the
contained, low-risk fix, this should be backported.

 fs/overlayfs/dir.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index dbd63a74df4b1..039e829aa7dee 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -205,12 +205,32 @@ struct dentry *ovl_create_real(struct ovl_fs *ofs, struct dentry *parent,
 			err = -EPERM;
 		}
 	}
-	if (!err && WARN_ON(!newdentry->d_inode)) {
+	if (err)
+		goto out;
+
+	if (WARN_ON(!newdentry->d_inode)) {
 		/*
 		 * Not quite sure if non-instantiated dentry is legal or not.
 		 * VFS doesn't seem to care so check and warn here.
 		 */
 		err = -EIO;
+	} else if (d_unhashed(newdentry)) {
+		struct dentry *d;
+		/*
+		 * Some filesystems (i.e. casefolded) may return an unhashed
+		 * negative dentry from the ovl_lookup_upper() call before
+		 * ovl_create_real().
+		 * In that case, lookup again after making the newdentry
+		 * positive, so ovl_create_upper() always returns a hashed
+		 * positive dentry.
+		 */
+		d = ovl_lookup_upper(ofs, newdentry->d_name.name, parent,
+				     newdentry->d_name.len);
+		dput(newdentry);
+		if (IS_ERR_OR_NULL(d))
+			err = d ? PTR_ERR(d) : -ENOENT;
+		else
+			return d;
 	}
 out:
 	if (err) {
-- 
2.51.0

