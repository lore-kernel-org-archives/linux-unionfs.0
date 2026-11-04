Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825126;
	b=ftWuHcBj6PCsM4oCYv3Dszb33xLXc59HT8Ci7hJGJICNkeJhJbltzhMmjCcftlY3eFcP
	 1lbWLNld8RsTA+hI8fbjni4yAwtAhFzth++1C+nnIaXv+H0csUj4AF9jmD451HcB3uAya
	 6AmW4PzAJeAu3Tr2nphPehInsFYR1cIkefM1bCLvaMk749GjH9us1rGtbZZalK7a1JyTv
	 o1/pfwVFx0Xf+JmbXt6Va1zeuRu8gswaV9njdlicQkToPZkCxBnkJoCVwE7/SvZ78ccJ+
	 NTaDnr4yDgY6v18B8dWRpQpN2zltOJDyTMpqGkfDJz6DwXSVkgD5GsNbhz4JESVqPLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=jwxSG6kxNQXfd3MBU5TUyTIg6qqJuNYboB40oYoca/M=;
	b=yjvFYOD5FVAABrlsUPF5UEeheX1bbWhdR3e3XYY1jZARP91x7j/HIbvCmHBS6qY8wEa0
	 qdEhkRc8jFX1SLNMiXzgMDHLQqQCkI2WjdEoR9whfRNvz81YUjxg5HQ7tC5F6fpr41aYX
	 EYrzT0eGLGFqVHq65mUMmyeHYDvaXMSWvQQMEmW/OiYh3yRPEFbL1X9WOeFyzEGOealWv
	 Ka9L14H+naKhgR71bPoQ19wf9BW0LtCaqMU/KWDgyYgyOoz2OalPIDh2+oa+3KPQ7FmRe
	 Ve4kV4xbli0CEUCcJjKiw7Wg3q5XWGUJHaAn4bFbGX1lKAerASwret5buBd0075lO/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=ph5nNQSJ;
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D926083632
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 20:45:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2D926083632
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=ph5nNQSJ
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91c1f548f87so18160016d6.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 12:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793825125; x=1794429925; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jwxSG6kxNQXfd3MBU5TUyTIg6qqJuNYboB40oYoca/M=;
        b=ph5nNQSJNGhkwuPhD372JTXVjIV7yjnkzaElKB7gmlzAF3Ru8ismasdmKNc7H0L/Cs
         x5iV/ymbCytrpEdEX7bDMTBkdvA0h4aTfeZZCLYkjD9NyLOuYTj1wztps6dOYNo7wfwg
         mD4COroq6ETwLR1JjKQglPUJ/k26dp0teLWc0UHAXIfFU3U+LFZ2df6PjnHFY4L4JVNS
         m/kpQ5gVqWmPPEltXNbfNQIBU+h24CnvgQjVD/WwxvEBSGX1kw7MnHlkdejewxlyPGq6
         +Oq4CBjyUG2qNdVqeQ4yBY5uHTdH+smO819Ccl4VEzhthqfvbKgFX20I5rkjjsbs0qBS
         vWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825125; x=1794429925;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jwxSG6kxNQXfd3MBU5TUyTIg6qqJuNYboB40oYoca/M=;
        b=yDI32w6vlhcyfL7FOJvnxpYRabt2f8nt9dR28RRDgI8FM7vn457ERxCkgs5wuK4991
         7FmmFAk/WH9GlVTv41RD5obhAGXFfgwYnr09No/bWjoX0X/iWzaNyqq2NI6B05wl/hzg
         gMmYw/gJQVV+XtXeulemaGreZSPD0KHUXG2iWS4YzNr1nhjgr4Utkl6VIA17CXfi+rzp
         QWvlAr/I2huHk4aPL7mla0f8iY6eaDB7LShsEvGL0qaG+ev6A9hXaWlMJjMyC4i5132s
         CilUYnA7avLSs6glz93uKadarWT4D2PNL+gFxdJhpcypWvgSOJonNCGjKC4iriGOfeAY
         9wWw==
