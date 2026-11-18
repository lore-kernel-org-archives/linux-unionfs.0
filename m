Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021418;
	b=1HxABtb/mwd1LHNMoOdukVHvjUFDwqw6ywtBzDGk8BiC8CMnP3p+RhWwUvuf2o2dekKx
	 bcOSPLBZJmcCSRU11UQHiBWG6uhGJGIEK6gXRkEbCgAkffgfiM3dxHdfoFcknS1zz/urg
	 /FUqBtLIiTESqPD3hxLO4G8YKhVAuFrwZNLQ4ufiyG3h2IBn+MSvrT8oCrQjBZ00r2xnK
	 zoZvGRsBXmMbyDyJbV9YcYY/QX8mBkKbN/nK+DLnAh6QVhAZeOnMmb6z/EU++yC1C6AbM
	 ZZuPHx9HkibHhwSGsv6Aw9rSdcst3h+pOv6d4vn02F6rDakIDTmQDhGOAmn4f1k7qiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021418;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Nz+IbEOviOWTqeWPFaSKYQFDDLKcLrIMVLmfi5/eTq8=;
	b=3HcmK8uBEOgjiX519q0a3Xi1fVd4nEZVOq15RPx5IN8anwBKfnCbI499Scwt8KTAcimf
	 MUOIWeESBsrLaqgPtsSbpCZ617WHfYZri6dAXeqJ51BEOncf1LFCXHxYnwglnJMXM5Gzn
	 UPQ9URD4We+UrQoBmFHJw4SiugbDPMF8gdFVXA1TMNjDz+o4/BCjx3he3+Bx+9pxqNpNe
	 AIncuqjtt6sB61yC8izectc/kmBBynAr3joFE+2zqxzp6FNdx62PyMtMFf5O403AcLctU
	 YcXfyscUeoigJFzE3sUeoNYGKfdhLi7oAOpwgidtkDDbCgZMSrXOlSBdcLOx5UrS7Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=RYYnDKjb;
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749C060A2605
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 17:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 749C060A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=RYYnDKjb
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91eb46044c4so14452876d6.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 09:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021417; x=1795626217; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nz+IbEOviOWTqeWPFaSKYQFDDLKcLrIMVLmfi5/eTq8=;
        b=RYYnDKjbnXwVVfMkR5rVpzsoay5v4fYowEr/xrIsozOndFgoJNMKNlazBBG6+xaKuo
         f2M20sHVniTYaHovrJM/58OydmMRkDa5lRJn4+UqyZ/FIrvrTfHG+Fe0gOgRK5b7NqjK
         T+kLa1Tf0qgl3MefkW6gWFQPwTQLJyi7Qp8g6OAHCM1eUelx04VXcqkcxfG872OxIQO6
         oUt5pQm7OyO/2VIJ5ioD4kuvOL1AjQnr0sQy/D3oyoUGu/VfUPJkdJGdXcU0io9hTTi0
         8BvVpkSBN9qM/z3grPj+rrMzAtQSZsjnwBwUoyWmhL63qjG8oCQaEaoy0ApGCGQmgXAN
         kpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021417; x=1795626217;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nz+IbEOviOWTqeWPFaSKYQFDDLKcLrIMVLmfi5/eTq8=;
        b=ulBOovssTIENwFeERPc0+JEeBC5n7sLta863vZnP9XXMcQXyx861WpAph6D9F8QUPh
         wolm0IyELRpjzcgsS62jPOkBytozbRWIx7gYqK8tuhel99iGrG9hLKHWFOxY2NMXZHks
         P5RAQ3U+k6uCLUDbFdMbRt1xpUR10yCzdvIH2gGhVFNOJNNJPoCtO4ey7RiqqWaF5/Wh
         pmSyGRXTTJ6/rP9E52OwnSJvtAYGBTVMZXZRxJigdTQ8Fw6FjJX1ET/vm5yCBq4wrRG1
         gAVNB11QPUcBVK3ABcOORq8rgGxGg6WCZX4TIOJ/pKmX5Z4V5Uk702WxxHhD1uQGwyal
         oX/A==
X-Forwarded-Encrypted: i=1; AL+hErGuEBS/bD9NG/aolashhkUlxRu0VRB68c6uCdF4UARYdTwP4fNzE33gxFU2mcTfMF3QzPAg+tmB6uTOPphJ@vger.kernel.org
X-Gm-Message-State: APuU4Z+4BneHANbzNLSHXj3FLWl0YCp+6jVYwBhBHRa2NRjkC46iul8F
	787eQVerc8Pd40gqV3daiQXYUeR5wR84ncHWiGxk959nVg8aIY2EZSwE8+WDyb3Q5Ac=
