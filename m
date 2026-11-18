Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001570;
	b=rmNw6CQlH1Osu52B5oL7FCWOlikKkwTDohY2TLHnhUQcVbQCPv8dE+G82hHskiNgq+Kz
	 L9z21g7m6oWqv0UQIxmOM3cBU4XMf55tS7brV8S+n5K4WSmwPpztv1sdAz7dDTuevuVr4
	 AZSZtIINkbExUotpT73MWCxpgqBvfl51cLC1tW7PLigM/qEQ0b8NihgDCWcS4ILdJZ8Da
	 QzA+FstSclwulTntlKTifG3YzILE10FV/8ryCbDPt2TRpKO51cLk6GtB9uXSHObImUGZq
	 wi1CI7AwkgY9V9b2xnkloeqLrmNi36ENoFkmsSwGlg8w9cC1aFMwzyG9D7TS/+KIkTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001570;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xJFWv1xrhjfAyje7Ep/W9xVonaRZ/xPzzJA7Dg8c3lE=;
	b=zj+h8bgoXnLoaPRGdVvaANrqYcoB5NNpTgrM0m0zmuwW9fpkQkfk9X84mMr39MkhZ8vW
	 jqQ9RSeWVz6nWJZ3D+ulseIL11Vph0xLjKLtoBrvJpfDjumq2C1S85Jg+A+CN190+bpOT
	 JIoibhpVYK38WZY6qfrRaZReZRSOxSpSP292drP17rBIAGOTZCwFMQD47/AV7jMmORtkG
	 W7grHqOOTouW2NpPr6eQitY53UaHOQfd6UKOiyY4xSJUDSnYQewbgoB02Kq18rqmxPWRc
	 LKhGnuQyGgo2d34fhbzjbghvgibryK4D9v94/PvAbsbeqFLjy1TYRzOB60JNbl3EDZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BVi+u3hB;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B98606A334
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 11:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20B98606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BVi+u3hB
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2efde3200c7so3349085ad.2
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 03:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795001569; x=1795606369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xJFWv1xrhjfAyje7Ep/W9xVonaRZ/xPzzJA7Dg8c3lE=;
        b=BVi+u3hBS8dmV4u9QmaPMl1y+DR9rFtlTWYFFhFMTGJk6YSKkhFcCYaOePrmrwKt8n
         wsLM9x9UZQeTIyihcuyM3Gu+4AMULhr2PUPcKQH/XAb9T+9AZib/0iKSzwu3aKmTKXh8
         Y0CrkPMSDwNt+XNX/OxWL/DkS5hBvQYzUkyBnmCxHpTLI9CpzwyKJ4CQuzI54WtyUAE/
         sj7Ao/DZoG9fU4LdXu42zOtGoocxmgvUjDTks2sX6ZpKvY5in4Ady39WiKx2zOkBDEm1
         LfT0qoIAeWgk0Dv3bpmofp65fsWHDEwzPZSceX7BlLa5ELRSIrzZy9jg0nFirLGgKRL+
         HKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001569; x=1795606369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xJFWv1xrhjfAyje7Ep/W9xVonaRZ/xPzzJA7Dg8c3lE=;
        b=pgWt+tDpaQaxs529EmbzU+/wukBTVs0d8DrhITXhYNmz2h2XW7Y2Habyt8EJHLBw+2
         iNOSEdC/ETmP1s5/5ncRH6GsUyx2TNils391Ttr4h8s0cdiIg8ymTou+GCfPjCmO7gcB
         ah+r0swXd75+16yK69pCfRCJKkWg0uQofvpAW7fp3AQt4e3OuJZs2VMU/D6tudk6uuro
         oxECSsKKQXPxEjZ9MUndKS0LD059WwYDjEI/sQwE/1uJVcvuat8ER6G99nM5wdGPvkXH
         8sVmyW3m/fwchWDjzp0AoBZ0Rw73GW67GxHDbhPU7M0AZ2OcoO0frmRTSlZ8Qas4cKLd
         mpkw==
X-Forwarded-Encrypted: i=1; AL+hErHH81/PE8ZVzkIYgcNDwH+e/oze2h6g+BbJZ1RFYLoG2Mo3DvCeMgSYI0nc0OzQiP4YhoEzycVtCBvVOQui@vger.kernel.org
X-Gm-Message-State: APuU4Z+TK72zTYDwjTq+1m7CIXa/W3lZ2M07xqvGeNI6lnn+cYyK/uk2
	ezdAw2GOnOpq+bKBRKbue8ofcb3kFMuazMp3XQrBOLGy0jNHAZRn4GlY
