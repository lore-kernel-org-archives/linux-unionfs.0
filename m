Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793484991;
	b=AdfnFxTRmhi0gIFwC8TSXOPz1MPMG8WXQXzwBUVXkF+5vfYX06oj+kO1VctAeUNoobTV
	 IM9nWp5PZONbZ2khN5GtnfzApllvGdqVC2s1VVqyDKJMDVloGWqevF9MPWFli1pQpAwoJ
	 4L++Z/0oeXkZdo/z3HiBN9yPl2yD6SW9KnrADmVtTR4Zkfw9Z5M+7NY5pc+orwAaC0SFX
	 3lkwyWc9pzLYwe/3TSpbu9EEoyAonDla3jzf6Zbyc6kQo2fgTFVxov8SPHBPpw7EJ/Jp4
	 AWq/G59NfCb4ZfHOuKXoDtkTBWvg7LBSFpnoAiQ/s+z7sWc+dpD/lqpPJQt0fuF1y6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793484991;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7KpXA9R9TrTF1xZIX8mrT8HYSsUTOapDQnwWe5ksxdM=;
	b=hHLwAk+da0r65/M13QAo5vLWKzrhD5QkPD4mazP6qzpz/6WkU91Hmcuc9rbtTZPfaxL7
	 33VzbWmIF+PUf1i8Q57gLgeuC2TsOSp/J03czpssHDiS+CnOyE1mDT3V/g6atHSAG5fRf
	 KYXZJH0sSqX3Ahd9/bLHQyKCyIOQE8vJwvaA8vGM4hudzS2E9NPQ1MyYVwHtAprqpCQkL
	 1KYzLtLbpBD0KOx/kqFLEncpOJlLK10SW5OiawkKi+VjjGzkbY/CoD1wAF7jnGO/kOC3Z
	 w1pljb2kSP12iO4DWWdoit5iV/TJEsUACFc5sFNE2SAl8BfSaCB20xWnk20RnXIze4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NzjihoSY;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B87606A31A
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 22:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94B87606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NzjihoSY
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36888ae05e7so606734eec.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 15:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793484990; x=1794089790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7KpXA9R9TrTF1xZIX8mrT8HYSsUTOapDQnwWe5ksxdM=;
        b=NzjihoSYQm5UrRty1Z9U54fqcQtfIOFCdLvCXsAZ/Eb54re0wlV1iWldlAxy27C2R1
         OLGNvMWqYarW5/X5pRYt+AgAIz5C9IcFSB9K5qRnNRtqsOmANfRyomAA6UKaHRtCK6mG
         iwKYFYSMR8F+lUJ+22vzr/Yzg+L9dZx5j/JnYy5fKDd1zcsA/NNR3Mf66ARd2BurOrNR
         mqyGyxbrrktE7ezxo5V31VyKBvxZkhOzFWCfzbLd5+yak5W5Ca5oCd/5AQI6mjeo1aZN
         mkLpTmeUR0deeEWQUVnACknzz1XIOcxULFxo8eyrS6J/zqUaFDLEnZVkmqeE+pHIqHse
         zHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793484990; x=1794089790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7KpXA9R9TrTF1xZIX8mrT8HYSsUTOapDQnwWe5ksxdM=;
        b=beNXQFVdArcZt9CjMfIA2RY+Idm2TpSyymi2uucump+K41kb+wfPYz5QQZP2BZX3+X
         vzJAhwz5sHLhuvZ5ASczpGWTkMf/ISkyMRLuT0UyBRc6k6G6KETv0PDX8CD7YllnLIU1
         f9knq28KrGrBPXaGhTZkpQKGI2kw4PgFHBJrRDmWD/eL8WXMO1UNzMHRUiQJAfCEWv+B
         cehYjVhgC4OJiUOIK5/KjjLvQUW82v/U0883PK9qWVdcu3QKCuXCiPmfdVqkF5HRZc6z
         9RNm5o0P5SxspBtb8kMwOz+JlXxsOihAGiPVrGdYVXx1IIju1dlBrvVNBF6CPbPeY3+9
         rPuA==
