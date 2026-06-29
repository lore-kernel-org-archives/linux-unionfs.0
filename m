Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F639A078;
	Mon, 29 Jun 2026 06:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715275; cv=none; b=iBOtiBiOduiLgDMt9n03h+fZT43t9QIlWXRY+l4aeTK+igJyfhRHNQUOh4DeA/Bq+0CIoxjEfRuY9P5yJVCho4Jlwmb4GcNCqfv0GZlBMSurXrzpki/Rbbwf9L7bj7H+yN2bNS+VWgZC4rXCjksRZ8n2bfDEJXRE9gc4zFmoZXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715275; c=relaxed/simple;
	bh=/RkF59PZPSOpnNK7H4vSewsvE7k7qKrBfk8PqJeAOGk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKRqkViBcGPwgqb74CIaErX0zyBbH7nPPQFm7q+5VWCzZR2wYpQmk/5wNDLpWULteH9FhlJ2zK+jztfzSEnjHXeNJsbj0HrVQz6//YQpkqKDbPbhpTpcYN3iZj/UHISWYG3OJNmEyfeg4A5pX8aXItlvF0Q5LkZaE6bvSKZOhE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Pf8xFVKV; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Pf8xFVKV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=82zkxaEI8uR+qMXD7gBzmQv42ToBsOivHdabU9oJF4c=;
	b=Pf8xFVKVTgAh1OLaNOb7TNQt2/emT6BLpwNHCkDXGK5Sd6+5WStQ6/kPxNR3uyF84kAjbimU5
	ibVAbAhUF+36GfePQVri0qT96uHUm/BOTvg0vlTBrl+8ABQ912GjNC5VEMWpIfE4f4W55jLbdSn
	yruVYRqvh8INTdcvZknYNcc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gpbxC48kDz1T4Jk;
	Mon, 29 Jun 2026 14:30:07 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5549F40538;
	Mon, 29 Jun 2026 14:38:55 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:55 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:54 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<bboscaccy@linux.microsoft.com>, <caixinchen1@huawei.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>,
	<lujialin4@huawei.com>
Subject: [PATCH stable/linux-5.10.y 4/7] lsm: constify the 'file' parameter in security_binder_transfer_file()
Date: Mon, 29 Jun 2026 15:06:50 +0800
Message-ID: <20260629070653.580879-5-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260629070653.580879-1-caixinchen1@huawei.com>
References: <20260629070653.580879-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200017.china.huawei.com (7.202.195.228)

From: Khadija Kamran <kamrankhadijadj@gmail.com>

[ Upstream commit 8e4672d6f902d5c4db1e87e8aa9f530149d85bc6 ]

SELinux registers the implementation for the "binder_transfer_file"
hook. Looking at the function implementation we observe that the
parameter "file" is not changing.

Mark the "file" parameter of LSM hook security_binder_transfer_file() as
"const" since it will not be changing in the LSM hook.

Signed-off-by: Khadija Kamran <kamrankhadijadj@gmail.com>
[PM: subject line whitespace fix]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 include/linux/lsm_hook_defs.h | 2 +-
 include/linux/security.h      | 4 ++--
 security/security.c           | 2 +-
 security/selinux/hooks.c      | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 35bb13ce1faf..e34b295bc15a 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -32,7 +32,7 @@ LSM_HOOK(int, 0, binder_transaction, const struct cred *from,
 LSM_HOOK(int, 0, binder_transfer_binder, const struct cred *from,
 	 const struct cred *to)
 LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
-	 const struct cred *to, struct file *file)
+	 const struct cred *to, const struct file *file)
 LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
 	 unsigned int mode)
 LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
diff --git a/include/linux/security.h b/include/linux/security.h
index 2b8a00118903..f3c9d640b60b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -264,7 +264,7 @@ int security_binder_transaction(const struct cred *from,
 int security_binder_transfer_binder(const struct cred *from,
 				    const struct cred *to);
 int security_binder_transfer_file(const struct cred *from,
-				  const struct cred *to, struct file *file);
+				  const struct cred *to, const struct file *file);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
@@ -518,7 +518,7 @@ static inline int security_binder_transfer_binder(const struct cred *from,
 
 static inline int security_binder_transfer_file(const struct cred *from,
 						const struct cred *to,
-						struct file *file)
+						const struct file *file)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 6de10b6699a4..d6b1b82094b7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -744,7 +744,7 @@ int security_binder_transfer_binder(const struct cred *from,
 }
 
 int security_binder_transfer_file(const struct cred *from,
-				  const struct cred *to, struct file *file)
+				  const struct cred *to, const struct file *file)
 {
 	return call_int_hook(binder_transfer_file, 0, from, to, file);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 90935ed3d8d8..e1bbdef0bcd3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1700,7 +1700,7 @@ static inline int file_path_has_perm(const struct cred *cred,
 }
 
 #ifdef CONFIG_BPF_SYSCALL
-static int bpf_fd_pass(struct file *file, u32 sid);
+static int bpf_fd_pass(const struct file *file, u32 sid);
 #endif
 
 /* Check whether a task can use an open file descriptor to
@@ -1972,7 +1972,7 @@ static inline u32 file_mask_to_av(int mode, int mask)
 }
 
 /* Convert a Linux file to an access vector. */
-static inline u32 file_to_av(struct file *file)
+static inline u32 file_to_av(const struct file *file)
 {
 	u32 av = 0;
 
@@ -2050,7 +2050,7 @@ static int selinux_binder_transfer_binder(const struct cred *from,
 
 static int selinux_binder_transfer_file(const struct cred *from,
 					const struct cred *to,
-					struct file *file)
+					const struct file *file)
 {
 	u32 sid = cred_sid(to);
 	struct file_security_struct *fsec = selinux_file(file);
@@ -6799,7 +6799,7 @@ static u32 bpf_map_fmode_to_av(fmode_t fmode)
  * access the bpf object and that's why we have to add this additional check in
  * selinux_file_receive and selinux_binder_transfer_files.
  */
-static int bpf_fd_pass(struct file *file, u32 sid)
+static int bpf_fd_pass(const struct file *file, u32 sid)
 {
 	struct bpf_security_struct *bpfsec;
 	struct bpf_prog *prog;
-- 
2.18.0.huawei.25

