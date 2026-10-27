Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135391;
	b=gf62BWgP1NhFiGTMmk/1YTxPK78ESAMhbhn81JQ5lNnY55TtcKaKNfrxUMwbsxjI8YD5
	 edpcBErN/RoriVik0HGT0xyhVey8cm3ce7ux280VuiqTFqPmSzBblCNjFyfGdTdcDsd3+
	 oZraNScqBH9gTPcfGGqSZCw40JQOgnY9/M/Ch/2QpJahVa0mm78EIvjubpCu5L1+Qqn1P
	 BHXOKno/+/H6o/mU/q6ZbaLgku+XwxGHYSCjdqitn/9CPK+7/XyEI1z0vdSMlNReoQY54
	 Nu6h2VlyBb39PljqZqX/eEUG1lJvPEulS5+5jog5DKGbXIw7k0oshkAvaKoiMp6i+YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
	b=w/ee7hie+QYqM1zcF8vys7R8rSld1//pNCAei0MTlR0/EAxLIFKO4e13HWkUtzGskVzD
	 tCJwCs/U3HjQFjHVmqf/Ab6FISV2arQzXsFqskog76gyvLl1uOa3OTCffYDENTrjTSh7h
	 fWzfnaNU945MuYbz1jk0b83nC0QXHg5/k6I6Vi7c3oDpVqLUaEgmwYDwOHHjHZMTUUTFd
	 dPdJSHuoZRQk9+6HQJbMqpl4y6LKeghePnIRE7jzJCCdE9v8RyTJqgjwuJSYJCD3Fg+Pd
	 EEo6l9HLk6ffxsb/94qUkLEr6U+fIzc87u4VeyhPKk6pW8lbtU8ZcI6iDWtg+hCMDKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4AB60A2600
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED4AB60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=WnvvvdTc
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53644b28706so5962481cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135390; x=1793740190; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=WnvvvdTc7G1nfaWX/xZKKnrICsgfAqeL0R9qFWLgI1Lu6RxgO3Y0j6JpA78kzWjYYF
         KyHoApYnqdtPpwWqfZAw1ZHZJU+FOrbBiHwQmZ71f/p1rv0nSKVSrveRfhtfsUqhDK77
         whvi1LUz+/OAAEmIQmJJBuXgJAoalPNrMrCHO8ICLrteLjaaazmRhnuZZB8693EsvC0P
         aFtcYWZhs+cUyb6MfKJ7TpwPzncqeXWQlaRPzHPMlLHVg9VuV/+ATMzV6LYkGnffpwU0
         nteEG1kjc7zbUoS7e89EOLrDTDoYhaVC660ZHf2WhRhQ+FzhUdOwf98TItMqyoculpUQ
         Q7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135390; x=1793740190;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IpMKT1cwbF2BM7+4MFg5CQwWFq73xTe9BXIlwTOQUCI=;
        b=W7pM0kuS+f8vIjsbjw1OE0e3lDmcrVWOHkBkOzTijiQJtkA6zIr9iJyPQUWYzqc3mE
         si0SRiJWhvFhZiKnFHcgIpEHlqZ3740zFvROlVnGWk+KTx7aB48LGKZ/xmxm1TdAfrhi
         KDsn/xhx+n9/kh4ATKrO1HQ6UdnuYlvEjg9RkWsA/WCfdt95mSGTkSIdIz7psLFwNvb8
         axQL3KjvTAcGraNM/iFhFhkGacm05LCfoOM+tmUgjjm4L+6VFJMv6TTYZkgIh4kzs55Q
         3iy7ORErlYWYvVqCPRdGUdPRy/DRN9ThS+G2dJce2brckdgxuRauaYd88t2SlVFWK/1L
         C59Q==
X-Forwarded-Encrypted: i=1; AKwUvByq0c4NZO3egz77u9KcU+VmJbqnhcWE7nxU3Ohpe5gFMNYoszcqs3+km1KtRLVNowd5A3XgTY0WpZENqCkc@vger.kernel.org
X-Gm-Message-State: AFq9FYKRmwPqVTR/9N3ZZAdnz0mq/RfpuHArejucS14wYW4fPij1itTY
	jSnEtHSphqaZbHs6zC5BEa4m2IzFpUN4Wh6H/jizIGEEonKCj4CCWkWrb/PUr9SIfok=
X-Gm-Gg: AYBFou0c18xaQBf2U88C0kWCdzASZuZcI7ZOZkLOCDO4petgtb+4hqkYQdOPgks0iHj
	6tSOmhLL6zosXh3sLqK7gH8cf1/UOYih+SxDVFELWd/V8DXuVr3++55Gdgnnazi/MbI4BzeKVb9
	JyMZoF3k7QrdM5ul2+VHi/p9l8jPQVeCOf/SnTuUjT5N9TtipZT9wMCuiwlZn9jam7M2Dv7lmWM
	ssrmLG+myHFx+gVtFGGyPDPCHvjuIW0qZEUmqyVzYXmaUkFwzCdTNFjuaN0R12aLVrg3ZYiAOe2
	kvUCh8j4TAlSHB3YjLHzNRxlzWiu7tuHgIADN8tF49Fz29aBU5NF/FUAsU6Frn2V4x8ywJv3QhG
	LxySAyz1TKH1VJfnUW28SAtLJzcAy2hUeBKlBOTxEP/CBIC2JGUkcrQy2rjYPDHgkBgpHfuH1hc
	vIFauUPGVdF0HVIFpWHFrjUxY9rUMLPg8t+WoJEP21lR3adspoUlQHhY1YHVkc2VmJ8dwyCBh4g
	sL1lJNQ5dU1ct01beu6ZGNua3S3bz+xfJV+Cnp6cBKQmWhjzfzM2z51LT1v3k7hD+Zq/vtuxwMR
	a0nnCufcp1zBzq4gzw==
X-Received: by 2002:a05:622a:8b08:b0:535:d7e:dbe with SMTP id d75a77b69052e-53fcbee4226mr9184971cf.12.1793135390022;
        Tue, 27 Oct 2026 14:09:50 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53838cf2dbfsm88162341cf.2.2026.10.27.14.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:29 +0000
Subject: [PATCH 03/10] xfs: set SB_I_OVL_USE_SYNC_FS
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=709;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=1Z5502S4N9+PxpDJ24MamzJyZyNagTbtfNLwpblShXA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDJutvjNlSBU/eOcQ9wQNaWwYhbQ0y1uFYtQSeQkyDonWymvy92FRNAyiqlerkJRJJxNhvaXRz7
 8R+gU7AP+DQw=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

All metadata is logged, xfs_fs_sync_fs() forces the log, and there is no
->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..2f09d48b7e6f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1924,7 +1924,7 @@ xfs_fs_fill_super(
 		sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	}
 	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	set_posix_acl_flag(sb);
 

-- 
2.55.0