X-Forwarded-Encrypted: i=1; AKwUvBx5DlQ0mnE5dziFOFJeImi7O4zwSF1VmluY3H0W4H6k8iTVjEaZZ67pZB2C/c8d6Sq0ScQvA+9398R7z1PE@vger.kernel.org
X-Gm-Message-State: AFq9FYKNm1bwaSBm5EIHTJIXkVZu2h6htyJSSppSLtxVWyM3UpB+zIeZ
	1v79KWHl8HNW7me5nWFQ0xel9ur/qaaLiQKaZrfO8MIgkNVa5F+9UMBe
X-Gm-Gg: AYBFou1BH554mW6RHWn1ZduE5bzkiXOidmxjZQgkgKctG/QCuBwlqLY7yN8ayHBF6K6
	QfdyLTPWbE5QRHH0pp8obPSNajekFZKbC7hPootP3gvczAQwzrRgYCzGkOHAsCdXHp7qztQt4o0
	s1ARWdtB51Sr8DEQ85d5zCckOgyoVixSDSdpATynDkM402yztElRiT57CAu8y8FavLiFPQOTHzo
	zLofbpO7nGFYnWDtcYOXbNT/d3NJFzNN5fI/gMV//M6YQJDhHF4BTSslNIcUhGfrSiyAHlJMQe8
	vIfumU9oS2XpO50YMR/ltTVs8MsG6bjwwQFxKEicQT+StRGRnjucO1s18b/8PAK7k8xWIcQlTD3
	O3NkWTtADihW+MzGC88wT3F8PWVjtyGEVdbk/ws3KDua/BVpfiObaK4lTJhlVNr4M/bPE20Zlq3
	ohhoOpaApwVQZeTRlaVt3vazd+mzQJ14DFLNz+Lu4hu9uaSMHrpcmRby4iAtXk+8m82mKcCybp+
	ZQaMAAZuj3gIr+g7pgrwigo8A1ir0+NoE9slSb5ZUH+tY/yZlxQKDlNCfusKmWlt5Tj4TDPydzK
	LYhHAgm2ExUlFwH9UU1EGz4fwVNcTQlB4ekyjCCBcnRH6aiFJ39fTmmRkQ==
X-Received: by 2002:a05:7300:c00e:20b0:35d:4e41:d2c2 with SMTP id 5a478bee46e88-36a4241b0b2mr10640559eec.33.1793484989524;
        Sat, 31 Oct 2026 15:16:29 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a61a0csm24037242eec.22.2026.10.31.15.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 15:16:28 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH v2 0/2] generic: test overlayfs casefold flags and whiteouts
Date: Sat, 31 Oct 2026 22:16:16 +0000
Message-ID: <20261031221618.153-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Add coverage for directory casefold flag changes and whiteout creation
on casefolded overlayfs layers, following the setup in generic/783.
The tests run on a casefold-capable backing filesystem and mount their
own overlay.

The tests cover patches 2 and 3 of the following kernel series:
https://lore.kernel.org/linux-unionfs/20261030113201.2921633-1-amir73il@gmail.com/

Tested on arm64 under QEMU with ext4 and tmpfs as the backing filesystems.
The baseline kernel was overlayfs ovl-fixes at 1d27da7de3f7. The fixed
kernel used the same baseline with all three patches from the series.

On both backing filesystems:
- generic/783 passes before and after the fixes.
- generic/998 fails before the fixes because a casefold flag change
  succeeds, and passes with the fixes.
- generic/999 fails before the fixes because removing a lower-only file
  returns EINVAL, and passes with the fixes.

The runtime tests used fstests at 22348afe338c. Both patches also apply
to for-next at d07dca72d245 and pass bash -n there; the runtime tests were
not repeated on that fstests base.

The tests also need "ovl: check the casefold flag of directories only",
which is included in the kernel baseline above. The fix hints use
placeholder IDs pending final kernel commit IDs. The test numbers
998 and 999 are temporary.

Changes in v2:
- Move the flag test into test_casefold() and call the enabled and
  disabled cases explicitly, as suggested by Amir.
- Add Amir's Reviewed-by to both patches.

v1: https://lore.kernel.org/r/20261031091948.18985-1-dennylin0707@gmail.com

Thanks,
Hungyu

Hungyu Lin (2):
  generic: test overlayfs casefold flag changes
  generic: test whiteouts on casefolded overlay layers

 tests/generic/998     | 147 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/998.out |   3 +
 tests/generic/999     | 148 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |   2 +
 4 files changed, 300 insertions(+)
