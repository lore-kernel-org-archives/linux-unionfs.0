Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135389;
	b=oj5f77nucTpVpxi0wK6BmDtqsml/P5kZ+Cw9pG2nRkveyXOL765vQyR6kXapIIkY2Vgo
	 j4Ba/fRWO15KUa0eelwS7+ttzMPPYrEMHlYMa9xrh2Lo2rhsaqBScNz6oq+ar4nb8ffda
	 OgnZeaDqsYcaDXxyOJh6GmlS2alyblofGZuS7P9NJiCXfIbxnBRcdUAow2VliRoUjlbEt
	 IrvH7Bntf5mTIX83EjgY/MwrNMT3JqPFzbX5ssdjM14ySr75tJgBHRpnSJBCHMPnYtbVL
	 oaJ+XyhV6TlLp/7H0nMJfmO0SMm576D11BiU9depMutQrZxCb3syTre9jv9lGlOPDUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
	b=dOGLhToCv0j+70iJ3dubjjyuZ7CJwhGlvR5/FJpam3oHRKtBpHy77uZvUc/gbcB5m3P7
	 +oljMqPb6Uaer+8Il62hnG6HQdkUupyR2SoedTLSUQhDC1kEEYkeAycHLp5TI/l0S8EMD
	 O2IcTREHXLC8vcBVZwAicb3+Y6un01TdXrDu/3JJXrqzv1zbDdzT2o3mAZoYKPNfE3wl2
	 Gx6cFfFgzTwrdQOnaoWPhhJy+c9tA8ai4LM+sEhQ+hoEoWaFhWJ5UnVA97O+XRtY5/1aV
	 UYKAXoy4WiMD9NIwQ9YM+ZMWGE1peoSp7TgfgVlVXepy4mOQJJHZ1waJ0Didn3Fyy5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU;
	arc=none smtp.remote-ip=209.85.219.51
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CFD606A336
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92CFD606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91c5e31bea9so4550626d6.1
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135388; x=1793740188; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=n6hOQTUUqngfoaAVe+wP7OipaQREpIZUTmr+9ABQ9A+RccYPbJ0xQON28EvRuyVBqt
         r9HM2iZE5cGg3PPNbG9WI93phORSXncFRdrjqv+ei/9HVJWZHrloHKm4dVwJcpKUsKIZ
         1pKz0CoBUEo0w1+Bv4ggVwqXdAraxzEKTXRBNPzZwya47RBli+DIhmUMFp4Ur5xfJGEB
         DVacZ4aD4hdYD/qdT08/V59jlYOFpWLjCJ5MJCxwT0+od31pmaugcsv9ZAAyt0DtpK6/
         FP7MKuzv8SSpxsigqar6AIaK6iqcvukWr6ltLO/guLJuuQgKnfFpDgSU6h1AfRjjYQvv
         B6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135388; x=1793740188;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=AjPhugTKbzxlZrGK0O8ApkLPqPJ1MJWge3aJfqzbRtCDmuh9x8cdprIp1sgV/wFQ70
         XHVFQmvM2szZydT336ZrDJusa2+dLET94uKSc/StL5AXQItV4LY+niloe4I19fDbp8u/
         4+/92s0Ty7a+SAZBQnWZDnpGyFjufigqVvGqGYKa9c4jY4IwdelWWNJ8DMcCK8Xcq6G9
         mip5va/KZGXnP/nd6gdrWvPTvnC5w3ka5ya2O4VTMo+Z23+RxtNN3C2MAVIxNt+eRegm
         Rk5RBal5rjZ/7gAgOOXdxIMso/ybA5d3NOMjx4ylkZ3xgkWIF8FFe3lYuN1FOPgDpB1z
         OJKg==
X-Forwarded-Encrypted: i=1; AKwUvBzAINGEMJtIPug16XOQqlAYyyzlYvRnjGr+Ra2xnsEhDcUqHLXI3j8LT95VuDN2rtetbv6KwtowP/2m5AwZ@vger.kernel.org
X-Gm-Message-State: AFq9FYIE2P1tfnGryIp0xNTKI+GD1VRtkODb2NV0BHb1xf+ndzJGjB0i
	4np7AFKjVgVb8rUq9nYiWbEsqwR1G6QlpfLOZ/b5cEwIklib1RaqOFwvtgyCR4jfcO4=
X-Gm-Gg: AYBFou3lftXNPf1PYqcUQ8sRHFy+fFvDhoC291ea0AH2LDkuhbIKwlY39uqDxdpGcBk
	g/psEb7y/y48v3XJM2Lj/+7wDFC2lglfuzML5vhl2whuSI58gRcfvFH91Z5+EXiS1bvC9t9qPx8
	djIKSgpc2PoAkqirtVyb6wp2qV7oc5BcsIC+exS417lLrgnnYB3EaB1eSbDJj7rekzXMjyECYAq
	bRFkilAOEMPGSaxNQ5QllUV5h7NR6XDT9qFAnMMly2PlK8VkrYbfAelaNHoTb64jxpB2Kf+iQx3
	IOGq4WMEmFZnec1xfvA71IhK+58FuBNbIl5fsvQijaNrGSdIVK5DExj8KOuxVDbEShV9nV8zAdY
	CtuntpbStixEswDfqT/K11D4kbTudKB91EdSpbDZ8Z/lUHiaQOu9945Ig6I9xKywH3Me/qXuVsU
	otkiXPqWxghkijkOveYsI7dT2KFRltlT2Jni8zwMx4BYv0ztf9h2OZdLVNb0VhthhA63dUZUok2
	6rZ4KuZ4YoW82PJk6+QrDmCZysaHXDkF+poC/JPZrQx6s+UQrvjs+irvoz2kWm4XF3+gS7q
X-Received: by 2002:a05:6214:8611:b0:91c:772d:fd7d with SMTP id 6a1803df08f44-91c7cf8f9b1mr5253166d6.26.1793135388396;
        Tue, 27 Oct 2026 14:09:48 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c8c2b3sm113364796d6.31.2026.10.27.14.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:28 +0000
Subject: [PATCH 02/10] ext4: set SB_I_OVL_USE_SYNC_FS if there is a journal
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-2-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=855;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=aO8AZhSXBs2aP15NSjU103SL3h8/eCNuFcd5jsKb2vQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLYucfR36lRP85t2sKZ2ZLaJ9rWkQsjCap0MbdXMa/mnYx1Aa41Uw40CeY2ykt+WukwlWz8EyZD
 bupKVdGj8SQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With a journal every change of metadata is part of a transaction, and
ext4_sync_fs() commits the running one.  ext4_write_inode() has nothing to
add to that, it only forces a commit as well.

Without a journal the flag stays clear.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ace06b4f9e3..037e274dca8a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5542,6 +5542,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		err = ext4_load_and_init_journal(sb, es, ctx);
 		if (err)
 			goto failed_mount3a;
+		sb->s_iflags |= SB_I_OVL_USE_SYNC_FS;
 		if (bdev_read_only(sb->s_bdev))
 		    needs_recovery = 0;
 	} else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&

-- 
2.55.0

