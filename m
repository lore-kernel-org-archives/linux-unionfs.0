Received: from mail-oo2-f37.google.com (mail-oo2-f37.google.com [74.125.231.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A5B2D77F5
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 01:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790643650; cv=none; b=iKJD61lnlxSFCoPGcos+VTbW9a1KYEFodI/9mRu61mpGul/+CZVRusWfIFY4DzAvqqOphh8Tt8cFAsi7zmvLgNHNr89DHEjtisLm27Tmv8BTsAPvSGLHwLcgYb/vj8wnYyCk3P2SrbEpUaUN+eYoCUyNt+07+bFYuF6K6peKDZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790643650; c=relaxed/simple;
	bh=tTvzke3DfKKWtYV8+SwzyB0UUAV5X0AJTYUDzhIU7pI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jM5Yl3w5u4okJi8lcymdDDrFDS6nHTBR9WTE2N+txQZEew4wzBiu3oiCpSFbqUSZkXvELpqMiyOHMisz0xLuR/RjUL9EALDFFu+a0edOpmjWqOz7VA5/XRs5Q2/ieoMWGM/ObvljyLPUDXMSHZIbppsvVaA8i4dBjlmC18ltbgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AoDDDKpK; arc=none smtp.client-ip=74.125.231.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoDDDKpK"
Received: by mail-oo2-f37.google.com with SMTP id 46e09a7af769-804f7045f3eso1380965a34.2
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Sep 2026 18:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790643648; x=1791248448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6it+SmeVeHMYo8qun+39zeU0I/4M6Z51mplDGX3Lxkg=;
        b=AoDDDKpKwmXEmG4TjHmmL/aw293eFXnAK2hSnhnZPH72muSYcqOQQTj37QaccBGs93
         uw19NqPGroF8JVWNDhdHfldDqDgshPT19+OX/bzHXKBYGdiTTDTplPetWaNrd0BnJWks
         bSJd8Ts2U2ln5CJ9KYM/UJl7RFN8/gq+LDeJCN+9xXswFhq3fBSerWdEnHrT11vTwUjy
         QnHfiCocnAV67fFyl4lliq970mT9C80BO8FiWajGhj8kTvj1smNoDhnNmmF7LhtGWbAA
         cP4mwqzAMUq0WTobVnVczCpvJ+zkkf/XGwHXESg5EYBSZyUYwWcvf9tpPjt8ewLwub5C
         qwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790643648; x=1791248448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6it+SmeVeHMYo8qun+39zeU0I/4M6Z51mplDGX3Lxkg=;
        b=b2GNpwwo0+9YtkeW1OfxFo0UFvo8x/Yuv5xaGDcd63LyQiopQ0JkbSgIvbDhVS5dRf
         12MNxLGir6u+xLYiG4PFH2TDHCXSo13FmxLRHA9d4tJBq20XbpGRvhAhgRBQlsBpeTrT
         IlMaKsTSL35AEJ2WgcTNfCpoJs97v4pPEbCaEHswonePmz11A0LdwaDNgsUo6jBlHYOl
         vA8J5fUsz6afn4yT4ACq6Jx1KhEMh8IvP8HBuIrbO5YEKqw9qMcsKJxqr/KRBcLU8IAn
         S/Ns+G1okuljHGoEBnMMbtdjOz0++LaWrq41rOnm44O+1eyglgE54284SxsYD1fH+Hc2
         wDQA==
X-Forwarded-Encrypted: i=1; AKwUvByGYisZdHSL2LP5geO4Yjaf5l4YuTAGR7S22m2ymBEhIwvDqPCjGWz9I6HZ2t1qOowscopeX1R7QlverEVn@vger.kernel.org
X-Gm-Message-State: AFuF++mKPIgOiiUCPU11FNW7BOzmSFBkjvIQqpIUd+34ekJLIx1PZejq
	kY/La5HRvHshrzRZ8KPS+l21JiCr9Yf+MngkXtX7zdew07b+fL+/I5Qd
X-Gm-Gg: AYBFou2eSFhk6J/J3Ngkd8xy/1HW0LkiGNhWRQghkDxtUOeKP1uRhziekCRUPvdin+z
	Gn8kx0oxCYz73pLxiwGpKxYvPbS+1P7UcqLuXjM1HDQtqvPs0WoqMXp4i5wrQnyOiBDaw164B03
	eAOoViAwfkqwkhyvxmsmYNmz8+vrH9W7yzyDoz4MBffZGjldZwrt4oCnmquN/2CMfH7ZVs2uO7n
	OUOFzX129VWi1XHUN9CEUwbjH+OUcvJHoQw5l7xJsa2qeZ2RvQpUwDBw++VZHykvuVQMRsyncKc
	7GwJLhYcb9/AYSsrlxPDSWObhxu1un1f4ApCcgRgOE3OmWxGTLk+KIr39vsdyWf/Xa84bbr3Agj
	TWtHUQ+e5JyAokEhBw+D0Vmc11sgon25A3pLW0HimFqxZp149+nj3xv3SgTnkEfM1gP2vqHkBpt
	2MZpMdPM+eMXfdi4xXdX0SyJVF1vdo/hPvKuIa6nYPi3Z9BNA37XDJh8VR1B+Yvem4X0HbThUNJ
	zYSe8FBgwGJ6cFWAerNYX1FUsXRc3VvAIwu24QSMRwOy32eCuA=
X-Received: by 2002:a05:6820:827:b0:6da:9dae:a22 with SMTP id 006d021491bc7-6da9dae1613mr1713830eaf.62.1790643647899;
        Mon, 28 Sep 2026 18:00:47 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6d88358bb8dsm6410092eaf.14.2026.09.28.18.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 18:00:46 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH] selftests/filesystems: expect EINVAL from overlayfs in fscontext_ns_test
Date: Mon, 28 Sep 2026 20:00:44 -0500
Message-ID: <20260929010044.5297-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit a518e63c3775 ("ovl: return EINVAL instead of EIO in case of
mismatched user_ns"), overlayfs refuses a context created in another
user namespace with EINVAL, like binfmt_misc does. The test still
expects EIO, so it fails:

  # fscontext_ns_test.c:208:create_from_descendant_userns:Expected variant->expected_errno (5) == errno (22)
  #          FAIL  fscontext_ns.overlay.create_from_descendant_userns

Expect EINVAL.

Fixes: a518e63c3775 ("ovl: return EINVAL instead of EIO in case of mismatched user_ns")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---

Notes:
    Tested on next-20260925 in QEMU: fails as above without this patch, and
    all 3 tests pass with it.

 .../selftests/filesystems/fscontext_ns/fscontext_ns_test.c      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
index 0f30a3e6e197..535bf1f4e1a3 100644
--- a/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
+++ b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
@@ -193,7 +193,7 @@ FIXTURE_VARIANT_ADD(fscontext_ns, binfmt_misc) {
 
 FIXTURE_VARIANT_ADD(fscontext_ns, overlay) {
 	.fsname = "overlay",
-	.expected_errno = EIO,
+	.expected_errno = EINVAL,
 };
 
 TEST_F(fscontext_ns, create_from_descendant_userns)

base-commit: 6812ce4e4379ffc99c52401ec28f0d7ffbc36206
-- 
2.55.0

