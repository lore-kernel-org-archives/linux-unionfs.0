Received: from mail3-164.sinamail.sina.com.cn (mail3-164.sinamail.sina.com.cn [202.108.3.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CACC2144C7
	for <linux-unionfs@vger.kernel.org>; Fri, 28 Nov 2025 06:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764312975; cv=none; b=avlHZaF/AxNhwlLX2yjI+xmf5yu/aiRpKoopD/Q2r8hOsFwMuQsnQEYEYPvuC23BKDQqR4N/rKc1Rcc+KdhMWbtALKbzE7JXCxN6nh33ROuBOr+r87q1/GrEMJqbA+ziQQa99bXAEwMyNivA1UPJ6zaCuWOJQZRTlUGqWdJB6LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764312975; c=relaxed/simple;
	bh=1ZG3147rzKf/MpmiMkOLNGaKIOpnFPvwpQP4dmLhM10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJkmCQeU4Ffw/GmpVvw/n5xppUjLp+5Ro5iq0GBnQNbqIrphXRJysBJBS3v2c117jvfgRdotfJYtFcphLscIJuq6VM/Z/OPo1GSi0OJxvamGO6lSh+rgOCW+6PJlopoBcxOx2rBBjxpKgV+jKi5OuBsHRWEuXxgU7mkyra9oIps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=WrKWBNCG; arc=none smtp.client-ip=202.108.3.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="WrKWBNCG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1764312969;
	bh=9hqMFboRXThJm8RmmDwySWiFPZsFFrgKHkWER5012bY=;
	h=From:Subject:Date:Message-ID;
	b=WrKWBNCGPG7tI5lCrmWPLIgWTmbJj0uI/dk4exEYxSEalB05+5tdej3CO7K4zfzi/
	 SNvy8NqeNXDd2+fokyJpMwHJQfuvgvP114xve0TwxJaevVwD189VeZhlo6Eh1mhW9N
	 2KSyJ3TZUgCyWIwyW2iTEMhHyHAKDIde6GSm56P8=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.32) with ESMTP
	id 69294761000074FA; Fri, 28 Nov 2025 14:55:31 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 3487464456635
X-SMAIL-UIID: 4A29E4F5F0A0487581C45017AD83C0D7-20251128-145531-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>
Cc: NeilBrown <neilb@ownmail.net>,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzkaller-bugs@googlegroups.com,
	NeilBrown <neil@brown.name>
Subject: Re: [PATCH] ovl: fail ovl_lock_rename_workdir() if either target is unhashed
Date: Fri, 28 Nov 2025 14:55:20 +0800
Message-ID: <20251128065521.9509-1-hdanton@sina.com>
In-Reply-To: <176429295510.634289.1552337113663461690@noble.neil.brown.name>
References: <6928b64f.a70a0220.d98e3.0115.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test upstream master

From: NeilBrown <neil@brown.name>

As well as checking that the parent hasn't changed after getting the
lock we need to check that the dentry hasn't been unhashed.
Otherwise we might try to rename something that has been removed.

Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/overlayfs/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f76672f2e686..82373dd1ce6e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1234,9 +1234,9 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *work,
 		goto err;
 	if (trap)
 		goto err_unlock;
-	if (work && work->d_parent != workdir)
+	if (work && (work->d_parent != workdir || d_unhashed(work)))
 		goto err_unlock;
-	if (upper && upper->d_parent != upperdir)
+	if (upper && (upper->d_parent != upperdir || d_unhashed(upper)))
 		goto err_unlock;

 	return 0;
--
2.50.0.107.gf914562f5916.dirty
