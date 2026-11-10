Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320711;
	b=vujYvU11RyRijI+HF3rr95DOu8278q8i/DbpcYalbuRAC1qYBaRwngTAHVV0ziM0ETqj
	 FMu+Um8h7GiAfpiuBbGY85JcTNcEO6kNLYdl5zSzPlyfW4n2uF1qZ31y68yZCFqtmzsa9
	 0XbvrFxFDTf1Z5RN65iFo4gTJTMk3ZLwoX90JfiKfSCtyUp6AzqEwiq2lAAX2AujZm2mm
	 aE9tLbRwyovJAvAsJkCnGk0GnIBlhmQpJMFiE8OIQMHoNOG070fNjZC3ua4FPjBVuZ1fm
	 yEunmzIB5aC338FpVWhg3fxk1jwb0uDxzzdgewTH7BWhhhmfV1r286n2aql7KLCsrcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320711;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=8zerBigyv9mmzg2Gjo9e2dqqPP6k5FgIy3HAg56oVSI=;
	b=nr0pl80mBXxC2Uyju4Tcn0s7gvojaEOGgE9ME+FWtbG8hH76v4uy9C0kqGPjJ5Kl08LW
	 BZPd7usx7c+SDnWxIo6JSRrMmuhlgJpJjNMsQdBGA29ZeeZuAqeqobKoCj99VmkKqsx4J
	 k8CPQMk8GLBkLDL56VVKYwHUNkQCygntRl3XTBvcn2OjN5qd2Kpxs0NOE67iTg6iTK08Z
	 Am87InlPEAYZrPWhkwUio0Nfqz90SEy+65wpcZmtZrgOZFnglsq8IBra8znClcB+uGoLP
	 znPt7R46ht7fqgFhxr1wSMImFk3QlHnu1yYVLPkWeY229lZ7uxrAbPjFsAAQWPn8bXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b="gMvp/4tH";
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAADD60A6F6A
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAADD60A6F6A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=gMvp/4tH
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f3c8958d5so235730585a.2
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794320710; x=1794925510; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8zerBigyv9mmzg2Gjo9e2dqqPP6k5FgIy3HAg56oVSI=;
        b=gMvp/4tHZPlWdcSsmWMjI/yNPB0fufeNNrLxVB2i4TwxZDREnjr76w0+nPjrm5vLwi
         D73U8xUzIq7iEeAKifVdrzICeIAZdmR90LYDol0kkboU4Aoy5mGJrVTiVLiOdLoq3Wk6
         z11Vdty7lHJiMDF9CZE/Y4eDs7V95i2wlK0hFrVqxS1vt01ZGWaMGd+o4DwQvtetE0J2
         xDtw8BsuPSAXvc/I08lkJ5DVlSoLJvDOoV1MJi3nE80CTivTmhXDGtZrJeBUGPHFavOV
         9lg8sPSkdFYX/+uMFzqAafvq4RVusxDTbiD+McY56ltl3YmQ4W+ZAQkie9X5/E/v2Axf
         +7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320710; x=1794925510;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zerBigyv9mmzg2Gjo9e2dqqPP6k5FgIy3HAg56oVSI=;
        b=O4Vm38PV2a4/RpbQr1Pb6QVtpSgmDvNT0rVqQl3TYIEZj5VoKdrrX1Sn2gDtw2oWAj
         n+sq9eLCJ0ndA5+hXdFNdMNjEgZzaOGYVsznAe0eB3t/v5o6wAKQlGvNC0hJ64SCLBEl
         r55ckbOpXgfcAIFRNzJjQY7gkcGkyfeMb1SeTuS/XDqn1dJMTU8eChobrEmoqkefdxO5
         A8myYRduMFeuYTbY62C3k6EW/EkJFieX3Rg2W/srG6aMIf6S7tQA2iRXZ0qYkHlEsUXi
         e2gWBIegzltKKgus8r6AIlptfNJc5urbxvG36GtOtJ0J1pNN6V2sN+fz1O9F3ZdTkGkv
         147w==
X-Forwarded-Encrypted: i=1; AL+hErGuxwkG/YKl5KEFEgq+Lrhxbr5PPU7rsQuyH1/0jkC4Mkm0SHb07ndaJkSD9iFt3Yx4Z4Z+9hra+revKJOB@vger.kernel.org
X-Gm-Message-State: APuU4Z9hQUMiFXNrBR/vKX5nwSH1bjvrQDdhEzjYUMxv3eKbODlUkiNx
	faSGQ+8RJi7hxC5g2YBmjsQjibTXKtsa/ictJAnSnC/MuVOu76BHZSWZ6mBF1SGblDRkE8A8qBn
	P2ndWbY4=
X-Gm-Gg: AYBFou0e9Pfw6AbVd5kCEfP8rouKiN4GYhvx1r/wTr2Knr/EmS/0xJ6OYATvyfC5HMZ
	w4yoSD/PM45jtvzbifJdLZ345vRtaZwTFG366wp27+e3hCrg+Z/QiWtSRWjitRnVNqnSmG6io6v
	Q+o60+TlBj46oZtZn1qVeBASjMvGzbk76wYePvwj065nTVl6ASvvuWMbhuk/T3B4By1nXty7Fac
	bPJ6u/Z7vZTIrcAAfj30jQ8c1jjk1opuSaZKMjWzBmnqPXyZqzKjl8T1EaMZBpKEYQsI9Wexc3D
	8+AgGqQpq44Xis/j9B5ypw7jCA5yEfEDYPuXdn4uZBVIe6GTMksohSGoamgiL60VgrYrsTbl/eS
	4UBJO5RH9FO7Ass+Us+wtJk7op2V5P+q2/4/29L/J3aVT7l5Bgh6pWh4ax174S0saDOiN0zAxkQ
	5yaCGgUWuxipy7GsSEHPCfaxrfS26TL23It196j8vundfzwJZJrnu/0eUHN48P/MZ1yzFt9QS5u
	PG8pY8QMTCcfzPdovh3MG4456McZVROnvEhQ61x0SzoDJdHHL6H6GocMYEAtusglcdfKTL9riyy
	mvEpiG5QU+SHj5PNCzDHFt8PyzqSZCkjofdKxfdPpES0a5Bv1AUlckAjkTA/D1GRnSQ=
X-Received: by 2002:a05:620a:45ac:b0:943:faab:a149 with SMTP id af79cd13be357-9479f38f7d8mr474237285a.63.1794320709592;
        Tue, 10 Nov 2026 06:25:09 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e770d7csm235081585a.17.2026.11.10.06.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:25:08 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 10 Nov 2026 14:24:54 +0000
Subject: [PATCH v6 6/9] ovl: cache dirty overlayfs' inode
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
Message-Id: <20261110-b4-ovl-containerized-sync-v6-6-43d1be16a4d6@toxicpanda.com>
References: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
In-Reply-To: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794320698; l=1773;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=4vtTge6/ThBXumR/B3MN7k2/gMZpZtKv00zfzARf7Uc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHMUwCVvUHJZIqDJQPoatfq/63xIDsZ7l1dryd7bHmkdczxNnDK72RycPGk1V0k6C1rUbAWZrUU
 LCp+SndZgEg0=
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
index 41d0d37accda..ccfbaf9d8797 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -388,11 +388,27 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
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