X-Gm-Gg: AZFdTZeZ6nD1jx+JDI24czggczthRTMKR2XuOqj9vDzp+Zis+Og3xB+t4XgLiywCL0s
	w8wcLBL0lsesuwMwRp1OlFOJx52lvMdK+Rwh/rgahwmt9HkoZ1txDNJ/McSWev3T3m38ACboHbs
	CESezGIT9dU6WcFYDfCJZv/RkmzfNrmNUA2U96dwGeOMJ4sVjWXjg97tIXk0GPJHURM6BHJnIrN
	ZmKGDvCX+/RF26AstnC85Aab6rs3sMYmyG3nCI4zb0ulhOhiUuySyJ950biSD70E6zpQxCGIhLG
	xPnOkfHw7NhJVEOQayr8P1bw8TSrrSE58FrS7rTWPGlrjaBVPv+1ilIqFOvDKkEBJHNS24F1lfh
	2V4KTHUTw2UfZLXsCd1nKNhTYse6SP85ioFi20clEPS7IFYolVF6N9QjpjSys1tICB13A0YHxCG
	nYfadlHsTy4Tdf1jZ2nvBnCmEQFBFqH2VOoUyeUih0Yjq+V7YywWjOKMAS1yD2APbUVW0rANdFU
	v/LfJ0B5BcJ/Gd42Ao2ft1eWiZ/vq++EXJ9a/PsYnPpA+tT4oLQKqRgKiaMF64Hu/SbCN5MAi7K
	sIvH4O6Q8Pz3FjRb+p0FRxeQ9/Z5tJGfOJ+iAxXdmx0XgfI=
X-Received: by 2002:ad4:5f0d:0:b0:91e:dde3:f213 with SMTP id 6a1803df08f44-92114f6e1a2mr51313906d6.40.1795021417403;
        Wed, 18 Nov 2026 09:03:37 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d16bafsm26217506d6.7.2026.11.18.09.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:03:36 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:03:25 +0000
Subject: [PATCH v7 2/7] ovl: no fsync=relaxed without data integrity
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-ovl-containerized-sync-v7-2-54f45743fe55@toxicpanda.com>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
In-Reply-To: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021413; l=2797;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=m/J0LFSWS2GOFbjFlPJg5ev3Pv5YOtwv52o2fbrDkrM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJaASzyDcz8eRSVN5bIxFtETYxlSP6hrDkAbw4w7+PorJtI2UWASNywIzy1ye/L726ylFajsmAi
 bP6pwRVuy1ww=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

A sync does not wait for a filesystem with SB_I_NO_DATA_INTEGRITY, which is
fuse, so that a server that does not answer cannot block it.

With fsync=relaxed, syncfs() and unmount of the overlay are going to write
the upper inodes one by one and wait for each.  fuse_write_inode() waits
for the server whatever the sync mode is, so they would wait for the
server once for every inode.

Do not resolve fsync=auto to fsync=relaxed on such an upper filesystem, and
fall back to fsync=on if fsync=relaxed was asked for.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 Documentation/filesystems/overlayfs.rst |  4 ++++
 fs/overlayfs/super.c                    | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 1a59500834a1..8a007fbc5257 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -870,6 +870,10 @@ The default is "fsync=on" instead of "fsync=auto" with the module option
 "fsync_auto=N" or with the kernel config option
 CONFIG_OVERLAY_FS_FSYNC_AUTO=n.
 
+An upper filesystem that cannot guarantee data persistence on sync (fuse)
+does not get "fsync=relaxed".  "fsync=auto" means "fsync=on" there, and
+"fsync=relaxed" falls back to it.
+
 If the upper filesystem has no writeback (e.g. tmpfs), a non-default mode
 falls back to "fsync=off".
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5960974c5af2..31a58e28968c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -765,7 +765,8 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	/* fsync=auto that is not resolved to fsync=relaxed means fsync=on */
 	if (ofs->config.fsync_mode == OVL_FSYNC_AUTO && rename_whiteout &&
-	    mnt->mnt_sb->s_bdi != &noop_backing_dev_info)
+	    mnt->mnt_sb->s_bdi != &noop_backing_dev_info &&
+	    !(mnt->mnt_sb->s_iflags & SB_I_NO_DATA_INTEGRITY))
 		ofs->config.fsync_mode = OVL_FSYNC_RELAXED;
 
 	/*
@@ -1499,6 +1500,16 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 			ofs->config.fsync_mode = OVL_FSYNC_OFF;
 		}
 
+		/*
+		 * A sync does not wait for such an upper fs, whose server may
+		 * not answer.  A relaxed overlay waits for each upper inode.
+		 */
+		if ((upper_sb->s_iflags & SB_I_NO_DATA_INTEGRITY) &&
+		    ofs->config.fsync_mode == OVL_FSYNC_RELAXED) {
+			pr_warn("upper fs does not guarantee data integrity, falling back to fsync=on.\n");
+			ofs->config.fsync_mode = OVL_FSYNC_ON;
+		}
+
 		if (!ovl_should_sync(ofs)) {
 			ofs->errseq = errseq_sample(&upper_sb->s_wb_err);
 			if (errseq_check(&upper_sb->s_wb_err, ofs->errseq)) {

-- 
2.55.0

