Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818382;
	b=SFjSKm+7M592r2TsmRSqou3WzmJGs2WFihXPjIMHMPmvyuWpX1xcJr8YdMP+TXZImVC9
	 yZgskdsfG6Zc1m8A2+DQMfo+POAhEDQleYW4R8eXMD/64wEdBoMDm+iBePOtZjgQsXm3d
	 BuXbBlM255GrOrplRv/7kKltU580wzYFMw958b6Q7L+GpziWnj95Je8tMTglPSzdEhAsx
	 8Vd+GpO4l268nDIQzHSMZHIizM+zZI2xlpbqmbZpmvQwsxQdpzq/fIbC73jPp45PFd5sj
	 +Frvj/iKwWGz6CUlfnMLbdNtBcewQjZ2q+mFa9RyAl/TeaNLtSWijnmH0jhRQaBD8AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818382;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OmaFlDn2sHp0SZU86PB8+jcQio5Xj+DXOedzLAfLnHo=;
	b=cOYsYLWFfMo3VnKPHDUMSZO7V3Zth7FbwwBIwyGV3TNzjfFQ5NAnl3TFlOxuHU1sB+pg
	 8aCq4KLOthM7Gmzzq5W6FuUnW/FmCRV4KOcPD5Xzfi/soHl4El1iX/yDPLuEKYswoA5ke
	 5isrbKWD4EA0q13F8yWL3jS2zBZjQrfc17s8PHMPqeNxSeFz/n2lp4MstNJ1qbcoSksiq
	 9/fH534DUHqdp1kgNGb3xrhpkg0TJnjVtxseCfp0IVssB5GoLRmjIVyOXzAXojweDHYn1
	 lltiwoG13GBOL2fiDdJCDHnuSomaPXFWOIvUqmrBjJJPAMZ/drC+lePhKOLQTad5KNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sjax4tUm;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB17606A33E
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FB17606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sjax4tUm
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e6eb21a8fso515110f8f.1
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818380; x=1794423180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OmaFlDn2sHp0SZU86PB8+jcQio5Xj+DXOedzLAfLnHo=;
        b=Sjax4tUmoiCFgJwc4obaEFuvYCQEL15OoDjnDXA3D3ky9A2oreEGuvZ3H6TiqDnvZ6
         vn/m5INuhxVps+VpiJzK8oxQNHYH7A99lKYssfVXkojlUqocFQDK8XdQUMYFNUKHWlhg
         oC8F354EODiJyBv4jMPmAmitBHznyZnDD712gnW6ssWh7noDOy8KQcghRhOUCsknsyp2
         8fvOu2rPxbGICMjUhOwVnk+OY90jMwVuyCM28Dr632a3tPJd3hgnrKBUTMa5venkM1Ie
         vCsrYIc5ck7VBW7nezM7moOZSgFug/SGK5K5IhdKoRVMBSrzmrpBqjiOwEAStszxRBK4
         y5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818380; x=1794423180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OmaFlDn2sHp0SZU86PB8+jcQio5Xj+DXOedzLAfLnHo=;
        b=yOI14iHcGLatxeFz1tYDsZwjSDrA9kXTJfnrcCwXOfSPS6u2nlY6K8IMMFeKpzc2eu
         7gs4nUq6vBXQnLGnIB+wi/Keo+ZzfX5eekSsfyKQPN5UuQmQTRrFPuUJYi+esdglnd5n
         EMgKvn3gvqJw4K+5JnhgSprmDGB1J2erIWAit0hoy9PYMjyVMCf4fu4owyy0QPKRrRov
         c68eOGACobYtiZk9uHQgtuym/t0i5DXPsTVL14n6B86BUo2FQw13Ga2x/80wNHYPnE0V
         SIfPEgkZt6Y5rGGkSMNRPhTdCt8BJNjNgwgyFeaaMhdsKBjBcx3Q6arG5zgg3bduf54y
         RcIg==
X-Forwarded-Encrypted: i=1; AKwUvBz1i0lbbOtLEZddzzRDxi/1J3cAH4ZbQJtWb4JjO9W9dEBOibtsvtd4eaG4QgXoFDrRwl+aYyOthbm0IAKk@vger.kernel.org
X-Gm-Message-State: APuU4Z+aFLq4ElUsqK49lm1ElExlGVpQdqKUqNMvYhn6/QQUJK/WQG46
	fp08mFZtvo1aiZRp5ZCqP8QpPGSEkfQnKbUzOtkNK1vdzHVcXAJcPSTtjB8d/kXC