X-Gm-Gg: AZFdTZd/cHqcAuL+LpUkoU1kqYw020M8GdP3RuWeaHXh4UYb7MPTckZ/qVm0zfMNwWt
	rrQEaMkCiH3KFkgmNbVopNMnd7AVxsiZ303yyjLoTrcRWEMeuPnv8XkX8TOd89WN4KUL44ZFC1p
	lPgxZZil/0dt9n7wuP2J9R8cFMEMD1TfYd6fuFoKfKpQStZSYYio1yXAVTIw+3LylufGOe+S/Hz
	Qxkq16XoUhLwfrTM3YzsfK8tjKS10gccVhFvFgzqcyO/kXG+KgQS0ebZfHW0HSQqPG+h9x3zMkh
	HLiSrmthWViSnPhHKIrWqBT3l5FkrMa9axeSVUdFvjhoLIJq0KSBQCFMA+3zxVeA13gwIfe6YPo
	H/3BuOsuk7Ge2E5FYtqryYCqqU3VbVraUfVjBJSzeN3MNFWua+PYdQLaF47NhWbjoAk0JX7PtXV
	EuqMbN5+qq+vd3v74J5P1JHE0aEwcHbZLYdIHo2rCBtePnHgeh9+DO5LGOve+jNeU50dIZBpa8t
	6yJ5AHTpCm/tYWCUen/ogNE9E/oMTIk+EJ8jYHkZNrcr4vBg7oW4KFheDc94ndpZG/kr49J27xJ
	7RDYsUquy/gH5RqK9v0PlEfR03r3IPztWt3h/TzrfmYBYCLb0RRwiE/eHfRj25oQf6QMtzY=
X-Received: by 2002:a17:902:c94b:b0:2e9:58c5:8c68 with SMTP id d9443c01a7336-2eff753c6b7mr21302625ad.54.1795001569415;
        Wed, 18 Nov 2026 03:32:49 -0800 (PST)
Received: from MacBook-Pro-8.lan ([27.125.146.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff62930a5sm11612305ad.66.2026.11.18.03.32.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 03:32:49 -0800 (PST)
From: Ding Feng <dingf3ng@gmail.com>
To: amir73il@gmail.com
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Josef Bacik <josef@toxicpanda.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Ding Feng <dingf3ng@gmail.com>
Subject: Re: ovl: sync_file_range() does nothing on overlayfs files
Date: Wed, 18 Nov 2026 19:32:41 +0800
Message-ID: <20261118113241.29101-1-dingf3ng@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAOQ4uxg5baphOjo+_A=3nZBmFEmMV7KOiv_W=rjEVYV41eTEaA@mail.gmail.com>
References: <CAOQ4uxg5baphOjo+_A=3nZBmFEmMV7KOiv_W=rjEVYV41eTEaA@mail.gmail.com>
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

Amir Goldstein wrote:
> Like this?
>
> Completely untested.

Thanks, Amir. I tested it on v7.4-rc3 (20eef29b7c84), where it applies
with an 8-line offset in mm/filemap.c.

Setup: arm64 defconfig in QEMU; overlayfs with lower and upper on one
ext4 disk; periodic writeback off (dirty_writeback_centisecs=0). Each
case writes 64 MiB (16384 pages) through the overlay and calls
sync_file_range(fd, 0, 0, flags). Dirty pages are read with cachestat()
on the upper file's ext4 path, before and after the call.

                                   before patch       with patch
  ext4 file, flags=7              16384 -> 0         16384 -> 0
  overlay new file, flags=7       16384 -> 16384     16384 -> 0
  overlay new file, flags=2       16384 -> 16384     16384 -> 0 (4096 under writeback)
  read-only fd opened before
  copy-up, written via another
  fd, flags=7                     16384 -> 16384     16384 -> 0

cachestat() on the overlay fd reported cache=0 dirty=0 before the patch
and cache=16384 dirty=16384 with it, in all three overlay cases. All
calls returned 0, and the kernel log showed no warnings.

Tested-by: Ding Feng <dingf3ng@gmail.com>

Two questions:

1. FUSE passthrough also keeps data in a backing file
(fs/fuse/passthrough.c) and already forwards ->fadvise(). Does it need
->f_real() too? I have not tested that.

2. In the copy-up case, sync_file_range() on a read-only fd can now
open the upper file and return that open's error. The man page lists
none of those codes. I assume that is acceptable, as a write would see
the same error, but I wanted to mention it.

Thanks,
Ding Feng
