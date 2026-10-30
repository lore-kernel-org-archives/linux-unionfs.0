Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793359926;
	b=vjYBd6MqtVxZ8YZ3E4zoM1n8E1DL7oiwYgP9yPXsLZdSNKWYWAOJ4ImHoZK7jpSMMA64
	 RG5+l0lUbS3U24FiJ1mNQWlC/GFkUkbvPyIo6Lbyhn1YhIJ1IFFu7/Q/Lb5GDbPMdoVmJ
	 bkHq/8BVSlxZd49TZvD34ytSYUtr571U1IDl8iWSLo9EFph7oYewtOWtCljB9D3ECEqeI
	 6el3m0/w1odP/Y8P1+n9teY9bqByh8Sv/G96Ra8QnTrLi71CVq7XseBR9vEEghd9856nu
	 rMKUEejWA+ZxpAZzhXSQeVNZdUGL11VJ3eDy2Qsh7OcEKX/Lf/9KvtUYrGEs/Xe49mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793359926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bBabPJq3TODdbBocrBAZgPnc+pz3vo4Y94D8Fs7pGQQ=;
	b=YrNUrO+HCzp/yeqqfVK+PY3j4uxDyv8jwWwhP0/jEFPJfqgWqMDbe4IlKfgxsxnM8qMQ
	 VUPSr7NuswpSyoLmJXeI0u8C/nzO8N8N1eXkdRjTNUlqqHBJuT2V3fSCocki4AiZXLGtC
	 mhSBr0XmeNouSgkho2bqIuFOiJwzFZkwx49YMpAgJO72fziUnZXV7j0MtfbrxZj/B4hyL
	 vE1chiWI0FHtfHrbXi5s0zH0gMJY5GFcPgr7Zom15Ns2Pta0uztXWJCuDg/R305viGLjf
	 C/9l2GbO+qG+cOnjjIxK1U3Zvud9w2hwRFATu5UMmeg8OLUZCe/cllUe1Qs5tPdZSng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eht8YF29;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23E1606A31C
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 11:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B23E1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eht8YF29
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e10a70540so369357f8f.1
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 04:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793359924; x=1793964724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bBabPJq3TODdbBocrBAZgPnc+pz3vo4Y94D8Fs7pGQQ=;
        b=eht8YF29ZDQ5aiSn7neLwPfe0QqbQ0IqFaz23xAlDMXrUOyhRt9SvfmfqLNxG9Vpwt
         1zK3pFVc+m4nU2R+VCXrQADdxrCUrnDZP8l0rK25ojasT1GgGFTZOahBpfHpOO4PZCtK
         8XU+96icNPU3rNKu3qE4x0eyg1twT7Btt3KvfL/DXFw72CtNVlVIzVJ476SQzMLR7+Z0
         C4I42jTsHVtElvx1tb8onWwX/1ZNMGLRfjxnbi61JH4+vy50kpyB7AAuf9Cjtx/ZChB5
         GWr6w20p4jpKexs/2Ke1wnFRlSZLPZUbaXVwZ2TuyJy17mOKZMhRo6pAcXKUjMhow1z4
         IYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793359924; x=1793964724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bBabPJq3TODdbBocrBAZgPnc+pz3vo4Y94D8Fs7pGQQ=;
        b=sk89YJxUuROX8uZGQIdDjxXz2iTtqnNNUC6cFzlw0bJMd70ZYBIi2v8rDUAMzmhNUc
         4H1ehqAfsFvWAwZrEKv5JPI4CztUubLqTypnqKPi4I0CueU/ic+iznSVLvYG0Pf1TE89
         Kzx2WOOzFkZvT9iO2vQElkVpZKnHcCH5pNwhq5zf4rzc/FArj6WIC8i7/h+7IuiCeJJm
         CY2/qCeMfgW/58nD1HpDZDX8mqTjOJgPIeI/VKE+BfMlJ8IPGEWTBkWKRYLpEi4BFryl
         kUSlbR9mnUeKZtAmFC0DJK78U8VaDnC3IQETqU94UeABRjDu/69X8D+TFaNl/Bhb4eWY
         fUYQ==