X-Gm-Gg: AYBFou23ZTUYMDehHjmUvBB9lhNZXQRQC/MurwgO8r+6wyWbTJlY39z3sVw3WGN8FgF
	LAgM3l+2uFfItugPa3656375QuOI8EKNdDJ8AO4WGAG0z+rS7Y4JigRWseq60mx1z/x0ePbuxP6
	G/Jj2avUE8VSbu0egbJd5vx6RJmZyKaqoNLicGOCJv6FX7f7KH4ep/7sLFvCE3O++QS3WluD4cC
	CsOlktLMU1Tm17bBapxp6qMQBjnXXwCewssQXRGYVq00/LaVy/oB3tfc1ZmtgcW5/29V63GudoU
	d4YfoKC2k10GBhCkH2I36WGt+pIEN5XgMHjddxOYXaeOO7kah2Y92huCs5E/6R+hu2iLmH+0YG/
	ZXmjCFc3YF9l8negML5rGy4FVlQfN0533SRCMCtVAirr7RDobb9ACSM0MA4NJJNZBIsKe2J4E0m
	h/NL2qXCOb6rsftRrrcc8rx8L9dchfDJwOl2xsPQqlCZZQ6TSCejEDQIkHi0azXLXfEkcsipssX
	Wwv7OODJOTte/dupDrNHiwRtAT0ogWVQoyyga6HW8tSeOOB5i9/uZoSRfA0+6lgkPt0NCFBCnhH
	XHsst/jQ5rYMQl8x/XGkNLFWz2o0hk/uOno/axs1YbZzjMR5iEn9gazO6r3ApoSWVMtXgZVExwK
	OpBcLfeL4L3U=
X-Received: by 2002:a05:6000:1887:b0:48e:d36:77 with SMTP id ffacd0b85a97d-48e6e2bc062mr43452882f8f.4.1793818380008;
        Wed, 04 Nov 2026 10:53:00 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fece99d67sm5366943f8f.24.2026.11.04.10.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:52:59 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Disha Goel <disgoel@linux.ibm.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18] ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN
Date: Wed,  4 Nov 2026 19:52:58 +0100
Message-ID: <20261104185258.3630916-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 333ad304d4794d6384087ea7fc16e58ab642809b upstream.

When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
"override_creds"), overlayfs saves those restricted credentials in
ofs->creator_cred. ovl_fill_super() then wraps the entire mount setup in
with_ovl_creds(), switching to those restricted credentials for the
duration.

Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
against current credentials. With restricted credentials active, this
check fails with -EPERM even though the task issuing
FSCONFIG_CMD_CREATE is fully privileged.

Use the mounter's real credentials only for cloning the private layer
mounts. Keep all other backing filesystem operations during mount setup
under the stashed credentials.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
Closes: https://lore.kernel.org/linux-unionfs/20260924112858.51392-1-disgoel@linux.ibm.com
Fixes: c28f922c9dcee ("clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: 6.18 has no scoped_with_creds(), use scoped_class(override_creds)]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -498,6 +498,20 @@ static int ovl_report_in_use(struct ovl_
 	}
 }
 
+/*
+ * clone_private_mount() checks CAP_SYS_ADMIN in current->cred.
+ * ovl_fill_super() runs under the stashed creator cred, which
+ * override_creds may have dropped.
+ * The task that issued FSCONFIG_CMD_CREATE is still current->real_cred, so
+ * use that only for the clone. creator_cred stays in effect for every other
+ * backing-fs operation.
+ */
+static struct vfsmount *ovl_clone_private_mount(const struct path *path)
+{
+	scoped_class(override_creds, cred, current_real_cred())
+		return clone_private_mount(path);
+}
+
 static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 			 struct ovl_layer *upper_layer,
 			 const struct path *upperpath)
@@ -521,7 +535,7 @@ static int ovl_get_upper(struct super_bl
 	if (err)
 		goto out;
 
-	upper_mnt = clone_private_mount(upperpath);
+	upper_mnt = ovl_clone_private_mount(upperpath);
 	err = PTR_ERR(upper_mnt);
 	if (IS_ERR(upper_mnt)) {
 		pr_err("failed to clone upperpath\n");
@@ -1094,7 +1108,7 @@ static int ovl_get_layers(struct super_b
 			}
 		}
 
-		mnt = clone_private_mount(&l->path);
+		mnt = ovl_clone_private_mount(&l->path);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("failed to clone lowerpath\n");
-- 
backport