X-Forwarded-Encrypted: i=1; AKwUvBwoQrczFVNgZQwkmcmyL+tnytfzhZkly+lUX13Bhar8yIe+mfF9hWM0WdYNWjdlrwm4YO5K1+qd5gWmZh2T@vger.kernel.org
X-Gm-Message-State: APuU4Z88oxbPihzSw/k3dyTtv+A8sToYdq3QjClvE/WGkm6Dm4pvRmhg
	sDfT5Z9M3/zMfDLRvs6784gltWxHox4QVjt4em0+t3Mj0BL/r+7Zos6+JZAF8bdFWhY=
X-Gm-Gg: AYBFou0pVodD43ST5AC4TxtEGsAbraoN+uC5P1hS0yqT+w5L6lFpp/ty5bZgcKkk9nt
	vAA2ABQyIPpuMvu1EphXl1aWhbh/ex8RvKxHHiHFWHDcWTInlk6n6ghd6LmXQ81rFRxIOSM/dLQ
	mPQtyv0RfS5v8Qnt4PEQWNaQO64Qe8vZhLrF7ABAbD5ow31SGmzadYahvPg8qzipDRE1BTvcLkj
	GRgectcnMvWDXViHUNtoDbIEbGTlilQQh2kIHSk2jopWGr8e+RQtDjEYHNzGP8fUtnkDe0FaUeS
	w4/LQyVqzcVjGgzsZyyInZL5pWYDBmd7sBiuauxsMMSFFXvllLov550bV1YTKiO7gMjBqdMoA8E
	TiZEm60eAkZY7adA9Hln0+e4etuxHFVNQrx3BpB3ECTpiH8pJ9dOHZ27lS+h7MpVrBpaRufh+7c
	QTrmJHnaAwjPhzhchvKRId/CfTgWP10KOyoOwsTzWbz7FOGKg7aVYfsUfoKnM4O0I7tXt8WWD2a
	XrnOMqfICEPsi8eyfZZlraXWg4rWrAAgy3VwxsqI/EfcG9lEBMlMgkF3H5i/ulaIERzQJLH5UE+
	k4a2kp3i8sNlrxVcOD9s8qFaVFMeJuhE/s5g2npLW94Kjw==
X-Received: by 2002:a05:6214:5504:b0:91e:7f01:f95a with SMTP id 6a1803df08f44-91e7f0200b4mr45796446d6.46.1793825124629;
        Wed, 04 Nov 2026 12:45:24 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7e76a9c8sm28500416d6.40.2026.11.04.12.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:45:24 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 04 Nov 2026 20:45:03 +0000
Subject: [PATCH v3 6/8] ovl: cache dirty overlayfs' inode
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
Message-Id: <20261104-b4-ovl-containerized-sync-v3-6-8daa20144f53@toxicpanda.com>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793825112; l=1773;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=Fb/8suIHH0v3scMIhqAM6fg69jtShxcacWyi5TFUHZA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGdUBvUWtNGstE1DzXnIADs8qyDyHOogJZqYtkTAGjfXl8ErwjvmPk6vrDGBONd2cS1RDBTY9zK
 qQz2aLRS+kAo=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <cgxu519@mykernel.net>

Now drop overlayfs' inode will sync dirty data,
so we change to only drop clean inode.

The purpose of doing this is to keep compatible
behavior with before because without this change
dropping overlayfs inode will not trigger syncing
of underlying dirty inode.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
[josef: also keep an inode that is under writeback, rebase]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c1bd70972519..fe626e9d78a8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -387,11 +387,27 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return ret;
 }
 
+/*
+ * In iput_final(), clean inode will drop directly and dirty inode will
+ * keep in the cache until write back to sync dirty data then add to lru
+ * list to wait reclaim.
+ *
+ * An inode under writeback has had its dirty flags cleared, and only I_SYNC
+ * pins it.  Such an inode is not clean.  ovl_write_inode() may be about to mark
+ * it dirty again, and marking an inode dirty that is being freed has no effect.
+ */
+static int ovl_drop_inode(struct inode *inode)
+{
+	if (!(inode_state_read(inode) & (I_DIRTY_ALL | I_SYNC)))
+		return 1;
+	return inode_generic_drop(inode);
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.free_inode	= ovl_free_inode,
 	.destroy_inode	= ovl_destroy_inode,
-	.drop_inode	= inode_just_drop,
+	.drop_inode	= ovl_drop_inode,
 	.put_super	= ovl_put_super,
 	.write_inode	= ovl_write_inode,
 	.sync_fs	= ovl_sync_fs,

-- 
2.55.0

