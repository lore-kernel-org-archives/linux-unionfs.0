Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972224;
	b=5fMjwvq6YBiN9KyuMzY34fXh3VfwjOajGVGd2e3mt0OrXZLodYivN6RSw8+ku4Q/jD6A
	 aETzoQ99AcwbeHOHBekIgKJg3fVstcAH1rTz/+W5rLE+KdkMEsIc3glbyAuu6NXMzxHe9
	 T9uiuEbjx3YAYKyGybHyhBHuGQkegvREPdklzHrfTRX4a/cp2orXyEoNbHhGVwlgogj8v
	 fTSb72Z7yuvTQKrv7hK3a2g/VBZ7MaB2WqyNqbvvlj5Jg5JjyQ2YnWNUvIDuUm71jKOlO
	 r/n15fGCNNwWwbC9fC3fqXsR8Sr9hYprB0woIdauE2uhAWmeuQEnzJyyvp/LO+J0aGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
	b=Xv+PMSSgwoY+YUqEYrGpco87XUKqE+IVS5UFZdV/CaVvUH75QozjvOMuaAe5CZ6FNo/L
	 PvJ7HCf+4m3CY5RSjcodFlo9VNu3u9aNy4to1+mY5ItynMELRUiQgiGJKsj8SRm7cvZOV
	 uO8/zKy5jRLYMNbh+7CDw6hyM5o/Ywlds4nReyfv6EN8uMEo0yTXSszPqRLQHQTvqjWrd
	 YMXWiwg+oEzUoIBgAVL4g6AoGEnvOJdRo39G8lGvUfRz9zuX0kPaJWgl6+Abgn+g/3iJ5
	 b0i5oqRz1OhPrVOvpmrm5NIq5c3VHmvYB976o0rW0da8rJMETGs7lzqrMqn9BODsnvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=aqvwX80A;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31DE606D804
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C31DE606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=aqvwX80A
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53381e53b80so6452911cf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972223; x=1794577023; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
        b=aqvwX80AjGRwxCjKMWgVXyvpVydMW0JPni4tQ1PkFnI19f65ijPwfSv4NDB/dmBLAZ
         sgkHMN75auCP6VUaaFF5xHO57tobC1BYLRCPYW443LRub/mtjmO7r6bSY0rrKVrQSjVA
         6BO0QajzfAHQeqYeSSh8oSaXRKi/qtKCk/3lsy31j2LdB12LgTHUGtj495OjmW6gDnNz
         SutGKU6FQtSDNsEMD243pp3zqskoVz/TO+aHkTsjCNMV8F7WTubCfQZxeYuf5Or67sEj
         NBFHxZs/R0O1jsRtTGMDD2LSo96v+AfmxnOZeJfklC7L0ydlA3DqXXam3GjdYzcx5YAE
         +IFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972223; x=1794577023;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
        b=xd4stQp2fXf06VB9OmEDfzQZNaaAoj/7+gc1Ct36Rvj5IvGZU9Wu3nrzYE33BxfSrP
         xDisp0glpQ/ZvDrdfNV75P0aBDOhPqYv8rnM5Yn8RFcZhB8LpsrhDeR/MbVkqerqwPl1
         09pm03x4PjGkAR7RTPHSxoq0C5W5C7TmvhaiCylrg5/I0GdnBQ6v27ggkJ0gs9M8ynNT
         JHOtCNIC3DVwbIWHSe0rsf/zoHe/Lx/DNIATAK/SfGdMFIeqHnJ3jvkUCrMJ2W3fU6i+
         iNivzY4lHs6CC9DvRUHybp6KMs5jqKut/SOyGgzh8ONX+no9GQ+XsIA1lUz+flK4WQim
         X8Cw==
X-Forwarded-Encrypted: i=1; AKwUvBwv4+oVGs6UxONAZROl/d9VsHxk+bCbN83uZ/DLQmUjEqVOrViNRBPvVO0FsJbgPy+oKyfIsNLcm4DQjYMo@vger.kernel.org
X-Gm-Message-State: APuU4Z8s/Mid9yPZmqMcy+ow32KqdmTWdt8c+uN5qd72CQqfc9/EIygr
	epi/PkFHEGMXZeR23Nd433Jt1HbRa9bTn1ATPcTEDMw/Xj43rbulH04ikLEEumeEd/4=
X-Gm-Gg: AYBFou21qgtihGcvq97mqjJRedAHqNs2U0nlVNTtDBAenOUklkSfQippGtkX9qlMpFH
	k41i+8TcUfMAJ5uibXuU2T3HD5mc2jq2o0QIN5tm3I57B7vFr0gBriOBPBnpR9En5xEAVcdmB/v
	DDfIu0lecGGBVEci17BvAwZO5ygzc0DBKZ+UvYPpXQrWCdgVVmgYiTtDvQ/7HSHOzv+zufrqBRl
	kjgulTUSmLNEeLZp0UZLiAXck8Ngo9cX6gtOBkxmFTrKEgTDmz69dswu0nfdkydmvivH2GCRyvt
	f9+BYj62L9hd7jjSdVBhKAqVbeMID8hnB9o5jKDC/sgDuhDdSr0qgjHLAy3hXBQlm4TH99j9quC
	K5UPYNsP8dGl1V1ospkl+C8bQauv+4osd/kk0tELFOCXKuG4IKMnjEh3sJjIVPMuLeMGiqsj84o
	KVrQP4TV6AHybldpudNEpaDp/X984TKxvTai5BgtTjCQuukocB5xJ7hGiPpQAig+z7I1FYiJLzp
	Tw9w6aBpRgg/n48qNR78wf74DshfocDhOuGA8S8s5lHb9FQDfoXF1tfsnvrACeeIPcwfYEmdrrC
	csmqVAdyVDZcnCJ0mFbzeVNkMBTrAR8UtjklF0jU8Um/zQ==
X-Received: by 2002:a05:622b:1c6:10b0:535:a5fc:3b58 with SMTP id d75a77b69052e-54e15d687f9mr29797641cf.68.1793972222579;
        Fri, 06 Nov 2026 05:37:02 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.244])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ea6a2c110sm20707636d6.7.2026.11.06.05.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:37:02 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 06 Nov 2026 13:36:44 +0000
Subject: [PATCH v4 2/8] ovl: setup overlayfs' private bdi
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
Message-Id: <20261106-b4-ovl-containerized-sync-v4-2-6ddde0b7dd8a@toxicpanda.com>
References: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
In-Reply-To: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=1000;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=oigsy1vUIPeqGe01IWwnaOrpAKAk76udNuQNtC58Mj4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QH2MMGJo3VtO/g4mpjtSeMtfHkOvY5p3MTJJt5D34LL2yuZaYjI4lVmv6voneKKUnxmg7ImbaT6
 mUv/1qHSlZgo=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Setup overlayfs' private bdi so that we can collect
overlayfs' own dirty inodes.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: only for an overlay that tracks dirty inodes]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 81da70fd53a6..22a8d4eb3b7c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1490,6 +1490,16 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 		if (!ofs->workdir)
 			sb->s_flags |= SB_RDONLY;
 
+		/*
+		 * Dirty overlay inodes go on the lists of this bdi.  fsync_mode
+		 * is final once ovl_get_workdir() has returned.
+		 */
+		if (ovl_tracks_dirty(ofs)) {
+			err = super_setup_bdi(sb);
+			if (err)
+				return err;
+		}
+
 		sb->s_stack_depth = upper_sb->s_stack_depth;
 		sb->s_time_gran = upper_sb->s_time_gran;
 	}

-- 
2.55.0

