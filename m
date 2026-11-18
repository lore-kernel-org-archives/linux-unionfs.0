Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794974493;
	b=yBemOb9CgVhwYPogSoDo3oDqf6bcPC27wMDfMDGlI2RcfWNpSXrjNhaonSZoMIFwcFrc
	 pktA6EvLuYDvjruDxY/gV5NEE8bpJ1qBkXu/Rg71PBHxYcR0swskFkcZaOC352s9w+nV6
	 t9l1mbPO0WGJMdPxOM7AhA3Gaa6EwlW0Tz1f+EVbxAO9qWj7ycHSptyUGhC/3kIACYMSH
	 99WhkgCkTc8nIOoegegM29psp7GhdEmTPeBZavvMoiZrCjdflucaQSlcLZ1TnbSyppcGX
	 P7kK9QApdTryXws+FRafad6jlZ3jLXVlAGBT7aIddvl3bYKpWypPaxls/oQ127Ugwcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794974493;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=i8JG/335Ei/T3nsMnFt3EwOc1nsl3qPje8nCv8HP4GM=;
	b=a4R0Fp8/2wfcUBpdF/0GBsWqvF/Vh+uts2egkg9ywO+puGggAMfa4zQaYNkdj62E2F+H
	 TRW/DDVmEvMEOUxckHiKgEPeFPQhGFfq5/5j54jrUqPFobV84tte59MNBgqN+/EZAHSOl
	 H1yiVSj1izYTCPUDEgK8uzeHsVgOhsZitiOg09iOF3lAG6d4CvSyha29/eLs1r09NtG3/
	 LfXBe+eYsUF2BruG4QKDq5M9lfhe6sgIgYMORdTue+N6Xy0Oveuz2SGzjinl7icIfdXEQ
	 FQcCKO8W3nUep87dophCnXMPEeUtFb4F+5NwuTm9kSFtBpFOln3OrhjklwaHTNJeIqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p3vuzoUs;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC6B606A31C
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 04:01:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BC6B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p3vuzoUs
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so317318a91.3
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2026 20:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794974492; x=1795579292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i8JG/335Ei/T3nsMnFt3EwOc1nsl3qPje8nCv8HP4GM=;
        b=p3vuzoUsVRnTGLL8m7ZG4pi8R4Z9meVqoZ2s7Z6z4AKxrRtFfE9leaJqFLg2UJ+YT4
         WKmt0fq7uOrnwsooz5DfLo+ZW0fH0CqShBofwn4orqQHrPjVN2rEKBSaXL1KWePYbutg
         O4oa95ReLwUxvvpL9hiNYnYu56ugSymeVitdGcvjVSpKM6B0MR169dg98pm0/9k83g7T
         KVU+SuMfhx6ac+2oXUkGmMqzFKwByfr5X1WMe1jLIl8o4ZXalAp0wACNi9xuYvRvNqQb
         KaB8bq3RqcsGGKvFgD6hW31SZyRSFlS4dGqwIEQ2yLfbYZUqOILZMX84G3kp7MIIzoNJ
         jk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794974492; x=1795579292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i8JG/335Ei/T3nsMnFt3EwOc1nsl3qPje8nCv8HP4GM=;
        b=nttmwip3l3whBzk6l7KPATo/IkSS54pBkKm50G3Wx3mij2E6y6h+SEwwN61YVvl7Pa
         5rUJPE0fJiOa5qHlujhV8LLd8vo95sU7aSFvk5TjV7rlxfzhYAa+13NyUEV7jG1dMfaI
         RLAxFLl6P9UAeFKbZTsD1+y4JnIscwnv8MVhoqBOC5FQZAsdmqiDMIizw2LXAIFxraDd
         aQlsirNaGDixzQnGRestWCp85KlSHDwFX544xmYqF/Pk5Md6aGrhbfApIWCAi697Hpq/
         gI8lXamW/qCzt4PXPta4NtNOPaWS/Ao+XH1GZAOB95ryjejeg73LnZRFGLLJqDa74OhS
         FkaA==
X-Gm-Message-State: APuU4Z9BHtkX+/gjq7+B/Er4wInDFRk0G4b4UXReiwv5A617xzsy6tCv
	N+OzWfSDk/Si2tMYxC4TnVK7ngwRPpAsd7PYLSG5rerL6Qu2u39xGEXmNHU2sQ==
