Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987065;
	b=Tgu7MkXwhnyViH0rkRHcvpzJ4NjYFpCdF2C7fDcypECCntX5s+8CnbH1ryIFOrF+twlM
	 R7tx2QqG1iqOygrcPlPIdKtXslg8rskGkvcT5f0H0ZozmxLja+AQVYXiHGzdvKIGcwChK
	 4x3JFpmffS+Z3ifI4dCTqUdbSdDXaKHo5oW+4KkXV9Owbdl5GfEDifI1kiOYirhgBTBaZ
	 FVluc+gG3JWoAzwRW6Rxre9JEY7qLING50aosB6XlOLSXPLX2o8PqkaLV+gIfooPLLL0c
	 BWGro1dXBLRaQFWQmEdhzJitwbKvyu5ZdNjOHpEMfpyV/6KEeFka6DsYn5i2Sy2XaGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987065;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0J5dycAQyrXi+H6VpoYIGTGq8GdbI4+vkynl3svKXOg=;
	b=mYjynKeIDlv/vTtURVX6DOtMP+WGSoGwZb3hG+l0EvMg2+XDny4Zct/ETtXySxZ/5Te7
	 XtqBmRtQmT76vGY+OKtewBruP2HQoGsT1U9wnq64KwJynWKL7ZVzAAenhrFM2vrFB20mS
	 rHqLDj6u+GDBK4mC88rYM3njSEuI5EFKAlXo2ByRwX39gI3llGxxHuiJ14XrVK3Eyu3FA
	 WLndPpjnqB3a1TSwrDO3DvLJgME+VlCsjYK4o8Pf4ayaqQjErSz+5reWKamIbLcSev1ua
	 cW9h9/SEPZ3UXOwku7pF/ta8tuMcRyVv3wSuSARSM9zIXqBDCsWPic92u+k8styBW4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iAzhnC6Z;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD9A606A325
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 07:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AD9A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iAzhnC6Z
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso825226a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2026 23:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987064; x=1795591864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0J5dycAQyrXi+H6VpoYIGTGq8GdbI4+vkynl3svKXOg=;
        b=iAzhnC6ZeE8qzx1JdcZTlHUSXA/9zvovXFevq4333M/ceTzJ21m5otRh1It8cwjBu0
         fGFNypOgpa3Uel/9HuXS5Y7k5QJETpP4OzhFD9nziZGZOyd45EH0Sa2oWM+LbM703Qtt
         wKFSbRPw5fT6bVrepVwauXuGCS8+2ql4tGPvEBXLQGgbXfGQCGmAjfmaPeiQqfXtr6mj
         uV4dZLl+y+ZXXBxwYLziegdFrf7kCRghzN5vJQ27U6GHU4fO5j0RfuluFF6aTXxrNxA9
         6e/8bBMNvsg+rC8CRNHABep1qQui/ulfzAChSimIzZS+CZ274bANl/xJFgtPX8UxaVFQ
         rzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987064; x=1795591864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0J5dycAQyrXi+H6VpoYIGTGq8GdbI4+vkynl3svKXOg=;
        b=lorNE/E/BZmtN9fAqXgtKY/PDBgz+/z1LQK0ljUT/JxQCph2amGNi55DES6WZJk1SV
         T5PIy/SLWt6GNdL2LrlZZ6gMeKNhL52c5bDnKbodkpxj7WyV7FiNiKdWMumZAuUD7mgC
         h7cWIlpG/Qp296ITOghT160fzvFRFc1Son4illRTX8MKY9nCQS3/c2JfNkg5/lxaO/VF
         3cCK5YHCg1/azS9mFSIHaK6FapZwmTP1MOd6k6IjDRRte3Ho46YG6qj24gKmVUHGUD6Q
         ml9+ba8jsvFsJ304xaosBAH30INtmFiiFawMgEx9PgUqKJgyILn4yBMNGEWduBSMnKhO
         WS5A==
