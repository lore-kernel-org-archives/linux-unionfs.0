Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320706;
	b=NXNkO5VETr/L+4cZGGihIU3u+BofMUJCJ235SgQ+e/A5AizwUhmxHCjB2SKuRo+9aU9M
	 msZX465+PPtu5/xHLevzqG2YjEoo4krxQk6TFAYD7Ud3lhEdQC6+pTFeQMho1xKwoCdag
	 822NKPBDx+qskIEMn2hEmWMg7VLPVDkemrR+iaXjnfL9EaiIVSXnqGo9TbkoOuEd7XOgD
	 S6p3MOyE5w/L43vPOFJ7R2G19tou1wXfqCzTabarIJUAZCK000xuOId5Yv/0RxLE4YfBF
	 Hqwt5dOy+Er2IWwzZB28HOYlwbBCUeb30vo/6i9mo7vVeEyR/hAqSWXzcjVylkr+K4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320706;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
	b=zswEwfE6qa7NwrVQNSD+cr4UFEgFit7H+9FNlzdHL88wzaNxJZhNpwEcPgLMrYE4KBUf
	 yB9NSGZNqvjhzK/OTY04Ik1Ybyn1EsAMxkc00I8rMLhY9H4Lo0udp/lleXgD08vWo7dGj
	 oyEDOGl+YRZ4vKaTAxoW2FrkKKASMD5cgICSZsM72t3AJsXtH1icDz45Oih+lEYfk+kkp
	 HChygQNP/8hgIa5L0MkG+Dg6X5ixA2USSeDCAqjkFpAB7Nfv9ZG6N0IyCV4ppKOZziLg+
	 6H70mgSepkneSHG2oSW7E3MzTXQcEgFRhRRB1Al7/jFDuAnvuU32h6B/bKNdIXftvgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=KZ4ymSmw;
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BFE60A260F
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00BFE60A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=KZ4ymSmw
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91e7af9a67fso14856496d6.2
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794320705; x=1794925505; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
        b=KZ4ymSmwGQcTSEAG9tjuCzWtnNUBwSexP7mH4b7HisT1MmvhMnZkOsziIulTO8Zf3G
         pOAj8szA8/crd1BpkZnk4l7YKy1uaAaXtqsuCS6x2h2EVq2A6voMlZaZr/HuDPczmxEM
         e1J9Tp2fBo/7qkEOh0jXe345pHG+Qs3yL9m5y/SQUPLP2SMHajDlBC5OgVkAb3V0a1I4
         zwJMbbTKC3dTad5Cz267m2JvbO+C3FJmLz7UP8CHNCi7DCtNmfYtZ8byKNEPT2F9lxix
         QYd6KYHJ+qHhlAkSwLgp2vNVyBpg2+FQb1328ZtZaLXxO1mXZ+LX4+JHO2zjlFM4i3I5
         qrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320705; x=1794925505;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fsgc145zwHET8lvApLf2hA0PKAQBWP1kvOH0cyQnSe8=;
        b=LiFUf87SY1Iuv6Snb4PznadHHvP+WDufEuJgBm0DjJCI1sxrUDHdmounMNtskxNnFj
         X/+/M/gtEJfa8+ID1D/cOUqSNa+NnlZcIjCHBuB9lMoSn7NIWLo0qxMH4HdPaTteOWHK
         ZPm/HB/G562gym5rbkek95Ch6NC47O87r+8d5Vh0DFqwAie+VybvP/KWLQxHG59tFJcM
         AFZ5pjljBpOfrSp23AmEFUxKtSshpSpr86pgYv0gbmCPSJgxiNyQb+0wH/ADEkJW1bYl
         0vsDGAmXB95P0NnPBgLFvF2hwO/ZLfrTsk+8R11RgpC2D1VE+u383kzRZFZJ4I1v2cBs
         ccHA==
X-Forwarded-Encrypted: i=1; AL+hErHC/wqgVg/riHJwk2DIeLCGaM7vB0umHQMf2RCNO5V8e+hL0mhbsTDatEYl2jJBmfU5NpMSIKNkkDTct5KV@vger.kernel.org
X-Gm-Message-State: APuU4Z+WKE3mgkZIJ8bQ+B06kVZcOlRBiGfnQsE3Latj0gBeKIIUzzk7
	Eu2zaaJqgYFA69LDNA3MD0aKAdmn6vQuwzdUXdZBf8l8GY7ZlRv4nAapUPSfaejUhUw=
X-Gm-Gg: AYBFou1RioSsDQUjBiyyr1Qa94O/1Bx2FZpuWST+S92sInwulom5VVUozCgzLEOLY07
	QGsfbf+SRXt0dQwGY793KVa0qOrNzQNJADtHAiFvuVozEBb5B2v8m8UaYBXvnAONvQxj8fuQj9D
	j7JfQTo9szUO5ZJKvom8yos+71lyNdblvNqs/f7ZnYQjySVOskvqeHYXOcIbXhecCFBVPyFFz1v
	c6jxI/jzPPwLyHyfuDukeNrPBBsmUtvcYgX4l4gfS29v6h/YrSGAavR5TK/7pWdQelg/NvMs2Fq
	IzhKJ61i0mGq9nioaTHMpxNc9n3okGgIlbc3vCTmWUOI+Ljk44prCeivu8PDXqE/tY7JFU0gQn6
	4sojat6UwuDSWcM/KxvbPbUTHI60A4OpV56z61uP2rlOh5P4Qt30BiDj4gFGessyvki4IMDNL43
	EWi9fA2P4UbRnLmDpiEBYSTS3Q44xmGHSErOGODJyZQKDxApnFY/DbSOjzylDG71tIWMnrRiBPa
	9WOB+S5tHinRFeOVEP7zy8jcqyamjPFamDbCmy3S8PY9PM6KRqhaTLrWLxkF+axGFqHNlm8YdZH
	1rWnhbem5MfEcByZkhPVeSVuam+qCeUqxrKZlijB89YiXQ==
X-Received: by 2002:a05:6214:1d0c:b0:91e:b7fd:b35f with SMTP id 6a1803df08f44-91eef8e19d0mr46530126d6.30.1794320704691;
        Tue, 10 Nov 2026 06:25:04 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04fb5c9sm22263976d6.24.2026.11.10.06.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:25:04 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 10 Nov 2026 14:24:51 +0000
Subject: [PATCH v6 3/9] ovl: setup overlayfs' private bdi
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
Message-Id: <20261110-b4-ovl-containerized-sync-v6-3-43d1be16a4d6@toxicpanda.com>
References: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
In-Reply-To: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794320698; l=1000;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=oigsy1vUIPeqGe01IWwnaOrpAKAk76udNuQNtC58Mj4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QM6Qi2Z/vttC+ismRUqZpKJCnEVi+EA1CDQav1wZ91mZcSHpYI4N/AGPLItarZUhdimNLf1Xgkv
 0yxrYcudV1gQ=
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