X-Gm-Gg: AZFdTZcnBUCYyD8tatgrFnyqmJvw47CQHPTeKdRun+xBn9JtMM1Jq7YuGDjsGqFn/yh
	moguH7CuUd2nXz/EDpIseB23xND6Y2O7F/y3Xh4hCIKoq6gcVMs5vvhBF40OekMxrvypanBPWr9
	HhlhdJR8O9gGFi8nYgV4fD/61OL2DBOo0o5ZQ2Dh1mLAxoODyUERsKgZTB6nfDzke1+ZydA9/oI
	iISELp7yGBMnsJnBdX04PZ8u3OppyhntQ8tN76fK64HT2BO/Jz8Lqjx/zt4CFI9CWjCp+MGIhHW
	a3JvHKraGpw3hL/iBiMTAZ03C/q0hYXwfOqoQ/FKIjevbr56vfEnETYKAEGBnxLCgwxNFdkcLQl
	qJL5ZKdOSLUAjTfvGYc4/PEr3Tj5T/xH7eSUNYGa46wsyK2D6q45YJhWha0cqSG/ohBbQaEtCKG
	4oDjSID80lOrJ7dqrsKnOGmTIh88VZnmhn/JRqN08+unWPj00JjJexxGlQ18hEpme4r7IRYoY02
	MuCB9Wke/aa3UKirSOlFQLUDMAa8+GFIJAuoVspszsr6IVftPkW0/yNOKxCdZrILvoU1t7aIOJX
	H7yQG9g1/UNWPKUAaXnPJ74zq3yC5hlzyx1bDeMpR54EupiSjaF6uwlEkMr+SvpZFQ==
X-Received: by 2002:a17:90b:3892:b0:3aa:6b5d:a00a with SMTP id 98e67ed59e1d1-3b3d07c2484mr1499748a91.53.1794974492310;
        Tue, 17 Nov 2026 20:01:32 -0800 (PST)
Received: from MacBook-Pro-8.lan ([27.125.146.195])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d5689adasm580542a91.1.2026.11.17.20.01.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 20:01:31 -0800 (PST)
From: Ding Feng <dingf3ng@gmail.com>
To: linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: ovl: sync_file_range() does nothing on overlayfs files
Date: Wed, 18 Nov 2026 12:00:56 +0800
Message-ID: <20261118040056.6543-1-dingf3ng@gmail.com>
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

Hi,

sync_file_range(2) acts on file->f_mapping. For an overlayfs file that
is the overlay inode's mapping, which holds no pages: the data sits in
the real file's page cache. So on an overlayfs file the call writes and
waits on nothing and returns 0.

On a Docker overlayfs root (6.10.14): write 64 MiB to a file, then call

  sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WAIT_BEFORE |
                            SYNC_FILE_RANGE_WRITE |
                            SYNC_FILE_RANGE_WAIT_AFTER);

Dirty in /proc/meminfo stays 64 MiB higher until fsync(). The same
program on ext4 sees Dirty drop by 64 MiB after the call. Mainline
fs/sync.c still takes file->f_mapping.

Amir posted a fix in 2018 [1]. Miklos preferred to leave it [2], and
Dave pointed out that the call used WB_SYNC_NONE and so guaranteed
nothing. Since commit c553ea4fdf27 ("fs/sync.c: sync_file_range(2) may
use WB_SYNC_ALL writeback"), the full write-and-wait form does
data-integrity writeback on other filesystems, so on overlayfs it now
silently skips what it does elsewhere.

cachestat() has the same cause, and Pavel's series in June [3] fixes it
by forwarding to the real file, as ovl_fadvise() does. Christian
suggested a helper in fs/backing-file.c for that instead of a new file
operation. Could sync_file_range() use the same helper? I can send a
patch along those lines if that direction is acceptable.

I found this while checking sync_file_range() against its man page
with an AI-assisted verification tool, and reproduced it as above.

[1] https://lore.kernel.org/linux-fsdevel/1535300717-26686-7-git-send-email-amir73il@gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/CAJfpegv50HELSZuwt9gGjgSyB+4aPbiTncc-yBNqUVgTLNHaXw@mail.gmail.com/
[3] https://lore.kernel.org/linux-fsdevel/?q=%22ovl%3A+make+cachestat%28%29+work%22

Thanks,
Ding Feng