X-Forwarded-Encrypted: i=1; AL+hErGSpxWnB2uOSi8Qv/4YKnLl2Z3F4W6ok4QTs/zqZ9reSC7riaL1HPkNn74hV18nugQf0UUA38Uc5QH/XZDA@vger.kernel.org
X-Gm-Message-State: APuU4Z9uARPecDgT4BSOtl3Phi0iX5yPS+DcqbHVo5tzAgPQ6y/IF4QR
	VYf50mzaUMkaJOAM7iDNRlX3Za5bg0agiwAaaFqFNzozyS7VFTRkMs4lJIj/XUWk
X-Gm-Gg: AYBFou1/6i6A13HIEPro9T3uLWNdmOWNS8hF4B49eHoaCdtaZUp3RAiYlbZ4DJd/4xL
	FRUnpeNtyGawfO0PN2yBZl2o3i6vHiueIC3sAmiNPzuun/f07HrfGaRtO7Ny1/sRh0d06D4C4gU
	aJVgkFl8LSojzbX8NoTOZSKNG8DiNEtpFxrmncTJx6NhlNzMAgyFPFUhakkvOT3eq1XOQLtj28w
	QZxmNLSmXCD/q4Zqh1KyVXC3wRYYo95aig7kxbWq6SCtQIqTDCK8i5HyuOE/sn5yuxUfDFs3Ycb
	h/V1LGDK0/gx2Gyvjzf/+HVUbuWJIeo6DTnRqdu+qulEF13heVyCX1nzEuJ+sBFM8JvKZ1JdBY9
	3aqPhFl8vR/x1NpQpBIkyVtxqqTvyEAcz5rs4gI9/DHI1UF5juce3AOY0qj+lNQx3lE6T3rI6n1
	dI3Aq5lAlgTINDr2u1u4tttXz0ffoWZEQVYtKooEWTGuwgLtj7cNp1osWJO2319Yr+gLFABEzfC
	vGJ9TL0sytLHz1F6KHnB8MLUeDZFGpd/zwiZfnC/bdLGpuM0boSy+RZGcHMZI4C5aMFlaGxBeNj
	T9SocMhwzsBkMkCLIslT7W1CsMHLWEkhCX/NPk+FNa2rciepgkIrtJRQx+OZVK2ZqBrgVaPy9i+
	AizLQw0nlE8Y=
X-Received: by 2002:a17:907:6d27:b0:c2e:2baa:a642 with SMTP id a640c23a62f3a-c510e4d265fmr134087166b.30.1794987063521;
        Tue, 17 Nov 2026 23:31:03 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c510c83fb8bsm66189466b.11.2026.11.17.23.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:31:02 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 0/6] ovl: restrict pseudo filesystems as overlayfs layers
Date: Wed, 18 Nov 2026 08:30:56 +0100
Message-ID: <20261118073102.1216568-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
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

Christian,

These patches are based on vfs-7.5.pseudofs.fixes and replace the two
patches I sent on top of "ovl: refuse data-only layers on pseudo
filesystems".

Pseudo filesystems are refused as upper layer and allowed as lower
layers only in legacy setups.

Thanks,
Amir.

Amir Goldstein (6):
  ovl: do not change redirect_dir=follow to on in a non-upper mount
  ovl: do not allow offline lower changes with data-only layers
  ovl: refuse pseudo filesystem as upper layer
  ovl: refuse pseudo lower layers unless offline lower changes are
    allowed
  selftests/ovl: test pseudo filesystem upper and lower layers
  selftests/ovl: use legacy setups for pseudo lower layer tests

 Documentation/filesystems/overlayfs.rst       |   7 +-
 fs/overlayfs/overlayfs.h                      |   4 +-
 fs/overlayfs/params.c                         |  19 +--
 fs/overlayfs/super.c                          |   9 +-
 .../overlayfs/automount_in_layer.c            |   6 +-
 .../filesystems/overlayfs/pseudo_datadir.c    | 111 ++++++++++++++++--
 6 files changed, 131 insertions(+), 25 deletions(-)

-- 
2.56.1

