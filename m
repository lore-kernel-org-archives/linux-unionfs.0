Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOfO16tz"
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31A0109;
	Mon,  4 Dec 2023 10:59:07 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40b5155e154so50348425e9.3;
        Mon, 04 Dec 2023 10:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701716346; x=1702321146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RATYSxcN4+cyOCgb1z/RSWxeWjRFq2iEI2fuC5in9vs=;
        b=dOfO16tz6mtY5oMk9Ge9b1rGRfFLWSC9jKpULBSiAcFK86QIFFLHdj+ht7Qt4GQEs+
         r7sH46AAIaZP08B1V9UDKe6Aq2NBtdBtt+v6b2JJceIQLoe6TnTvRmwExxjQOBdKtTBG
         vgvHDMRSoZJjs6E3ijcua1OIdCx2og/MhMNTfxiawtvif/W/r7verKwu4j21bkZTVRNN
         fl1q2zrbiP9eh9jkSgxcwXix0GOjLLfzODWOrQp/ghkOjCy1WrS7kkL7GuQN04YogmqF
         h4pPz98cn2fjvvAEAs4G3bNcY0AUaZtZ61dCd9QNm1Htr4SHVWSmt0KXRhei20ECySO+
         IZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701716346; x=1702321146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RATYSxcN4+cyOCgb1z/RSWxeWjRFq2iEI2fuC5in9vs=;
        b=xUHsevqYmRjdbTvYX5JPpIEJeCaOQHz7RDuXKCmCoEl0Gjj8pKMfgXciI/Ep2ohP/y
         cgKUHrWiVNlG/dMybHDaCK58lnH9Ej7JibhCVW8DKy4djrpHr458I8HrF/nGg+0spf0B
         YLBmf/CUbi/KRddaGH+GTyKrcLrZoiFIiC8TboNCJYuL+zjn+aJegqQJyT17f1xjAbye
         04SzItLsaA5ZbSw3qh+EjIjHexrtgFaX8BHE/dre/TWCrSuhm5Hx99ftNiCCJaJlpEOP
         f7xv44fRzxxh+n9ow0JvjQramF6V5mz2rU2tlCDbv8sK4WjG7XFv+fUZ+lOX0M0hfrug
         S3Ig==
X-Gm-Message-State: AOJu0YwCnc6E/wQRtbM9JoubSsPlqMVmOJM9XUfj50ocNFX+ZxJwvbxy
	pDie8o+5ccjEgdePPmS/tSSghvUBjD0=
X-Google-Smtp-Source: AGHT+IFR4PyhGNFo4eZiB11m3unHJEhaj/pgnyHGFMojXVQ+29bGqxKCMs5gXv5PrqRV6cOnN5DEQQ==
X-Received: by 2002:a05:600c:1e20:b0:40b:5e4a:4088 with SMTP id ay32-20020a05600c1e2000b0040b5e4a4088mr2508003wmb.168.1701716346120;
        Mon, 04 Dec 2023 10:59:06 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id d9-20020a05600c34c900b0040b2c195523sm20008098wmq.31.2023.12.04.10.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:59:05 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 0/4] Overlayfs tests for 6.7-rc1
Date: Mon,  4 Dec 2023 20:58:55 +0200
Message-Id: <20231204185859.3731975-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zorro,

This update contains 3 new overlayfs tests for new features added
in v6.7-rc1.

overlay/084, written by Alexander, tests the new nested xattrs feature.
overlay/{085,086} test the new lowerdir+,datadir+ mount options.

overlay/086 was partly forked from overlay/083, but overlay/083 is not
sensitive to libmount version, because the escaped commas test is not
related to any specific mount option, so it wasn't copied over.

All the new tests do not run on older kernels.

Thanks,
Amir.

Changed since v1:
- Helper _require_scratch_overlay_xattr_escapes() already added by
  "overlay/026: Fix test expectation for newer kernels"

Amir Goldstein (4):
  overlay: Add tests for nesting private xattrs
  overlay: prepare for new lowerdir+,datadir+ tests
  overlay: test data-only lowerdirs with datadir+ mount option
  overlay: test parsing of lowerdir+,datadir+ mount options

 common/overlay        |  15 ++
 tests/overlay/079     |  36 +++--
 tests/overlay/084     | 169 +++++++++++++++++++++
 tests/overlay/084.out |  61 ++++++++
 tests/overlay/085     | 332 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/085.out |  42 ++++++
 tests/overlay/086     |  81 +++++++++++
 tests/overlay/086.out |   2 +
 8 files changed, 723 insertions(+), 15 deletions(-)
 create mode 100755 tests/overlay/084
 create mode 100644 tests/overlay/084.out
 create mode 100755 tests/overlay/085
 create mode 100644 tests/overlay/085.out
 create mode 100755 tests/overlay/086
 create mode 100644 tests/overlay/086.out

-- 
2.34.1