X-Forwarded-Encrypted: i=1; AKwUvBxEbutnpl5k80F+atnUu/61NGEio+mEAgSQZhnPENXSN0hNWb4CeKZMXiCUP//eHGX8RgZe/fIOY9GL47jE@vger.kernel.org
X-Gm-Message-State: AFq9FYIkNTPIeXeYZsgEhMC1cV6JmmKC96qLSuf1cIdyN4MJagB425Hx
	LBeBD7030AK9Yghj+dmxH+PXu00ahyqebcu2Q5PpjDMHnE5h4e+ZKZbl
X-Gm-Gg: AYBFou3Kb+ejtiw+5wJ+4uqJkHlQL6O91gyWkf4iCO/fP1DNYLN9oxy8iV0DaZ8nwLR
	5nfAfX7PxaXTAm0/wTuEJR3h8+/xpCbJyz9m2QKqdnHfsbKItbn/afWVBy6dohpUGNUQrUHuSiz
	Rfx6gR0PIdyLk6UKISafMrmfg+PIbt1m7Lh2tumdqLUR/NUlEeM8OEt9G5bBnaNE6R/5AQhIyHu
	X5nWRrBLht7diTvfzW5/+Z08Mmi92kfrch6mP/tHameNubMUx3E4WrGj1YazN7px4AmhvVBEcdk
	Mlh4ZpqlLoRRFoxdkoWg3LI/0bS04XU4b2Nk8Ta1JLZAvDOEyn984yKOAYYW8bP7pfdKj4f6lYn
	Pr0Y8SofcrBSybsrYMH2OQ3eLsw2If8cmmIL/aa8kPRI/DWNf8bGrGEmX9wxMa7Ti/qF5ijEWZb
	TRlUlU4LbL3U+j4mBCO/r29SiJ6gGHKKFBTdNnes7yytVsEGiitdgIC0YIN0xg2CS6UN+Wz2Gj3
	Shbf7KuKF8VwLGfQMBJXJ04ATQRp85uhbiVqYxZEr+6qZ/JCo01N7GGrtg9ldHayfxLPO+vB0o7
	9mcNgYf2pB7cAScU0jDHYs9slB9AEVhz4bBacfZrRcu0NbuQuZdW00j6oLeKcauBwQEcC9aLUsL
	zJitVOMacjN5Z
X-Received: by 2002:a05:6000:26c8:b0:48b:677:f80d with SMTP id ffacd0b85a97d-48e6e2ff7demr4687700f8f.26.1793359923805;
        Fri, 30 Oct 2026 04:32:03 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba5dc2sm2647955f8f.54.2026.10.30.04.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 04:32:03 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/3] Overlayfs casefold fixes
Date: Fri, 30 Oct 2026 12:31:58 +0100
Message-ID: <20261030113201.2921633-1-amir73il@gmail.com>
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

Hungyu,

You indicated that you are willing to review and test overlayfs casefold
fixes.

Here are a bunch of fixes that I recived from Chris and added my edits.

They pass the basic sanity tests, but I fear that given the nature of
those reports, the test coverage for casefold overlayfs is not so good
and possibly there are no many users, so I am reluctant to merged the
changes without a champion to verify them.

I am not really interested in adding test coverage for underlying change
races, but the functional bugs that are not related to delicate timing
deserve test coverage.

Please see fstest generic/783 and see if a similar test could be
added to add test coverage.

Note that it is intentionally not an overlay/ fstest, but a generic
test which only runs on filesystems that support casefold (e.g. ext4)
and the test itself takes care of mounting overlayfs.

Thanks,
Amir.

Chris Mason (3):
  ovl: fail the mount if the casefold flag has changed
  ovl: do not let chattr change the casefold flag
  ovl: fix whiteout creation in casefolded directories

 fs/overlayfs/dir.c       | 46 ++++++++++++++++++++++------------------
 fs/overlayfs/inode.c     |  8 +++++++
 fs/overlayfs/overlayfs.h | 10 +--------
 fs/overlayfs/readdir.c   |  3 ++-
 fs/overlayfs/super.c     | 12 ++++++++++-
 fs/overlayfs/util.c      |  2 +-
 6 files changed, 48 insertions(+), 33 deletions(-)

-- 
2.55.0

